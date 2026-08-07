# ADR-002: Define Repository Structure

- **Status:** Proposed
- **Date:** 2026-08-07
- **Decision:** Adopt a `src/`-based Python source layout with one `generic_audit_tool` package namespace, supported by clearly separated tests, documentation, examples, scripts, and generated local artifacts.

## Context

ADR-001 selected CPython 3.12+ for the MVP. The repository now has a reproducible Python development environment and contribution workflow, but its source placeholders predate an agreed structure and have no documented responsibility. This decision defines where future work belongs without implementing application behavior or deciding internal component contracts.

## Decision drivers

- Keep implementation, test, documentation, examples, and generated output distinct.
- Support deterministic local development with the existing uv, Ruff, Pyright, and Pytest configuration.
- Make a Python package boundary explicit without enabling packaging or distribution behavior.
- Give later architecture work a stable location for built-in rules, reports, and future plugin-facing code.
- Avoid speculative module/API design before ADR-003.

## Decision

Use the following canonical top-level structure. A documented future location does not require an empty directory to be created before work needs it.

| Location | Responsibility |
| --- | --- |
| `.github/` | Pull-request collaboration templates; CI remains deferred. |
| `docs/` | Product, architecture, governance, decision, schema, and contributor documentation. |
| `examples/` | Versioned, non-secret sample inputs and expected illustrative materials. |
| `scripts/` | Repository-maintenance workflows, including branch start and finish scripts. |
| `src/` | Application source root; it contains the `generic_audit_tool` package namespace. |
| `tests/` | Automated tests, divided by test intent and shared fixtures. |
| `pyproject.toml`, `uv.lock`, `.python-version` | Python/runtime and local-tooling configuration defined by GEN-6. |
| Root policy files | Repository entry points such as `README.md`, `CONTRIBUTING.md`, `.gitignore`, and the license decision. |

### Python source placement

`src/generic_audit_tool/` is the single first-party Python package namespace. It is retained as a structure-only marker; no application module is implemented by this ADR. Future modules belong beneath that namespace rather than at the repository root.

The following are placement rules, not component/API definitions:

| Future material | Canonical location |
| --- | --- |
| Application source | `src/generic_audit_tool/` |
| Built-in rules and rule resources | `src/generic_audit_tool/rules/` |
| Report rendering resources and templates | `src/generic_audit_tool/reporting/` |
| Plugin-facing boundary code | `src/generic_audit_tool/plugins/` |
| Unit tests | `tests/unit/` |
| Integration tests | `tests/integration/` |
| Shared test fixtures | `tests/fixtures/` |
| Examples | `examples/` |
| Versioned schemas and schema documentation | `docs/schemas/` |
| Repository scripts | `scripts/` |
| Runtime/tool configuration | root configuration files, beginning with `pyproject.toml` |

The paths for rules, reporting, and plugins reserve a clear home; their module boundaries, contracts, discovery, and loading are deferred.

### Generated-output policy

Generated environments, caches, bytecode, coverage, build output, and logs remain excluded through `.gitignore`. Generated audit reports and other local artifacts must be written outside the repository when practical. If they must be retained in a working tree, use `artifacts/`, which is ignored and must not be treated as a source or fixture location. Version-controlled examples and fixtures must be small, reviewable, and free of secrets.

### Broad dependency direction

Dependency direction is intentionally coarse:

- Product-facing entry points, report presentation, and plugin adapters may depend on stable internal capabilities.
- Shared audit capabilities must not depend on CLI presentation, report rendering, or external plugin implementations.
- Tests may depend on production source and fixtures; production source must not depend on test material.
- Documentation, examples, and scripts may describe or invoke supported interfaces but are not imported by application source.

ADR-003 will define the detailed components, contracts, failure behavior, and allowed dependencies within these broad rules.

### Future plugin boundary

`src/generic_audit_tool/plugins/` is the future home for the first-party plugin boundary only. External plugins remain outside the core repository and must not require the core to import external implementations directly. Plugin discovery, lifecycle, compatibility, isolation, and distribution are deferred.

## Alternatives considered

- **Flat repository-root Python modules:** rejected because local imports can mask packaging and source-layout mistakes.
- **Keep the existing empty placeholder modules:** rejected because their names have no accepted responsibilities and would prematurely imply component boundaries.
- **Create every future subpackage now:** rejected because empty skeletons would be speculative before GEN-11 defines component boundaries.
- **Separate repositories for rules or plugins now:** rejected because the extension contract and distribution model are not decided.

## Consequences and risks

- Future implementation work has a stable, discoverable location without changing the non-packaged GEN-6 configuration.
- The removal of old empty placeholder modules means later work must create a module only when its responsibility is accepted and needed.
- A `src/` layout requires future packaging/build decisions to account for that root; this ADR does not select a build backend or distribution strategy.
- Generated artifacts have a documented local location, but output-path defaults remain a later application/configuration decision.

## Explicitly deferred

- Detailed component APIs, contracts, dependency injection, and service wiring
- Detailed component boundaries and internal dependency rules (ADR-003 / GEN-11)
- Plugin loading, discovery, compatibility, and isolation
- Package distribution and build strategy
- CLI framework selection
- CI and repository-rule enforcement
- Application implementation

No standalone Coding Standards document currently exists. This ADR does not introduce implementation-specific coding rules; it updates structure and placement only.
