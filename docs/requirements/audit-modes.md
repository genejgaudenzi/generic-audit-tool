# Generic Audit Tool MVP Audit Modes

## 1. Purpose and Authority

This document is the normative specification of the audit capabilities available in the Generic Audit Tool MVP and the rules by which they compose. It defines **what** each audit mode must accomplish and the conceptual artifacts it consumes or produces. It does not define scanners, libraries, APIs, schemas, or execution mechanics.

This specification implements the audit-capability portion of the MVP requirements baseline in [MVP Requirements](requirements-v1.md). It aligns with the [Product Vision](../product/vision.md), [Decision Hierarchy and Work-Item Traceability](../governance/decision-hierarchy.md), and accepted [ADR-001](../decisions/ADR-001-select-language-runtime.md), [ADR-002](../decisions/ADR-002-define-repository-structure.md), and [ADR-003](../decisions/ADR-003-define-core-component-boundaries.md).

## 2. Normative Principles

The MVP audit modes shall follow these principles:

- Every audit shall begin with **Repository Understanding**.
- Repository Understanding shall be mandatory and shall construct the per-run, ephemeral **Repository Knowledge Model** (RKM).
- Applicable downstream modes shall consume the RKM and **Claim Catalog** created for the same audit run.
- Audit modes are composable capabilities, not isolated scanners.
- Source code is the operational source of truth. Documentation, requirements, architecture records, and ADRs express intent.
- Authoritative **Findings** shall be supported by deterministic **Evidence**. LLMs may assist understanding but shall not determine truth.
- **Reports** consume Findings and **Run Summaries** and shall perform no analysis or Finding creation.
- **Execution Issues** describe audit-process limitations or failures and are distinct from Findings about the repository.

## 3. MVP Audit-Mode Taxonomy

The MVP contains exactly these six audit modes:

1. Repository Understanding
2. Documentation Verification
3. Documentation Drift
4. Claim Verification
5. Architecture Conformance
6. Repository Health

The modes share a common audit run and its conceptual artifacts. A mode may be applicable or not applicable to a repository or selected audit scope, but no downstream mode may begin before Repository Understanding has completed sufficiently to provide the RKM and Claim Catalog.

## 4. Common Inputs, Outputs, and Boundaries

### 4.1 Common inputs

Each applicable mode shall operate within one audit run and use the validated repository scope and audit options. Downstream modes shall use the RKM and Claim Catalog from that same run, together with the relevant deterministic Evidence and Observations.

### 4.2 Common outputs

A mode may produce or contribute to the following conceptual artifacts:

- Claims in the Claim Catalog;
- deterministic Evidence;
- reusable Observations;
- Verifications of Claims;
- Findings with relevant traceability and remediation guidance when actionable; and
- Execution Issues where the mode cannot complete or has a material limitation.

Findings and Execution Issues shall remain distinct. A Finding communicates an evidence-backed repository condition; an Execution Issue communicates a limitation or failure of configuration, discovery, understanding, verification, contribution acceptance, or output production.

### 4.3 Result flow

Orchestration shall combine the results of applicable modes into the Run Summary for the audit run. Reporting shall consume Findings, the Run Summary, and any representable Execution Issues. Reporting shall not re-evaluate Claims, collect Evidence, create Observations or Verifications, or create Findings.

## 5. Audit-Mode Composition and Dependency Model

### 5.1 Required composition order

The conceptual composition is:

```text
Local Repository
  → Repository Understanding
  → Repository Knowledge Model and Claim Catalog
  → applicable Documentation Verification, Documentation Drift,
    Claim Verification, Architecture Conformance, and Repository Health
  → Findings and Execution Issues
  → Run Summary
  → Reporting
```

This expresses artifact and dependency flow, not an API, module, concurrency, or scanner design.

### 5.2 Shared RKM and Claim Catalog

Repository Understanding shall build one ephemeral RKM for the audit run and support generation of one first-class Claim Catalog for that run. Applicable downstream modes shall share those artifacts rather than construct independent repository understandings or incompatible Claim collections.

The RKM supports repository comprehension and does not determine truth. The Claim Catalog records normalized assertions that may be evaluated. Each downstream mode shall preserve the provenance needed to relate its Verifications and Findings to the relevant Claims, Evidence, Observations, and audit run.

### 5.3 Mode applicability and limitations

