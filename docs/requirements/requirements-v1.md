# Generic Audit Tool MVP Requirements

## 1. Purpose

This document is the authoritative functional and non-functional requirements baseline for the Generic Audit Tool MVP. It translates the [Product Vision](../product/vision.md) into product requirements while preserving the project decision hierarchy in [Decision Hierarchy and Work-Item Traceability](../governance/decision-hierarchy.md).

The MVP shall align with [ADR-001](../decisions/ADR-001-select-language-runtime.md), [ADR-002](../decisions/ADR-002-define-repository-structure.md), and [ADR-003](../decisions/ADR-003-define-core-component-boundaries.md). Those ADRs provide technical direction; this document does not redefine their decisions or prescribe implementation mechanisms.

## 2. Goals

The MVP shall provide a local-repository audit capability that:

- understands a repository before verification begins;
- verifies claims using deterministic repository-derived evidence;
- produces explainable Findings grounded in Evidence;
- identifies documentation claims that are supported, contradicted, partially supported, unresolved, or otherwise not verifiable from available Evidence;
- presents audit results without allowing presentation to change their meaning; and
- establishes stable conceptual contracts that support future extensions without making extensions part of the MVP’s core dependency graph.

## 3. Product Scope

The MVP is a local software-repository audit tool. An audit evaluates repository intent, implementation, and deterministic Evidence to produce an evidence-backed account of the audit run.

The MVP supports repository understanding, claim-based verification, documentation validation and drift detection, reportable Findings, configurable audit behavior, and human- and machine-consumable reporting. Repository Understanding is mandatory for every audit.

## 4. Functional Requirements

### FR-1: Local audit initiation

The product shall allow a user to initiate an audit of a local repository through the supported command-line experience. The user shall be able to provide the repository location and supported audit and output options through validated configuration.

### FR-2: Repository discovery

The product shall identify the eligible content of the requested local repository according to the configured audit scope. It shall handle excluded, inaccessible, and unsupported content safely and record resulting limitations as applicable Execution Issues.

### FR-3: Mandatory Repository Understanding

Every audit run shall begin by constructing a Repository Knowledge Model from the repository. Repository Understanding shall precede downstream verification activities and shall be reusable within the audit run.

### FR-4: Claim-based verification

The product shall generate and use a Claim Catalog for the audit run. Claim is the central domain object: every verification shall be performed against one or more Claims, except that direct repository issues may yield Findings without a Claim where the product has no documented assertion to evaluate.

### FR-5: Deterministic Evidence and verification

The product shall gather deterministic Evidence from the repository and use it to inform Observations and Verifications. A Finding shall be authoritative only when it is supported by deterministic Evidence. The product shall report uncertainty or an Execution Issue when the available Evidence is insufficient; it shall not represent an LLM-generated assumption as verified truth.

### FR-6: Documentation validation and drift detection

The product shall treat documentation as intent rather than operational truth. It shall evaluate supported documented Claims against repository Evidence and communicate whether available Evidence supports, contradicts, partially supports, or leaves the Claim unresolved. The resulting Findings shall retain the relevant Claim and Evidence traceability where applicable.

### FR-7: Audit results

The product shall produce a Run Summary for each audit attempt. The Run Summary shall account for the evaluated scope, applicable Findings, and Execution Issues, and shall distinguish successful, partial, and failed outcomes without discarding collected, usable results.

### FR-8: Reporting

The product shall provide the MVP’s supported human-readable and machine-consumable reports. Reporting shall consume Findings and Run Summaries, may represent Execution Issues, and shall perform no analysis, Verification, or Finding creation. A given completed audit result shall be renderable in the supported report formats without rerunning analysis.

### FR-9: Configuration and exit behavior

The product shall validate configuration before dependent audit work begins and shall communicate actionable configuration or invocation problems clearly. Configuration shall support the approved audit controls, including exclusions, enabled rules, severity thresholds, output controls, and failure behavior.

Findings shall not automatically cause an audit to fail merely because they exist. Non-zero exit behavior for Findings shall be controlled by configurable severity thresholds. Configuration, discovery, rule, and output problems shall be represented according to their effect as Execution Issues rather than converted into Findings.

### FR-10: Extensibility boundary

