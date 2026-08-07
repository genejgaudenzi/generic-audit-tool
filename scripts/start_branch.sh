#!/usr/bin/env bash
set -euo pipefail

# Start a new feature branch from the latest default branch.
#
# Usage:
#   scripts/start_branch.sh GEN-9 adr-001-select-language-runtime
#
# Creates:
#   genejgaudenzi/gen-9-adr-001-select-language-runtime
#
# Optional environment variables:
#   DEFAULT_BRANCH=main
#   REMOTE=origin
#   BRANCH_PREFIX=genejgaudenzi
#   PUSH_BRANCH=1

DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"
REMOTE="${REMOTE:-origin}"
BRANCH_PREFIX="${BRANCH_PREFIX:-genejgaudenzi}"
PUSH_BRANCH="${PUSH_BRANCH:-1}"

usage() {
	cat <<'USAGE'
Usage:
  scripts/start_branch.sh <issue-id> <slug>

Example:
  scripts/start_branch.sh GEN-9 adr-001-select-language-runtime

Creates:
  <BRANCH_PREFIX>/<lowercase-issue-id>-<normalized-slug>

Optional environment variables:
  DEFAULT_BRANCH=main
  REMOTE=origin
  BRANCH_PREFIX=genejgaudenzi
  PUSH_BRANCH=1

Set PUSH_BRANCH=0 to create the branch locally without pushing it.
USAGE
}

case "${1:-}" in
	--help|-h)
		usage
		exit 0
		;;
esac

if [[ "$#" -ne 2 ]]; then
	echo "ERROR: Expected exactly two arguments." >&2
	echo >&2
	usage >&2
	exit 1
fi

ISSUE_ID="$1"
SLUG="$2"

command -v git >/dev/null 2>&1 || {
	echo "ERROR: git is required." >&2
	exit 1
}

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
	echo "ERROR: This command must be run inside a Git repository." >&2
	exit 1
}

cd "$REPO_ROOT"

if ! git remote get-url "$REMOTE" >/dev/null 2>&1; then
	echo "ERROR: Git remote '$REMOTE' does not exist." >&2
	exit 1
fi

if [[ ! "$ISSUE_ID" =~ ^[A-Za-z]+-[0-9]+$ ]]; then
	echo "ERROR: Invalid issue ID '$ISSUE_ID'." >&2
	echo "Expected a value such as GEN-9." >&2
	exit 1
fi

NORMALIZED_ISSUE_ID="$(
	printf '%s' "$ISSUE_ID" |
		tr '[:upper:]' '[:lower:]'
)"

NORMALIZED_SLUG="$(
	printf '%s' "$SLUG" |
		tr '[:upper:]' '[:lower:]' |
		sed -E \
			-e 's/[^a-z0-9]+/-/g' \
			-e 's/^-+//' \
			-e 's/-+$//' \
			-e 's/-+/-/g'
)"

if [[ -z "$NORMALIZED_SLUG" ]]; then
	echo "ERROR: The branch slug is empty after normalization." >&2
	exit 1
fi

BRANCH_NAME="${BRANCH_PREFIX}/${NORMALIZED_ISSUE_ID}-${NORMALIZED_SLUG}"

echo "==> Branch to create"
echo "  $BRANCH_NAME"

echo "==> Checking working tree"
if [[ -n "$(git status --porcelain)" ]]; then
	echo "ERROR: Working tree has uncommitted changes." >&2
	echo >&2
	git status --short >&2
	echo >&2
	echo "Commit, stash, or discard these changes before starting a branch." >&2
	exit 1
fi

echo "==> Fetching and pruning $REMOTE"
git fetch "$REMOTE" --prune

if ! git show-ref --verify --quiet "refs/remotes/$REMOTE/$DEFAULT_BRANCH"; then
	echo "ERROR: Remote branch '$REMOTE/$DEFAULT_BRANCH' does not exist." >&2
	exit 1
fi

if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
	echo "ERROR: Local branch '$BRANCH_NAME' already exists." >&2
	echo "Switch to it with:" >&2
	echo "  git switch '$BRANCH_NAME'" >&2
	exit 1
fi

if git show-ref --verify --quiet "refs/remotes/$REMOTE/$BRANCH_NAME"; then
	echo "ERROR: Remote branch '$REMOTE/$BRANCH_NAME' already exists." >&2
	echo "Create a local tracking branch with:" >&2
	echo "  git switch --track '$REMOTE/$BRANCH_NAME'" >&2
	exit 1
fi

CURRENT_BRANCH="$(git branch --show-current)"

if [[ "$CURRENT_BRANCH" != "$DEFAULT_BRANCH" ]]; then
	echo "==> Switching from $CURRENT_BRANCH to $DEFAULT_BRANCH"
	git switch "$DEFAULT_BRANCH"
else
	echo "==> Already on $DEFAULT_BRANCH"
fi

echo "==> Updating $DEFAULT_BRANCH from $REMOTE/$DEFAULT_BRANCH"
git pull --ff-only "$REMOTE" "$DEFAULT_BRANCH"

echo "==> Creating branch $BRANCH_NAME"
git switch -c "$BRANCH_NAME"

if [[ "$PUSH_BRANCH" == "1" ]]; then
	echo "==> Pushing branch to $REMOTE"
	git push -u "$REMOTE" "$BRANCH_NAME"
elif [[ "$PUSH_BRANCH" == "0" ]]; then
	echo "==> PUSH_BRANCH=0; branch remains local"
else
	echo "ERROR: PUSH_BRANCH must be 0 or 1, not '$PUSH_BRANCH'." >&2
	exit 1
fi

echo
echo "Branch ready:"
echo "  $BRANCH_NAME"

echo
echo "Current status:"
git status --short --branch