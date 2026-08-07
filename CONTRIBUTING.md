# Contributing

Thank you for helping build the Generic Audit Tool.

## Before making changes

1. Review the relevant material in `docs/` and any linked Linear issue.
2. Keep changes focused on the issue and avoid adding generated artifacts, credentials, or secrets.
3. Do not introduce a runtime, programming language, framework, or package structure until that decision is made in the appropriate architecture decision record.

## Architectural traceability

Before implementation begins, every change must identify:

- the [Product Vision](docs/product/vision.md) principles it supports;
- the related requirements; and
- the related accepted [ADRs](docs/decisions/README.md).

Record this traceability in the Linear implementation issue and carry it into the pull request. Follow the [project decision hierarchy](docs/governance/decision-hierarchy.md): implementation must not contradict a higher-level decision unless that decision is intentionally evolved first.

## Development workflow

Follow the [development environment guide](docs/development.md) to bootstrap the project and run local checks. For documentation and scaffold changes, check links and Markdown formatting where practical, review `git diff`, and confirm only intended files are staged.

## Repository workflow

Follow the [repository standards](docs/governance/repository-standards.md) for Linear issue and branch handling, commits, pull requests, required local checks, repository hygiene, and release-note expectations.