The product shall preserve a stable core-facing extension boundary for future rule packs and plugins. External plugins shall remain outside the core dependency graph and shall contribute only through the boundary described by ADR-003. An incompatible or failing extension shall not corrupt the audit run; applicable failures shall be reported as Execution Issues.

## 5. Non-Functional Requirements

### NFR-1: Explainability and traceability

Every Finding shall be traceable to the information that produced it. Where a Finding results from Claim verification, users shall be able to relate it to its Claim, relevant Evidence, Observations, and Verification. Findings arising directly from repository issues shall remain traceable to the relevant repository-derived Evidence or Observation.

### NFR-2: Reliability of conclusions

The product shall separate repository understanding from truth determination. LLM-assisted understanding may inform the Repository Knowledge Model and Claims, but only deterministic Evidence shall support authoritative Findings.

### NFR-3: Reproducibility and determinism

For the same repository content, validated configuration, supported capabilities, and deterministic inputs, the product shall preserve stable audit scope, ordering, and result meaning. The product shall make execution limitations visible through Execution Issues rather than silently varying or omitting conclusions.

### NFR-4: Usability

The command-line experience, configuration validation, Findings, Run Summaries, and reports shall use clear, actionable language appropriate to local and CI-oriented use. Actionable Findings shall include remediation guidance.

### NFR-5: Compatibility and maintainability

The MVP shall conform to the CPython support policy in ADR-001 and the repository placement and dependency direction established by ADR-002 and ADR-003. Requirements do not select frameworks, APIs, schemas, storage, or plugin-loading technologies.

## 6. Performance Requirements

The initial performance target is completion of a baseline audit of a representative local repository of approximately 100,000 lines of code in under two minutes. External LLM latency may be excluded where appropriate. This is an initial target for MVP evaluation, not a hard service-level agreement or guarantee.

## 7. Repository Scope

The MVP shall audit local repositories only. GitHub, GitLab, Azure DevOps, Bitbucket, archive ingestion, and other remote or packaged repository sources are future adapters and are not MVP repository inputs.

## 8. Audit Philosophy

The MVP shall follow the Product Vision’s sequence: **understand first, verify second, report last**.

- Understanding forms a reusable Repository Knowledge Model for the audit run.
- Verification evaluates Claims using deterministic Evidence and produces Verifications and Findings.
- Reporting presents the completed Findings and Run Summary without performing analysis.

## 9. Source of Truth

Source code is always the operational source of truth. Documentation, requirements, architecture records, and other repository materials express intent. When documentation and implementation disagree, the implementation represents operational reality; the product shall use deterministic Evidence to communicate that disagreement rather than assume intent is correct.

## 10. Repository Understanding

The Repository Knowledge Model shall be an ephemeral audit artifact. It shall be rebuilt for every audit run and shall not be treated as persistent repository truth. The MVP uses OpenAI to construct the Repository Knowledge Model; downstream audit contracts shall remain provider-agnostic.

LLMs assist repository understanding, including identifying candidate Claims and candidate Evidence sources. They never determine truth, produce authoritative Evidence, or independently establish a Finding.

## 11. Claim Verification

The Claim Catalog shall be a first-class, per-run collection of normalized Claims used by applicable verification activities. Verification shall evaluate Claims using Evidence directly and/or through Observations. A Verification shall communicate the result of that evaluation without conflating the raw Evidence, normalized Observation, or user-facing Finding.

## 12. Findings

A Finding shall be a presentation-independent, evidence-backed audit result. It shall communicate the affected repository scope, relevant classification, explanation, Evidence traceability, and remediation context where required. Findings are distinct from Execution Issues: a Finding describes a verified or evidence-backed repository condition, while an Execution Issue describes a limitation or failure of the audit process.

Every actionable Finding shall include remediation guidance. Informational Findings may omit remediation guidance.

## 13. Severity Model

The canonical MVP severity taxonomy is:

| Severity | Meaning |
| --- | --- |
| Critical | Requires the highest level of attention under the configured audit policy. |
| High | Requires significant attention under the configured audit policy. |
| Medium | Represents a material issue that should be assessed and addressed under the configured audit policy. |
| Low | Represents a lower-impact issue. |
| Informational | Communicates useful information and may not require remediation. |

Severity thresholds shall control the configured non-zero exit behavior for Findings.

## 14. Confidence Model

The user-facing MVP confidence model is:

- High
- Medium
- Low