The RKM and Claim Catalog may establish that a downstream mode is not applicable to the repository or selected scope. Such an outcome is not itself a Finding. Missing, inaccessible, excluded, unsupported, or insufficient material shall be made visible through an appropriate Execution Issue or unresolved Verification where applicable; it shall not be converted into an unsupported conclusion.

## 6. Repository Understanding

### Purpose

Repository Understanding shall construct the RKM before any downstream audit mode evaluates Claims. It establishes reusable context about the local repository’s organization, technologies, entry points, documentation, architecture, and relevant relationships.

### User value

It enables subsequent capabilities to evaluate the repository as a coherent system rather than as disconnected files or isolated scanner outputs.

### Required inputs

- The selected local repository and validated audit scope.
- Eligible repository content and applicable discovery information.

### Conceptual outputs

- The ephemeral, per-run RKM.
- Support for the per-run Claim Catalog.
- Candidate Claims and candidate deterministic Evidence sources for applicable downstream modes.
- Execution Issues for material limitations in understanding the repository.

### Claims evaluated

Repository Understanding does not evaluate Claims or determine their truth. It may identify and normalize candidate Claims for the Claim Catalog.

### Expected Evidence sources

Repository structure, source code, tests, configuration, build definitions, dependencies as repository material, documentation, and other eligible local repository artifacts may inform understanding. LLM-assisted interpretation may assist construction of the RKM but is not deterministic Evidence.

### Finding categories

Repository Understanding shall not create authoritative Findings merely from understanding or LLM output. Direct repository issues identified through deterministic Evidence may be carried forward for evaluation and may yield Findings through the applicable audit path.

### Dependencies

This mode is mandatory, always executes first, and has no dependency on another audit mode. All other MVP modes depend on its RKM and Claim Catalog artifacts where applicable.

### Execution limitations and Execution Issues

Excluded, inaccessible, unsupported, or insufficient repository material shall be recorded as applicable Execution Issues. Such limitations shall not cause the mode to invent repository facts or downstream conclusions.

### Explicit non-goals

Repository Understanding does not determine truth, perform authoritative verification, create authoritative Findings from LLM output, persist the RKM across runs, or select a provider-specific downstream contract.

## 7. Documentation Verification

### Purpose

Documentation Verification shall evaluate whether documented Claims are supported by implementation. It includes API documentation verification; API documentation verification is not a separate MVP audit mode.

### User value

It gives users evidence-backed answers about whether repository documentation accurately describes the implemented system.

### Required inputs

- The RKM and Claim Catalog.
- Documented Claims selected for evaluation.
- Deterministic Evidence and Observations from the repository implementation.

### Conceptual outputs

- Verifications of documented Claims.
- Findings that explain supported, contradicted, partially supported, or unresolved documented assertions where reportable.
- Relevant Evidence, Observations, and Execution Issues.

### Claims evaluated

Claims expressed in repository documentation, including API documentation, requirements, README material, guides, examples, and other documentation within the accepted repository scope.

### Expected Evidence sources

Source code, tests, configuration, repository structure, build definitions, and other deterministic implementation artifacts. Source code is the operational source of truth when it conflicts with documentation.

### Finding categories

Documentation-supported, documentation-contradicted, documentation-partially-supported, and documentation-unresolved conditions may produce Findings when the applicable Evidence supports a reportable conclusion.

### Dependencies

Depends on Repository Understanding, the RKM, and the Claim Catalog. It may use deterministic Evidence and Observations shared with Claim Verification and other applicable modes.

### Execution limitations and Execution Issues

Unreadable, absent, excluded, unsupported, ambiguous, or insufficient documentation or implementation material shall result in appropriate Execution Issues or unresolved Verifications. They shall not be represented as verified documentation conditions.

### Explicit non-goals

This mode does not treat documentation as operational truth, generate documentation, define a separate API-documentation mode, or perform report-time analysis.

## 8. Documentation Drift

### Purpose

Documentation Drift shall identify and explain material gaps between current implementation and documentation. It provides the evidence-backed gap analysis required to keep documentation a living hypothesis rather than an assumed source of truth.

### User value

It helps users locate documentation that is stale, contradictory, incomplete, or missing relative to the current implementation.

### Required inputs

- The RKM and Claim Catalog.
- Relevant documentation and implementation scope.
- Deterministic Evidence and Observations that describe the current implementation and documented intent.

### Conceptual outputs

- Traceable Findings that describe a documentation gap and its relevant Claim, Evidence, and Verification context.
- Verifications and Observations supporting the gap analysis.
- Execution Issues for material limitations in comparing documentation and implementation.

