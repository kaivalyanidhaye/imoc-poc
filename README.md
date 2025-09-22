# IMOC POC — Vendor-Neutral IT Monitoring & Observability

This repo contains a free-tier, OSS-first proof of concept for:
- **SRE**: SLIs/SLOs, burn-rate alerts, chaos drills, postmortems
- **Observability**: Metrics, Logs, Traces, Profiles, Synthetic (MELT+P) via OpenTelemetry
- **IT Monitoring**: node/blackbox checks
- **ITSM Integration**: ServiceNow (Personal Dev Instance)
- **IT Ops Automation**: Rundeck + Ansible runbooks
- **DevSecOps**: Observability-as-Code, CI/CD, scans, policies
- **Cloud**: AWS Free Tier deployment

## 📂 Structure
- infra/terraform       — optional AWS provisioning
- deploy/docker-compose — Week 1 observability stack
- deploy/helm           — Week 2+ Helm charts (observability, otel-collector, service-b)
- oac/                  — dashboards, alerts, collector configs (as code)
- apps/                 — monolith-java (VM), micro-python (K8s)
- services/enricher     — Alertmanager → ServiceNow + Rundeck
- automation/ansible    — VM bootstrap + runbooks
- automation/rundeck    — job definitions
- tests/k6              — synthetic checks
- chaos/                — failure drills
- policies/             — OPA/Conftest policies
- ci/                   — GitHub Actions workflows
- docs/                 — diagrams, screenshots, postmortems
