#!/usr/bin/env bash
set -euo pipefail

# Finish a merged feature branch:
# - verify the working tree is clean
# - verify the current branch has a merged GitHub pull request
# - switch to the default branch
# - pull the latest remote default branch
# - prune stale remote-tracking branches
# - delete the finished local branch
# - delete any additional local branches Git identifies as merged
#
# This supports squash-merged pull requests, which are not reliably detected by:
#   git branch --merged
#
# Usage:
#   scripts/finish_branch.sh
#   scripts/finish_branch.sh --dry-run
#
# Optional environment variables:
#   DEFAULT_BRANCH=main
#   REMOTE=origin

DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"
REMOTE="${REMOTE:-origin}"
DRY_RUN=0

usage() {
	cat <<'USAGE'
Usage:
  scripts/finish_branch.sh
  scripts/finish_branch.sh --dry-run

Options:
  --dry-run  Show branches that would be deleted without deleting them.
  --help     Show this help message.

Optional environment variables:
  DEFAULT_BRANCH=main
  REMOTE=origin
USAGE
}

case "${1:-}" in
	"")
		;;
	--dry-run)
		DRY_RUN=1
		;;
	--help|-h)
		usage
		exit 0
		;;
	*)
		echo "ERROR: Unknown argument: $1" >&2
		echo >&2
		usage >&2
		exit 1
		;;
esac

command -v git >/dev/null 2>&1 || {
	echo "ERROR: git is required." >&2
	exit 1
}

command -v gh >/dev/null 2>&1 || {
	echo "ERROR: GitHub CLI (gh) is required." >&2
	echo "Install it or run this script from a GitHub Codespace." >&2
	exit 1
}

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
	echo "ERROR: This command must be run inside a Git repository." >&2
	exit 1
}

cd "$REPO_ROOT"

echo "==> Checking working tree"
if [[ -n "$(git status --porcelain)" ]]; then
	echo "ERROR: Working tree has uncommitted changes." >&2
	echo >&2
	git status --short >&2
	echo >&2
	echo "Commit, stash, or discard these changes before finishing the branch." >&2
	exit 1
fi

CURRENT_BRANCH="$(git branch --show-current)"

if [[ -z "$CURRENT_BRANCH" ]]; then
	echo "ERROR: Detached HEAD state detected." >&2
	echo "Switch to the feature branch before running this script." >&2
	exit 1
fi

if [[ "$CURRENT_BRANCH" == "$DEFAULT_BRANCH" ]]; then
	echo "ERROR: You are already on '$DEFAULT_BRANCH'." >&2
	echo "Run this script from the merged feature branch." >&2
	exit 1
fi

echo "==> Verifying GitHub authentication"
gh auth status >/dev/null

echo "==> Checking pull request for $CURRENT_BRANCH"

PR_STATE="$(
	gh pr view "$CURRENT_BRANCH" \
		--json state \
		--jq '.state'
)"

PR_MERGED_AT="$(
	gh pr view "$CURRENT_BRANCH" \
		--json mergedAt \
		--jq '.mergedAt // ""'
)"

PR_BASE="$(
	gh pr view "$CURRENT_BRANCH" \
		--json baseRefName \
		--jq '.baseRefName'
)"

PR_URL="$(
	gh pr view "$CURRENT_BRANCH" \
		--json url \
		--jq '.url'
)"

if [[ "$PR_STATE" != "MERGED" || -z "$PR_MERGED_AT" ]]; then
	echo "ERROR: The pull request for '$CURRENT_BRANCH' is not merged." >&2
	echo "PR: $PR_URL" >&2
	echo "State: $PR_STATE" >&2
	exit 1
fi

if [[ "$PR_BASE" != "$DEFAULT_BRANCH" ]]; then
	echo "ERROR: The pull request was merged into '$PR_BASE', not '$DEFAULT_BRANCH'." >&2
	echo "PR: $PR_URL" >&2
	exit 1
fi

echo "Merged PR confirmed: $PR_URL"

echo "==> Fetching and pruning remote branches"
git fetch "$REMOTE" --prune

echo "==> Switching to $DEFAULT_BRANCH"
git switch "$DEFAULT_BRANCH"

echo "==> Pulling latest $REMOTE/$DEFAULT_BRANCH"
git pull --ff-only "$REMOTE" "$DEFAULT_BRANCH"

echo "==> Refreshing remote branch pruning"
git fetch "$REMOTE" --prune

echo "==> Finished branch"
echo "  $CURRENT_BRANCH"

if [[ "$DRY_RUN" -eq 1 ]]; then
	echo "Dry run: would delete local branch '$CURRENT_BRANCH'."
else
	echo "==> Deleting finished local branch"
	git branch -D "$CURRENT_BRANCH"
fi

echo "==> Finding other local branches merged into $DEFAULT_BRANCH"

mapfile -t MERGED_BRANCHES < <(
	git branch --merged "$DEFAULT_BRANCH" |
		sed 's/^[* ]*//' |
		grep -vE "^(${DEFAULT_BRANCH}|main|master|dev|develop)$" |
		grep -v '^$' || true
)

if [[ "${#MERGED_BRANCHES[@]}" -eq 0 ]]; then
	echo "No additional merged local branches found."
else
	echo "Additional merged local branches:"
	printf '  %s\n' "${MERGED_BRANCHES[@]}"

	if [[ "$DRY_RUN" -eq 1 ]]; then
		echo "Dry run: no additional branches deleted."
	else
		echo "==> Deleting additional merged local branches"
		for branch in "${MERGED_BRANCHES[@]}"; do
			git branch -d "$branch"
		done
	fi
fi

echo
echo "==> Local branch status"
git branch -vv

echo
echo "Branch cleanup complete."