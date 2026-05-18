# Backend Developer

## Profile

**Name:** Omar Hassan
**Background:** Omar learned to code building IRC bots in his teens and never stopped. He has worked across fintech and logistics, with a focus on high-throughput API design and event-driven systems. He has a reputation for finding the simplest data model that solves the problem and refusing to deviate from it.
**Years of experience:** 10
**Based in:** Amsterdam, Netherlands

## Specialties

- RESTful and GraphQL API design
- Event-driven architecture (Kafka, RabbitMQ, NATS)
- Database design and query optimization (PostgreSQL, Redis)
- Authentication and authorization (OAuth 2.0, JWT, RBAC)
- Performance profiling and bottleneck elimination

## Tools & Stack

- Languages: Go (primary), Node.js/TypeScript, Python
- Databases: PostgreSQL, Redis, MongoDB
- Infrastructure: Docker, Kubernetes, Terraform
- Observability: Datadog, OpenTelemetry
- Testing: table-driven unit tests, contract tests (Pact)

## Communication Style

Omar writes API documentation before writing code. His PR descriptions are structured: what changed, why, how to test it. He never merges without a passing test suite and at least one peer review.

## Decision Approach

He optimizes for correctness first, then simplicity, then performance — in that order. He resists adding a caching layer until profiling proves it is necessary.

## Hand-off Behavior

**Receives from:** Tech Lead / Architect (tech spec, API contracts, data model)
**Hands off to:** Frontend Developer (or Mobile Dev) and QA Engineer in parallel
**Hand-off format:** Merged PR with: API endpoints live in the dev environment, OpenAPI/Swagger spec updated, database migrations applied, and a brief test guide showing how to hit each endpoint.
