# Generic Audit Tool Product Vision

## Vision Statement

Software engineering has no shortage of scanners.

We have linters, security analyzers, dependency scanners, documentation tools, AI reviewers, and compliance platforms. Each examines a narrow slice of a software repository and produces its own isolated conclusions.

What is missing is a system that understands a software repository as a whole, verifies its claims against deterministic evidence, and produces a single, explainable assessment of software reality.

The Generic Audit Tool exists to provide that understanding.

Our vision is to become the authoritative system for software assurance—one that continuously reconciles what a project intends to be with what it actually is, producing evidence-backed findings that engineering teams can trust.

---

# Guiding Philosophy

The Generic Audit Tool follows one simple philosophy:

> **Understand first. Verify second. Report last.**

Every audit follows this sequence.

1. Build an understanding of the repository.
2. Verify that understanding using deterministic evidence.
3. Produce findings and reports from verified facts.

Understanding without verification creates speculation.

Verification without understanding creates noise.

Only by combining both can software be assessed accurately.

---

# The Problem

Modern software teams rely on many disconnected tools.

Examples include:

- Static analysis
- Security scanners
- Dependency analyzers
- Documentation tooling
- Architecture reviews
- Compliance platforms
- AI code review

Each tool answers one narrow question.

Very few answer questions such as:

- Does the implementation match the documented architecture?
- Are the requirements actually implemented?
- Which documentation is no longer accurate?
- Which claims can be verified?
- Which assumptions remain unsupported?
- What evidence supports each conclusion?
- How trustworthy is the software overall?

As software grows, these disconnected perspectives drift apart.

Documentation becomes outdated.

Architecture evolves.

Requirements change.

Implementations diverge.

Eventually nobody knows which representation reflects reality.

---

# Our Philosophy

The Generic Audit Tool is not another code scanner.

It is a software assurance platform.

Rather than analyzing source code in isolation, it continuously reconciles multiple representations of the same software system until a single evidence-backed understanding emerges.

---

# The Four Views of Software

Every repository contains four different views of reality.

## 1. Intent

What the software claims to be.

Examples include:

- Requirements
- Architecture documents
- ADRs
- README files
- Design documentation
- User documentation

Intent describes expectations.

It is not evidence.

---

## 2. Implementation

What actually exists.

Examples include:

- Source code
- Tests
- Configuration
- Dependencies
- Build definitions
- Repository structure

Implementation represents reality, but does not explain itself.

---

## 3. Evidence

Objective facts gathered through deterministic verification.

Examples include:

- Static analysis
- Repository inspection
- Test execution
- Configuration validation
- Rule evaluation
- Cross-reference verification

Evidence supports or contradicts claims.

---

## 4. Reality

Reality is the verified understanding produced by reconciling intent, implementation, and evidence.

Reality is never assumed.

Reality is earned through verification.

The purpose of the Generic Audit Tool is to continuously establish and maintain this understanding.

---

# AI-Assisted Understanding, Deterministic Verification

Artificial Intelligence plays an important role in the platform, but not the role many tools assign to it.

Large Language Models are used to understand software.

They assist with:

- repository comprehension
- architectural inference
- documentation interpretation
- requirements extraction
- workflow orchestration
- identifying candidate evidence
- remediation recommendations

Large Language Models do **not** determine truth.

Authoritative findings are produced only when supported by deterministic evidence gathered from the repository.

When evidence is insufficient, the platform explicitly reports uncertainty instead of presenting AI-generated assumptions as facts.

This distinction is fundamental to the Generic Audit Tool.

---

# Continuous Repository Understanding

Traditional tools execute predefined scans.

The Generic Audit Tool first develops an understanding of the repository before determining what should be audited.

That understanding includes:

- architecture
- technologies
- repository organization
- entry points
- requirements
- documentation
- relationships between components

This understanding becomes reusable across every audit capability rather than being recreated independently by each scanner.

---

# Continuous Documentation Validation

Documentation is treated as a living hypothesis rather than static reference material.

The platform continuously compares documentation against implementation to determine whether documented claims remain true.

This includes:

- architecture documentation
- ADRs
- README files
- onboarding documentation
- requirements
- configuration guides
- examples

Rather than assuming documentation is correct, the platform continuously verifies it.

---

# Documentation Drift Detection

Documentation drift is treated as a first-class audit concern.

For every documented claim, the platform attempts to determine whether:

- implementation supports the claim
- implementation contradicts the claim
- implementation partially supports the claim
- insufficient evidence exists

Instead of simply reporting differences, the platform produces an evidence-backed gap analysis containing:

- documented claim
- supporting evidence
- contradictory evidence
- confidence level
- recommended remediation

This enables engineering teams to continuously maintain documentation accuracy as software evolves.

---

# What Makes the Generic Audit Tool Different

## Claim-Based Verification

The platform audits claims rather than files.

Every architectural statement, requirement, design decision, and documented behavior becomes something that can be verified.

---

## Evidence-Backed Assurance

Every finding references supporting evidence.

Nothing becomes an authoritative finding simply because an AI model suggested it.

---

## Explainable Findings

Every finding answers:

- What was checked?
- Why does it matter?
- What evidence supports it?
- How confident is the conclusion?
- What should be done next?

---

## Intelligent Orchestration

Rather than executing a fixed sequence of scanners, the platform uses repository understanding to determine which audit activities should occur and how they relate to one another.

The workflow adapts while remaining deterministic.

---

## Stable Domain Model

Findings remain independent of:

- CLI
- report format
- user interface
- integrations

Reports become different views of the same verified understanding rather than independent analyses.

---

## Extensible Audit Platform

Future capabilities share a common foundation:

- repository understanding
- evidence
- findings
- reporting
- orchestration

New audit capabilities contribute to a shared understanding instead of producing isolated results.

---

# Target Users

Primary users include:

- Software architects
- Staff engineers
- Principal engineers
- Technical leads
- Engineering managers

Secondary users include:

- Security teams
- Platform teams
- Internal audit organizations
- Consulting firms
- Open-source maintainers

Future users include:

- Compliance organizations
- Acquisition due diligence teams
- AI engineering platforms

---

# MVP

The MVP demonstrates the architecture by providing deterministic repository audits that:

- understand a repository
- discover supported artifacts
- execute built-in audit rules
- verify documented claims
- generate evidence-backed findings
- identify uncertainty explicitly
- detect documentation drift
- produce actionable remediation recommendations

---

# Out of Scope

The MVP intentionally excludes:

- SaaS deployment
- cloud-hosted services
- autonomous remediation
- AI-generated authoritative findings
- plugin marketplace
- distributed execution
- IDE integrations
- collaborative review workflows

These capabilities may be introduced later without changing the core philosophy.

---

# Long-Term Vision

The Generic Audit Tool becomes the authoritative understanding of a software system.

Rather than replacing security scanners, documentation tools, AI assistants, or compliance platforms, it provides a verified understanding that all of those systems can consume.

Over time, the platform becomes the central evidence layer for software assurance.

Every architectural decision, implementation, requirement, finding, and recommendation contributes to a continuously maintained understanding of software reality.

Our goal is not simply to audit software.

Our goal is to make software understandable, verifiable, and trustworthy.