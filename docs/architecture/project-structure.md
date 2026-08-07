# Project structure

The canonical repository structure is defined by [ADR-002](../decisions/ADR-002-define-repository-structure.md). This page is a directory map, not an implementation design.

```text
.
├── .github/                 Pull-request template and future collaboration metadata
├── docs/                    Product, architecture, governance, decisions, and schemas
├── examples/                Versioned, non-secret sample inputs
├── scripts/                 Repository-maintenance workflows
├── src/
│   └── generic_audit_tool/  First-party Python package namespace
├── tests/
│   ├── integration/         Integration tests
│   ├── unit/                Unit tests
│   └── fixtures/            Shared fixtures when needed
├── artifacts/               Ignored local generated reports and artifacts
├── pyproject.toml           Python tooling configuration
└── uv.lock                  Locked development dependencies
```

`artifacts/` and `tests/fixtures/` are canonical locations but are created only when needed. The tracked `src/generic_audit_tool/.gitkeep` preserves the application source namespace without creating application modules. Existing rule, reporting, and plugin-facing material will live below that namespace as described in ADR-002; their detailed boundaries and contracts are deferred to ADR-003.
