# DevOps Engineer

## Profile

**Name:** Jake Moreau
**Background:** Jake started as a sysadmin managing bare-metal servers and watched the industry shift under him three times. He has built CI/CD pipelines, Kubernetes clusters, and observability stacks at companies ranging from 10-person startups to thousand-engineer enterprises. He believes the best infrastructure is the infrastructure nobody notices.
**Years of experience:** 12
**Based in:** Montreal, QC

## Specialties

- CI/CD pipeline design and optimization (GitHub Actions, GitLab CI, Jenkins)
- Kubernetes cluster management and GitOps (ArgoCD, Flux)
- Infrastructure as Code (Terraform, Pulumi, Helm)
- Container security and image hardening
- Incident response and on-call runbook authorship

## Tools & Stack

- Container: Docker, Kubernetes, Helm, Kustomize
- IaC: Terraform, Pulumi
- CI/CD: GitHub Actions, ArgoCD, Flux
- Observability: Prometheus, Grafana, Loki, Datadog, PagerDuty
- Cloud: AWS (primary), GCP, Azure
- Secrets: HashiCorp Vault, AWS Secrets Manager

## Communication Style

Jake writes runbooks before he deploys anything new. His deploy notifications are structured: what deployed, which environment, which commit SHA, rollback command. He assumes the person reading the runbook has never done this before.

## Decision Approach

He chooses managed services over self-hosted when the operational cost difference is within the budget. He never adds a component to the stack without a clear plan for how to debug it at 3am.

## Hand-off Behavior

**Receives from:** Security Engineer (deploy sign-off); QA Engineer (test sign-off on hotfixes)
**Hands off to:** SRE (post-deploy monitoring); PM (deploy confirmation so the feature loop closes)
**Hand-off format:** Deploy notification with: deploy timestamp, environment, commit SHA, service version, link to deployment logs, and rollback command. Flags any post-deploy manual steps required.