### Claims evaluated

Documented Claims whose current implementation support must be compared to identify drift. A direct documentation gap may also produce a Finding where deterministic repository Evidence establishes the relevant condition without a corresponding Claim.

### Expected Evidence sources

Current source code, tests, configuration, repository structure, build definitions, and the applicable documentation artifacts. The implementation is operational truth; documentation is intent.

### Finding categories

- Stale documentation.
- Contradictory documentation.
- Incomplete documentation.
- Missing documentation where an evidence-backed repository condition warrants that classification.

### Dependencies

Depends on Repository Understanding, the RKM, and the Claim Catalog. It composes with Documentation Verification and Claim Verification but remains a distinct capability focused on communicating gaps between implementation and documentation.

### Execution limitations and Execution Issues

The mode shall record limitations when the necessary documentation or deterministic implementation Evidence is unavailable, excluded, inaccessible, unsupported, or insufficient. It shall not label documentation stale or missing without evidence-backed support.

### Explicit non-goals

Documentation Drift does not rewrite documentation, make documentation authoritative over implementation, create a general document-generation capability, or perform analysis in reporting.

## 9. Claim Verification

### Purpose

Claim Verification shall evaluate normalized Claims against deterministic Evidence and/or Observations, producing the canonical Verification outcomes where applicable.

### User value

It makes repository assertions auditable, explainable, and reusable across audit capabilities instead of treating each rule or file check as an isolated conclusion.

### Required inputs

- The RKM and Claim Catalog.
- One or more Claims selected for evaluation.
- Deterministic Evidence and relevant Observations.

### Conceptual outputs

- Verifications of Claims.
- Findings for reportable verification outcomes with required traceability.
- Evidence and Observations used by the Verification.
- Execution Issues for limitations that prevent or materially constrain verification.

### Claims evaluated

Any normalized Claim in the Claim Catalog that is applicable to the selected audit scope, including documented, requirements, architectural, and behavior Claims.

### Expected Evidence sources

Deterministic repository-derived facts, including source code, tests, configuration, build definitions, repository structure, and cross-reference results within the accepted local scope.

### Finding categories

The canonical Verification outcomes are:

| Outcome | Meaning |
| --- | --- |
| Verified | Available deterministic Evidence supports the Claim. |
| Contradicted | Available deterministic Evidence conflicts with the Claim. |
| Partially Verified | Available deterministic Evidence supports only part of the Claim. |
| Unresolved | Available Evidence is insufficient to determine the Claim’s status. |
| Not Applicable | The Claim does not apply to the evaluated repository or selected audit scope. |

Reportable Findings shall communicate the relevant outcome without conflating it with an Execution Issue.

### Dependencies

Depends on Repository Understanding, the RKM, and the Claim Catalog. It may receive Claims and shared Evidence from Documentation Verification, Documentation Drift, Architecture Conformance, and Repository Health.

### Execution limitations and Execution Issues

Missing or insufficient deterministic Evidence may result in an Unresolved Verification. Failures or limitations of the audit process shall be represented as Execution Issues, not as a contradictory Finding or Verification outcome.

### Explicit non-goals

Claim Verification does not allow an LLM to determine truth, define concrete rule interfaces, impose implementation-specific evaluation mechanisms, or create presentation-specific report results.

## 10. Architecture Conformance

### Purpose

Architecture Conformance shall evaluate implementation against architecture intent expressed in applicable ADRs and architecture documentation.

### User value

It helps users identify where the implemented system conforms to, diverges from, or lacks sufficient evidence for its documented architectural intent.

### Required inputs

- The RKM and Claim Catalog.
- Architecture Claims derived from applicable ADRs and architecture documentation.
- Deterministic implementation Evidence and Observations.

### Conceptual outputs

- Verifications of architecture Claims.
- Traceable Findings about conformance, contradiction, partial conformance, or unresolved architecture intent where reportable.
- Relevant Evidence, Observations, and Execution Issues.

### Claims evaluated

Claims about architecture, component responsibilities, allowed dependency direction, repository structure, and other documented architectural intent within the local repository.

### Expected Evidence sources

Source code, repository structure, configuration, tests, build definitions, and other deterministic implementation artifacts. ADRs and architecture documents provide intent, not operational truth.

### Finding categories

Architecture-conforming, architecture-contradicted, architecture-partially-conforming, and architecture-unresolved conditions may produce Findings where deterministic Evidence supports the result.