Confidence communicates the strength and completeness of the available support for a Finding or Verification. Numeric confidence scoring is deferred unless a later concrete implementation need is approved.

## 15. Reporting Expectations

Reports shall present Findings, Run Summaries, applicable Execution Issues, severity summaries, and remediation content in the supported MVP formats. Reports shall preserve the meaning and traceability of their input artifacts. They shall not discover repository content, construct a Repository Knowledge Model or Claim Catalog, evaluate Claims, gather Evidence, create Observations or Verifications, or create Findings.

## 16. Configuration Expectations

Configuration shall express supported audit controls and defaults without bypassing validation. It shall support local repository selection, output controls, exclusions, enabled rules, severity thresholds, and failure behavior. Invalid required configuration shall stop dependent work with actionable configuration issues.

## 17. Determinism Requirements

The product shall:

- use deterministic repository-derived Evidence for authoritative conclusions;
- select and order eligible repository content deterministically within the accepted audit scope;
- preserve evidence-backed Finding and Run Summary facts across supported report representations;
- retain audit-run provenance for Repository Knowledge Model, Claim Catalog, Claim, Evidence, Observation, Verification, Finding, Run Summary, and Execution Issue artifacts as applicable; and
- make insufficient Evidence and execution limitations explicit rather than inferring unverified conclusions.

## 18. Extensibility Goals

The MVP shall establish conceptual contracts that allow future rule packs, report formats, repository adapters, and plugins to evolve without changing the meaning of the core audit artifacts. These goals do not require the MVP to implement remote providers, external plugin distribution, persistence, caching, or a plugin-loading technology.

## 19. Out of Scope

The following are outside the MVP requirements baseline:

- GitHub, GitLab, Azure DevOps, Bitbucket, archive, cloud, and other non-local repository ingestion;
- cloud execution and provider-specific repository adapters;
- concrete APIs, Python classes, serialization schemas, graph databases, persistence, caching, and implementation technology selection;
- external plugin discovery, loading, distribution, sandboxing, and isolation mechanisms beyond the conceptual extension boundary;
- language-specific analyzers beyond the MVP’s approved capability scope;
- a requirement to make LLM output authoritative or to use an LLM as deterministic Evidence; and
- post-MVP performance optimization beyond measuring the initial performance target.

## 20. MVP Success Criteria

The MVP is successful when it can audit a supported local repository by building an ephemeral Repository Knowledge Model, generating and using a Claim Catalog, verifying Claims with deterministic Evidence, and producing explainable Findings and a Run Summary.

Success further requires that:

- source code is treated as operational truth and documentation is evaluated as intent;
- every authoritative Finding is evidence-backed and traceable;
- uncertainty and execution limitations are visible as appropriate;
- reports consume completed Findings and Run Summaries without analysis or Finding creation;
- configuration controls Finding-related exit behavior through severity thresholds rather than failing on any Finding; and
- the result aligns with the Product Vision and accepted ADRs.

## 21. Glossary

| Term | Meaning in the MVP |
| --- | --- |
| Repository | The local software repository being audited. |
| Repository Knowledge Model (RKM) | The ephemeral, per-run understanding of the repository created before verification. It assists understanding but does not determine truth. |
| Claim Catalog | The first-class, per-run collection of normalized Claims used by applicable audit activities. |
| Claim | A normalized assertion about repository intent or reality that can be evaluated. It is the central domain object. |
| Evidence | An immutable, deterministic fact gathered from the repository for an audit run. Evidence contains no conclusion by itself. |
| Observation | A reusable normalization of Evidence into a fact relevant to verification. |
| Verification | An evaluation of Evidence and/or Observations against one or more Claims. |
| Finding | A presentation-independent, evidence-backed result that communicates an auditable repository condition. A Finding may arise without a Claim for a direct repository issue. |
| Run Summary | The stable account of one audit attempt, including its scope, completion state, aggregate Finding information, and Execution Issues. |
| Execution Issue | A limitation or failure encountered while configuring, discovering, understanding, verifying, accepting an extension contribution, or producing output. It is not a Finding. |
| Severity | The canonical classification of a Finding’s configured level of attention: Critical, High, Medium, Low, or Informational. |
| Confidence | The user-facing indication of the strength and completeness of available support: High, Medium, or Low. |
| Remediation guidance | Actionable guidance included with every actionable Finding; informational Findings may omit it. |
