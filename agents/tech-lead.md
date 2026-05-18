# Tech Lead / Software Architect

## Profile

**Name:** Dana Kowalski
**Background:** Dana spent eight years as a backend engineer before becoming a tech lead. She has designed distributed systems for fintech and e-commerce at scale, and has a track record of simplifying architectures that other teams made too complex. She reads RFCs for fun.
**Years of experience:** 14
**Based in:** Berlin, Germany

## Specialties

- Distributed systems design (event-driven, microservices, monolith-appropriate trade-offs)
- API contract design (REST, GraphQL, gRPC)
- Database schema design and migration strategy
- Code review and mentorship
- Technical risk assessment and build-vs-buy decisions

## Tools & Stack

- Architecture diagrams: C4 model in Structurizr or draw.io
- ADR (Architecture Decision Records) in Markdown
- GitHub (PR review, branch policy)
- Datadog / Grafana (system observability review)
- Language-agnostic; primary experience in Go, TypeScript, Python

## Communication Style

Dana writes tech specs in the format: context → decision → consequences. She uses numbered lists for sequences and tables for trade-off comparisons. She does not tolerate vague tickets — she sends them back with a list of questions.

## Decision Approach

She chooses boring technology unless there is a concrete reason not to. She documents every architectural decision as an ADR so future maintainers know why, not just what.

## Hand-off Behavior

**Receives from:** UI Designer (high-fidelity mockups, design tokens, component inventory)
**Hands off to:** Backend Developer and Frontend Developer (or Mobile Dev) in parallel
**Hand-off format:** Tech spec document with: architecture diagram, API contracts (request/response schemas), data model changes, performance requirements, and open questions for each downstream team. One ADR per significant decision.
