# GCP Enterprise Network Platform

## Overview

This project demonstrates an enterprise-style Google Cloud Platform networking architecture built using Terraform.

The goal of this project is to build a reusable, modular, and secure GCP network foundation while demonstrating practical skills in:

- Google Cloud Platform
- GCP Networking
- Terraform
- Infrastructure as Code
- Git and GitHub
- VPC design
- Subnet design
- Firewall configuration
- Cloud Router
- Cloud NAT
- Modular Terraform architecture

This repository is designed as a hands-on portfolio project for cloud and network engineering.

---

## Architecture

```text
                         GCP Project
                             |
                             |
                    enterprise-dev-vpc
                             |
              +--------------+--------------+
              |                             |
              |                             |
        us-central1                    us-east1
              |                             |
              |                             |
    10.10.0.0/24 subnet            10.20.0.0/24 subnet
              |
              |
        Cloud Router
              |
              |
          Cloud NAT


        Firewall Controls
              |
        Internal Traffic
```

---

## Current Architecture

The current development environment contains:

- One custom-mode GCP VPC
- One subnet in `us-central1`
- One subnet in `us-east1`
- Reusable firewall rules
- One Cloud Router in `us-central1`
- One Cloud NAT configuration
- Reusable Terraform modules
- Separate development environment configuration

---

## Project Structure

```text
gcp-enterprise-network-platform/
│
├── modules/
│   │
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── subnets/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── firewall/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── router/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── nat/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── environments/
│   │
│   └── dev/
│       ├── main.tf
│       ├── providers.tf
│       ├── variables.tf
│       └── .terraform.lock.hcl
│
├── architecture/
├── .gitignore
├── LICENSE
└── README.md
```

---

## VPC Module

The VPC module creates a custom-mode Google Cloud VPC.

Key configuration:

- Automatic subnet creation is disabled
- Dynamic routing mode is configured as `GLOBAL`
- Subnets are explicitly created and managed
- CIDR ranges are controlled through Terraform

Using a custom-mode VPC provides better control over network design compared to automatically created subnetworks.

---

## Subnet Module

The subnet module creates regional subnets inside the VPC.

Current development subnets:

| Region | Subnet Name | CIDR |
|---|---|---|
| us-central1 | dev-us-central1-subnet | 10.10.0.0/24 |
| us-east1 | dev-us-east1-subnet | 10.20.0.0/24 |

Private Google Access is enabled on the subnets.

The VPC itself is global, while GCP subnets are regional resources.

---

## Firewall Module

The firewall module creates reusable GCP firewall rules.

The current development configuration allows selected internal TCP communication.

Example permitted ports include:

- TCP 22
- TCP 443

The module supports configurable:

- Source CIDR ranges
- Protocols
- Ports
- Priorities
- Network tags
- Firewall direction

Future versions of this project will implement more restrictive least-privilege firewall policies.

---

## Cloud Router Module

The Cloud Router module creates a regional Cloud Router.

Current configuration:

```text
Region: us-central1
BGP ASN: 64514
```

Cloud Router provides dynamic routing capabilities for services such as:

- Cloud NAT
- HA VPN
- Cloud Interconnect
- Hybrid cloud networking

Cloud Router operates as a routing control-plane component and does not directly forward application packets.

---

## Cloud NAT Module

Cloud NAT is attached to the Cloud Router.

Cloud NAT allows private workloads to initiate outbound internet connections without requiring public IP addresses on the workloads.

Current configuration uses:

```text
NAT IP Allocation: AUTO_ONLY
```

Simplified traffic flow:

```text
Private VM
    |
    v
Subnet
    |
    v
VPC Routing
    |
    v
Cloud NAT
    |
    v
Public Internet
```

---

## Terraform Dependency Flow

Terraform automatically understands dependencies between modules through resource references.

The current dependency flow is:

```text
Development Environment
          |
          v
       VPC Module
          |
          +-------------------+
          |                   |
          v                   v
    Subnet Modules       Firewall Module
          |
          v
     Cloud Router
          |
          v
       Cloud NAT
```

For example:

```hcl
network_self_link = module.vpc.network_self_link
```

This reference tells Terraform that the subnet depends on the VPC.

Similarly:

```hcl
router_name = module.router_us_central1.router_name
```

creates a dependency between Cloud NAT and Cloud Router.

---

## Terraform Workflow

The Terraform workflow used for this project is:

```text
Write Terraform Code
        |
        v
terraform fmt
        |
        v
terraform init
        |
        v
terraform validate
        |
        v
terraform plan
        |
        v
Review Changes
        |
        v
terraform apply
```

---

## Terraform Validation

The project is formatted and validated using:

```bash
terraform fmt -recursive
```

```bash
terraform init
```

```bash
terraform validate
```

A successful validation confirms that the Terraform configuration is syntactically valid and that module references are correctly configured.

---

## Deployment

To deploy the development environment:

```bash
cd environments/dev
```

Initialize Terraform:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Review the proposed infrastructure changes:

```bash
terraform plan
```

Deploy the resources:

```bash
terraform apply
```

A valid GCP project, required Google Cloud APIs, billing, and authenticated credentials are required before deployment.

---

## Git Workflow

Development is performed using feature branches instead of working directly on the `main` branch.

Example workflow:

```text
main
 |
 |
 +---- feature/base-network
              |
              +---- Terraform development
              |
              +---- Validation
              |
              +---- Commit
              |
              +---- Push
              |
              +---- Pull Request
              |
              v
             main
```

Example commands:

```bash
git switch -c feature/base-network
```

```bash
git add .
```

```bash
git commit -m "feat: build base GCP network platform"
```

```bash
git push -u origin feature/base-network
```

Changes are reviewed through a GitHub Pull Request before merging into `main`.

---

## Security Practices

The repository avoids committing sensitive Terraform and environment files.

The `.gitignore` configuration excludes files such as:

```text
.terraform/
*.tfstate
*.tfstate.*
terraform.tfvars
.DS_Store
```

Terraform state files and local variable files should not be committed to a public repository.

---

## Current Status

Completed:

- Custom-mode VPC module
- Regional subnet module
- Firewall module
- Cloud Router module
- Cloud NAT module
- Development environment
- Terraform initialization
- Terraform formatting
- Terraform validation
- Git feature branch workflow
- GitHub repository setup

Real GCP deployment is currently pending completion of billing and API activation for the lab project.

---

## Future Enhancements

Planned improvements include:

- Production environment
- Additional subnet segmentation
- More restrictive firewall policies
- Cloud DNS
- VPC Flow Logs
- Cloud NAT logging
- HA VPN
- BGP routing
- Cloud Interconnect architecture
- Shared VPC
- Service projects
- Network Connectivity Center
- Private Service Connect
- Centralized logging
- GitHub Actions CI/CD
- Terraform security scanning
- Open Policy Agent policy validation
- Automated Terraform plan checks
- Architecture diagrams
- Network troubleshooting automation using Python

---

## Skills Demonstrated

This project demonstrates hands-on experience with:

- Google Cloud Platform
- GCP VPC networking
- Regional subnet design
- CIDR planning
- Firewall configuration
- Cloud Router
- BGP concepts
- Cloud NAT
- Terraform
- Terraform modules
- Infrastructure as Code
- Git
- GitHub
- Feature branch workflows
- Pull Requests
- Cloud network architecture
- Network security
- Infrastructure validation

---

## Project Goal

The long-term goal of this project is to evolve it into an enterprise-style GCP networking platform that demonstrates secure networking, hybrid connectivity, automation, policy enforcement, observability, and production-style Infrastructure as Code practices.