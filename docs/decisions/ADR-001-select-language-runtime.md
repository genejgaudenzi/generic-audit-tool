# ADR-001: Select Language and Runtime

- **Status:** Accepted
- **Date:** 2026-08-07
- **Decision:** Use Python on the CPython runtime for the MVP.

## Context

The Generic Audit Tool will begin as a cross-platform local CLI that reads filesystem and Git-repository inputs, produces deterministic validator-backed results, and can later support rules and plugins. Ubuntu is the first validated environment. This decision selects the primary implementation language and runtime only; it does not select a framework, package layout, library set, or build tooling.

## Decision drivers

The evaluation reflects the requirements captured in GEN-9:

1. Local CLI distribution and startup experience
2. Filesystem and Git repository processing
3. Deterministic execution
4. Cross-platform support, with Ubuntu first
5. An extensible rule and plugin model
6. Performance on medium-sized repositories
7. Developer productivity and maintainability
8. Testing, packaging, and release ecosystem

## Candidate comparison

| Candidate | Strengths | Tradeoffs |
| --- | --- | --- |
| Python (CPython) | Fast iteration; mature filesystem, subprocess, Git, testing, packaging, and plugin ecosystems; accessible extension language for audit rules. | Startup time and CPU-bound work are weaker than compiled alternatives; distribution needs deliberate packaging. |
| Go | Single-binary distribution, fast startup, strong concurrency, and reliable cross-platform tooling. | Rule/plugin extension is less natural; developer ergonomics for rich document and repository analysis are less favorable for this MVP. |
| Rust | Strong performance, safe concurrency, and distributable binaries. | Higher implementation and contributor-learning cost; dynamic plugin and rule extension adds complexity. |
| Java | Mature tooling, good portability, and solid performance. | Heavier CLI startup and distribution experience; more ceremony than the MVP needs. |

## Weighted evaluation

Each criterion is scored from 1 (weak fit) to 5 (strong fit). The weighted score is the sum of `weight × score`, divided by 100; the maximum is 5.00. Scores are a structured comparison, not a claim of benchmarked performance.

| Criterion | Weight | Python | Go | Rust | Java |
| --- | ---: | ---: | ---: | ---: | ---: |
| Local CLI distribution and startup | 15 | 5 | 5 | 4 | 3 |
| Filesystem and Git processing | 15 | 5 | 4 | 4 | 4 |
| Deterministic execution | 10 | 4 | 5 | 5 | 4 |
| Cross-platform support | 10 | 5 | 5 | 5 | 5 |
| Rules and plugin model | 15 | 5 | 3 | 3 | 3 |
| Medium-repository performance | 10 | 3 | 4 | 5 | 4 |
| Developer productivity and maintainability | 15 | 5 | 4 | 2 | 4 |
| Testing, packaging, and release ecosystem | 10 | 5 | 4 | 3 | 4 |
| **Weighted total (out of 5.00)** | **100** | **4.70** | **4.20** | **3.75** | **3.80** |

Python is the preferred fit because the expected MVP value comes from reliable repository analysis, clear evidence handling, and a maintainable extension surface—not maximizing raw throughput. Go remains the strongest alternative if single-binary distribution or startup time becomes the dominant constraint. Rust remains appropriate for a future performance-critical component, and Java remains viable where existing JVM platform integration changes the constraints.

## Decision

Implement the MVP in Python using CPython. Prefer clear, deterministic, testable code over runtime-specific optimization. Profile representative repository workloads before introducing native extensions, multiprocessing, or a second implementation language.

## Supported-version policy

- The initial minimum supported runtime is **CPython 3.12**.
- The minimum supported runtime is CPython 3.12. Additional CPython minor versions become supported once they are included in the project's validation matrix. Support for a minor version ends only through a documented project decision or release.
- Test the oldest supported CPython version and the newest supported CPython version in the project validation matrix once CI is introduced.
- Remove an end-of-life Python minor version only in a documented release, after updating the supported-version statement and validation matrix.
- Alternative Python implementations are not supported initially; compatibility may be evaluated later without changing this decision.

## Consequences

### Tooling

Future development-environment work will use Python-native environment and dependency management. The exact formatter, linter, type checker, and task runner are deferred to the development-environment work; their configuration must support the version policy above.

### Packaging and distribution

The project will use standard Python package metadata and packaging conventions when GEN-6 establishes the development environment. The distribution form (for example, an installable package, self-contained executable, or both) remains a separate decision, informed by the local-CLI driver.

### Plugins and rules

Rules and plugins may use Python extension mechanisms, but the plugin contract, discovery mechanism, compatibility policy, and sandboxing model remain undecided. They must be designed so that validator-backed evidence—not plugin assertions alone—determines completion.

### Testing

Tests will run on the supported CPython versions and prioritize deterministic fixtures for filesystem and Git inputs. The test framework and supporting libraries are intentionally deferred; the standard library remains available as a baseline until the development-environment decision is made.

## Risks and follow-up

- Packaging and startup experience may be less convenient than a single compiled binary; evaluate them with real CLI workflows before committing to a distribution strategy.
- CPU-bound analysis may require optimization; first measure representative repositories and preserve deterministic behavior.
- A Python plugin surface can expose dependency and isolation risks; define versioning, trust, and isolation requirements before enabling third-party plugins.

This decision unblocks GEN-6 and informs ADR-002 and ADR-003 without prescribing their outcomes.