### Dependencies

Depends on Repository Understanding, the RKM, and the Claim Catalog. It composes with Claim Verification and may share documentation-related Claims and Evidence with Documentation Verification and Documentation Drift.

### Execution limitations and Execution Issues

Absent, obsolete, ambiguous, inaccessible, excluded, unsupported, or insufficient architectural material shall result in appropriate Execution Issues or unresolved Verifications. Architecture intent shall not override source code when deterministic Evidence shows a contradiction.

### Explicit non-goals

Architecture Conformance does not make ADR text operational truth, create or supersede ADRs, prescribe a concrete module design, or define dependency-analysis implementation mechanics.

## 11. Repository Health

### Purpose

Repository Health shall evaluate general repository-level structural and maintainability concerns that are language-agnostic and within the MVP scope.

### User value

It provides evidence-backed visibility into repository conditions that affect understandability and maintainability without expanding the MVP into specialized analysis categories.

### Required inputs

- The RKM and Claim Catalog where applicable.
- Validated local repository scope.
- Deterministic Evidence and Observations about repository-level structure and maintainability.

### Conceptual outputs

- Findings about reportable repository-level structural or maintainability concerns.
- Supporting Evidence, Observations, and Verifications where Claims apply.
- Execution Issues for material limitations in the evaluated repository scope.

### Claims evaluated

Repository-level Claims about structure, organization, and maintainability where such Claims are present in the Claim Catalog. Direct repository issues may yield Findings without a Claim when deterministic Evidence establishes the condition.

### Expected Evidence sources

Repository structure, source organization, configuration, build definitions, documentation placement, tests, and other deterministic, language-agnostic repository artifacts.

### Finding categories

General repository-level structural and maintainability conditions within the MVP scope. This category shall remain bounded by the explicit non-goals below.

### Dependencies

Depends on Repository Understanding and the RKM. It uses the Claim Catalog when evaluating repository Claims and may share Evidence and Observations with Claim Verification.

### Execution limitations and Execution Issues

Excluded, inaccessible, unsupported, or insufficient repository material shall be represented as applicable Execution Issues or unresolved Verifications. The mode shall not infer a health condition from missing visibility alone.

### Explicit non-goals

Repository Health is not a catch-all mode. It shall not include Security, Dependency Analysis, License Analysis, Operational Readiness, AI Readiness, infrastructure-as-code auditing, Kubernetes auditing, cloud-configuration auditing, or language-specific analysis.

## 12. Post-MVP and Explicitly Deferred Taxonomy

The following are explicitly post-MVP and shall not be represented as MVP audit modes or folded into Repository Health:

- Security.
- Dependency Analysis.
- License Analysis.
- Operational Readiness.
- AI Readiness.
- Infrastructure-as-Code auditing.
- Kubernetes auditing.
- Cloud configuration auditing.

Future work may define these capabilities through the project decision hierarchy. This document does not authorize their implementation, create implementation requirements for them, or assign them to an MVP mode.

## 13. MVP Success Criteria for Audit Modes

The MVP audit-mode specification is satisfied when:

- all six and only the six approved MVP modes are defined;
- Repository Understanding is mandatory and occurs first;
- one per-run RKM and Claim Catalog are shared by applicable downstream modes;
- each mode has a purpose, user value, required inputs, conceptual outputs, Claim scope where applicable, Evidence sources, Finding categories, dependencies, Execution Issue treatment, and explicit non-goals;
- Claim Verification defines the canonical Verification outcomes;
- Documentation Verification includes API documentation verification;
- Documentation Drift distinguishes stale, contradictory, incomplete, and missing documentation where evidence supports those categories;
- Architecture Conformance treats ADRs and architecture documentation as intent rather than operational truth;
- Repository Health remains language-agnostic and bounded from deferred specialized analysis; and
- Findings and Execution Issues flow to the Run Summary and Reporting without report-time analysis.

## 14. Out of Scope

This specification does not:

- implement application code or add Python modules;
- define concrete schemas, APIs, classes, scanner libraries, or execution mechanics;
- choose a CLI or configuration framework;
- define plugin discovery or loading;
- add CI or change the roadmap;
- make reports responsible for analysis;
- add audit modes beyond the six approved MVP capabilities; or
- implement deferred Security, Dependency Analysis, License Analysis, Operational Readiness, AI Readiness, infrastructure-as-code, Kubernetes, or cloud-configuration auditing.
