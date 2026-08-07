# Development environment

## Prerequisite policy

- **CPython:** 3.12 minimum, as defined by [ADR-001](decisions/ADR-001-select-language-runtime.md). Additional CPython minor versions become supported only after they are added to the validation matrix.
- **uv:** a currently supported stable release, with version 0.12.2 or later required by project configuration. The clean-clone validation used uv 0.12.2.
- **Git:** a version supported by the target Ubuntu environment. The clean-clone validation used Git 2.53.0.
- **Ubuntu:** clean-clone validation was performed on Ubuntu 24.04.4 LTS.

The `.python-version` file asks uv for the current CPython 3.12 patch release. `requires-python = ">=3.12"` is the project-level Python requirement; `required-version = ">=0.12.2"` makes the tested minimum uv release enforceable without preventing later supported stable releases.

## Bootstrap from a clean checkout

```bash
git clone https://github.com/genejgaudenzi/generic-audit-tool.git
cd generic-audit-tool
uv sync
```

`uv sync` creates `.venv` and installs the locked development tools. uv downloads a suitable CPython 3.12 interpreter when one is not already available. Do not commit `.venv` or machine-specific configuration.

## Everyday commands

Run these commands from the repository root:

```bash
uv run ruff format --check .
uv run ruff check .
uv run pyright
uv run pytest
```

To apply Ruff formatting, use `uv run ruff format .`. After changing dependencies, run `uv lock` followed by `uv sync`, and commit the resulting `uv.lock` when it changes.

## Tooling policy

- `uv` manages the virtual environment, interpreter selection, dependencies, and lockfile.
- Ruff provides formatting and lint checks.
- Pyright performs static type checks over `src/` and `tests/`.
- Pytest runs the test suite. The current environment test verifies the CPython minimum; it does not implement product behavior.

## Troubleshooting

**`uv: command not found`** — Install uv using the instructions for your platform at [docs.astral.sh/uv](https://docs.astral.sh/uv/getting-started/installation/), restart the shell if necessary, and verify with `uv --version`.

**Unexpected Python version** — Run `uv python find 3.12`. If no interpreter is found, run `uv python install 3.12`, then repeat `uv sync`.

**Tools appear stale after configuration changes** — Run `uv lock` and `uv sync` before rerunning the checks.

**A check reports generated files** — Remove the generated output, or add an appropriate ignore rule only when the output is a deliberate local artifact. Never place credentials or secrets in project configuration.
