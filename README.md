# IMOC POC — Vendor-Neutral IT Monitoring & Observability


[![CI](https://github.com/kaivalyanidhaye/imoc-poc/actions/workflows/ci.yml/badge.svg)](https://github.com/<your-username>/imoc-poc/actions)

![observability](https://img.shields.io/badge/observability-otel-blue)
![sre](https://img.shields.io/badge/sre-slo%2Fburn--rate-green)
![prometheus](https://img.shields.io/badge/prometheus-metrics-orange)
![grafana](https://img.shields.io/badge/grafana-dashboards-yellow)
![loki](https://img.shields.io/badge/loki-logs-lightgrey)
![tempo](https://img.shields.io/badge/tempo-traces-blueviolet)
![pyroscope](https://img.shields.io/badge/pyroscope-profiling-red)
![k6](https://img.shields.io/badge/k6-synthetic%20tests-brightgreen)
![servicenow](https://img.shields.io/badge/itsm-servicenow-lightblue)
![ansible](https://img.shields.io/badge/automation-ansible-darkred)
![rundeck](https://img.shields.io/badge/automation-rundeck-purple)
![terraform](https://img.shields.io/badge/iac-terraform-593d88)
![aws](https://img.shields.io/badge/cloud-aws-ff9900)


This repo contains a free-tier, OSS-first proof of concept for:
- **SRE**: SLIs/SLOs, burn-rate alerts, chaos drills, postmortems
- **Observability**: Metrics, Logs, Traces, Profiles, Synthetic (MELT+P) via OpenTelemetry
- **IT Monitoring**: node/blackbox checks
- **ITSM Integration**: ServiceNow (Personal Dev Instance)
- **IT Ops Automation**: Rundeck + Ansible runbooks
- **DevSecOps**: Observability-as-Code, CI/CD, scans, policies
- **Cloud**: AWS Free Tier deployment

## 🚀 Quickstart

> This POC runs locally with Docker Desktop or on an AWS t2.micro (free tier).  
> Week 1 will add the actual `docker-compose.yml` and configs—this section is a seed you can refine as you build.

### 1) Clone the repo
```bash
git clone https://github.com/<your-username>/imoc-poc.git
cd imoc-poc


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
