# Project decision hierarchy and work-item traceability

## Purpose

The project decision hierarchy makes clear where a decision belongs, who may change it, and how implementation work derives from it. It keeps product intent, technical direction, repository practice, and delivered changes consistent as the project evolves.

The hierarchy is:

```text
Product Vision
    ↓
Requirements
    ↓
Architecture Decision Records
    ↓
Repository Standards
    ↓
Implementation Issues
    ↓
Pull Requests
    ↓
Implementation
```

Each lower layer must comply with the layers above it. A lower-layer document or change must not contradict a higher-layer decision unless the higher-level document is intentionally evolved first. Traceability is therefore a design input, not documentation added after implementation.

## Why traceability matters

Traceability connects a delivered change to the product outcome, requirement, and durable technical decision that justify it. It helps contributors and reviewers:

- verify that work supports the [Product Vision](../product/vision.md), including its understand–verify–report philosophy and evidence-backed assurance;
- distinguish a deliberate product or architecture evolution from an accidental contradiction;
- assess implementation against the accepted decisions that govern it;
- understand the scope, validation, and deferred work for each change; and
- preserve an auditable record of how the repository came to reflect its intent.

## Layers, responsibilities, and authority

### Product Vision

The [Product Vision](../product/vision.md) is the highest-level product document. It defines the product’s purpose, guiding philosophy, intended users, and the principles that guide product choices. All lower layers must align with it.

Evolve the Product Vision deliberately when product intent changes. Do not use an implementation issue, pull request, or implementation to silently redefine it.

### Requirements

Requirements translate the Product Vision into expected capabilities, behaviors, and constraints. They define what the project must accomplish and provide the product-level basis for implementation work.

Requirements may refine the Product Vision, but may not contradict it. If a requirement reveals that the vision must change, evolve the Product Vision first or as part of the same intentional decision.

### Architecture Decision Records

[Architecture Decision Records (ADRs)](../decisions/README.md) capture durable technical decisions and their rationale. Accepted ADRs govern the architectural choices within their scope. An accepted ADR is changed only by a later ADR that supersedes it.

ADRs interpret requirements into stable technical direction; they do not supersede the Product Vision or requirements. When a technical decision needs to change, create an ADR that explicitly supersedes the earlier one.

### Repository Standards

[Repository Standards](repository-standards.md) govern how repository work is performed: issue and branch handling, commits, pull requests, validation, and hygiene. They establish implementation practices, but do not supersede the Product Vision, requirements, or accepted ADRs.

### Implementation Issues

Implementation issues turn approved product and technical direction into bounded, reviewable units of work. Each issue must state its Product Vision alignment and link the related requirements and accepted ADRs before implementation begins.

An issue may refine the plan for one change, but it may not create a conflicting product or architectural decision. Resolve such a conflict in the applicable higher-level document first.

### Pull Requests

Pull requests present the proposed implementation and its validation for review. They must preserve the issue’s traceability and identify the Product Vision principles, requirements, and ADRs that govern the change.

A pull request is evidence that a bounded issue was implemented; it is not authority to redefine requirements, architecture, or repository policy.

### Implementation

Implementation is the repository change that realizes the approved issue. It is the lowest layer and must conform to all applicable higher-level decisions. If the implementation exposes a conflict, stop and revise the implementation or intentionally evolve the relevant higher-level document before proceeding.

## Resolving conflicts between layers

Resolve conflicts at the highest layer that owns the decision:

1. Identify the conflict and the applicable Product Vision principle, requirement, ADR, or standard.
2. Do not bypass the conflict by changing a lower-layer issue, pull request, or implementation description.
3. Either revise the lower-layer work to comply, or intentionally evolve the owning higher-level document.
4. When changing architecture, create a superseding ADR; when changing product intent, update the Product Vision and any affected requirements.
5. Update the issue and pull request traceability after the higher-level decision changes, then validate the resulting implementation.

## Introducing new work

New work begins by identifying the product outcome it supports. Before implementation starts, create or update the relevant requirement and ADR when the change introduces a new expected behavior or durable technical decision. Then create a focused Linear implementation issue using the template below and use its generated branch name.

Implementation may begin only after the issue identifies the applicable Product Vision principles, related requirements, and accepted ADRs. The pull request must carry that traceability forward and record validation evidence.

## Standard Linear implementation issue template

Every implementation issue should use this structure. Every implementation issue must trace back to the Product Vision and to the accepted ADRs that apply to its scope; state `None` only when no accepted ADR applies and explain why.

```markdown
## Summary

## Problem

## Product Vision Alignment

- [Product Vision principle or section]

## Related Requirements

- [Requirement link or identifier]

## Related ADRs

- [Accepted ADR link or identifier]

## Technical Approach

## Out of Scope

## Acceptance Criteria

## Validation

## Risks / Deferred Work
```

Keep the issue focused on one coherent change. Its technical approach may describe how the work will be completed, but it must not establish a durable architectural decision that belongs in an ADR.
