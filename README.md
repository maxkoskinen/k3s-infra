# k3s-infra

Infrastructure-as-Code for my personal Raspberry Pi homelab, running a 3-node [k3s](https://k3s.io) cluster.  
This repo contains Terraform configurations and Kubernetes manifests I use to deploy and manage self-hosted services and monitoring stacks.  

## Overview
- **Cluster**: 3x Raspberry Pi 4 nodes
- **Orchestration**: [k3s](https://k3s.io)
- **IaC tools**: Terraform (Helm releases) + raw Kubernetes manifests

## 📦 What’s Deployed
Currently running (or experimenting with):
- Cluster monitoring (Prometheus, Grafana, etc.)
- Vaultwarden (password manager)
- Homepage dashboard
- Kiwix (offline wiki)
- GitHub Action self-hosted runners (after uncommenting a few lines)
- more to come as I experiment 🚀

## 🛠️ Structure

The repository is split into two main parts:  
- **kubernetes-manifests** → per-app YAML manifests for workloads  
- **terraform** → IaC definitions for Helm releases and cluster components  

```
├── kubernetes-manifests
│   ├── <app-name>/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── ingress.yaml
│   │   └── ... (other manifests for the app)
│   └── ...
│
├── terraform
│   ├── providers.tf            # Terraform providers
│   ├── variables.tf            # Input variables
│   ├── example-secret.tfvars   # Secret vars
│   ├── <app-name>.tf           # Helm release for app
│   ├── <app-name>.tf           # Another Helm release
│   ├── ...
│   └── charts/                 # Helm chart values overrides
│       ├── <app-name>/values.yaml
│       └── ...
│
└── README.md
```