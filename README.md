# GCP Enterprise Network Platform

## Overview

This project demonstrates an enterprise-style Google Cloud Platform networking architecture built with Terraform.

The goal is to create a reusable, modular, secure, and observable network foundation that reflects common enterprise cloud networking patterns.

The project currently demonstrates:

- Custom-mode VPC
- Regional subnets
- Firewall rules
- Cloud Router
- Cloud NAT
- VPC Flow Logs
- Firewall logging
- Cloud NAT logging
- Private Cloud DNS
- HA VPN
- BGP
- Shared VPC architecture
- Reusable Terraform modules
- Git feature-branch workflow
- Pull Request based development

This repository is intended as a hands-on portfolio project for GCP networking, Terraform, cloud infrastructure, and enterprise network engineering.

---

## High-Level Architecture

```text
                         GCP Environment
                              |
                              |
                     enterprise-dev-vpc
                              |
              +---------------+---------------+
              |                               |
        us-central1                      us-east1
              |                               |
     10.10.0.0/24 subnet             10.20.0.0/24 subnet
              |                               |
       VPC Flow Logs                   VPC Flow Logs
              |
              |
        Firewall Rules
              |
        Firewall Logging
              |
              |
         Cloud Router
          ASN 64514
          /       \
         /         \
   Cloud NAT      HA VPN
      |             |
 NAT Logging      VPN Tunnels
                    |
                    |
                BGP Sessions
                    |
                    |
             External VPN Peer
                ASN 65010
```

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
│   ├── nat/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── dns/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── ha-vpn/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── shared-vpc/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── providers.tf
│       ├── variables.tf
│       └── .terraform.lock.hcl
│
├── examples/
│   └── shared-vpc/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars.example
│
├── architecture/
├── .gitignore
├── LICENSE
└── README.md
```

---

## VPC Module

The VPC module creates a custom-mode Google Cloud VPC.

Key characteristics:

- Automatic subnet creation is disabled
- Dynamic routing mode is set to `GLOBAL`
- Subnets are explicitly managed
- CIDR allocation is controlled through Terraform

Example:

```hcl
resource "google_compute_network" "this" {
  name                    = var.network_name
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
}
```

Using a custom-mode VPC provides better control over subnet placement, CIDR allocation, segmentation, and enterprise network design.

---

## Subnet Architecture

The project currently defines two regional subnets.

| Region | Subnet | CIDR |
|---|---|---|
| us-central1 | dev-us-central1-subnet | 10.10.0.0/24 |
| us-east1 | dev-us-east1-subnet | 10.20.0.0/24 |

The VPC is global, while subnets are regional.

Private Google Access is enabled.

VPC Flow Logs are also enabled to provide network traffic visibility.

Example flow-log configuration:

```hcl
log_config {
  aggregation_interval = "INTERVAL_5_SEC"
  flow_sampling        = 0.5
  metadata             = "INCLUDE_ALL_METADATA"
}
```

---

## Firewall Architecture

The firewall module creates reusable GCP firewall rules.

The current development environment supports configurable:

- Source CIDR ranges
- Protocols
- Ports
- Rule priority
- Direction
- Network tags

Firewall rule logging is enabled.

Example:

```hcl
log_config {
  metadata = "INCLUDE_ALL_METADATA"
}
```

This provides visibility into traffic that matches firewall rules and helps with troubleshooting.

---

## Network Observability

The project includes multiple logging layers.

```text
VPC Flow Logs
      +
Firewall Logs
      +
Cloud NAT Logs
      +
Cloud DNS Query Logs
```

These help answer questions such as:

```text
Did the packet leave the source subnet?

Did it match the expected firewall rule?

Was source NAT applied?

Was the DNS query received?

What destination was resolved?

Did the packet reach the expected network path?
```

---

## Cloud Router

The Cloud Router module creates a regional Cloud Router.

Current configuration:

```text
Region: us-central1
ASN: 64514
```

Cloud Router provides dynamic routing capabilities for services such as:

- HA VPN
- Cloud Interconnect
- Hybrid cloud connectivity
- Cloud NAT association

Cloud Router is a control-plane component.

It exchanges routes using BGP but does not directly forward application packets.

---

## Cloud NAT

Cloud NAT provides outbound internet access for workloads that do not have public IP addresses.

Current configuration:

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

Cloud NAT logging is enabled:

```hcl
log_config {
  enable = true
  filter = "ALL"
}
```

This improves visibility into translated connections and NAT-related failures.

---

## Private Cloud DNS

The project includes a reusable private Cloud DNS module.

The development environment uses the private zone:

```text
dev.internal.
```

Example records:

```text
app.dev.internal  -> 10.10.0.10
api.dev.internal  -> 10.20.0.10
```

The private zone is associated with the VPC.

Simplified DNS resolution flow:

```text
Application
    |
    | DNS query
    v
Cloud DNS Private Zone
    |
    | returns private IP
    v
VPC Routing
    |
    v
Destination Workload
```

DNS query logging is also enabled using a DNS policy.

This helps troubleshoot private name-resolution problems.

---

## HA VPN Architecture

The project includes an HA VPN design for hybrid connectivity.

The architecture models:

```text
GCP VPC
   |
Cloud Router
ASN 64514
   |
   +-------------------+
   |                   |
BGP Session 0       BGP Session 1
   |                   |
Tunnel 0            Tunnel 1
   |                   |
HA VPN Gateway
   |                   |
   +-------------------+
            |
    External VPN Gateway
            |
      On-Premises Peer
         ASN 65010
```

Two tunnels are modeled for redundancy.

---

## BGP Design

The project uses BGP for dynamic route exchange.

Current example configuration:

```text
GCP ASN: 64514
Peer ASN: 65010
```

BGP link-local addressing:

```text
Tunnel 0
GCP:  169.254.0.1
Peer: 169.254.0.2

Tunnel 1
GCP:  169.254.0.5
Peer: 169.254.0.6
```

The important distinction is:

```text
VPN Tunnel
=
Encrypted connectivity

BGP
=
Dynamic route exchange
```

A VPN tunnel can be operational while the BGP session is down.

That means:

```text
Tunnel UP
does not automatically mean
Routing works
```

---

## Hybrid Connectivity Troubleshooting

A safe troubleshooting sequence is:

```text
1. Check VPN tunnel status
        |
        v
2. Check BGP session status
        |
        v
3. Check learned routes
        |
        v
4. Check advertised routes
        |
        v
5. Check VPC route selection
        |
        v
6. Check firewall rules
        |
        v
7. Check return path
        |
        v
8. Review flow and NAT logs
```

This helps avoid jumping to conclusions during hybrid-network incidents.

---

## Shared VPC Architecture

The project includes a reusable Shared VPC module.

The design separates central network ownership from workload ownership.

```text
Shared VPC Host Project
│
├── Shared VPC
├── Subnets
├── Routes
├── Firewall Controls
├── Cloud Router
└── Cloud NAT

Service Project A
└── Application Workloads

Service Project B
└── Data Workloads
```

The host project owns centralized network infrastructure.

Service projects consume the shared network while hosting application or platform workloads.

This supports:

- Centralized network governance
- Separation of responsibilities
- Reduced network-management duplication
- Standardized subnet allocation
- Centralized firewall and routing controls
- Independent application ownership

---

## Shared VPC Example

A safe example configuration is included under:

```text
examples/shared-vpc/
```

The example demonstrates how a Shared VPC host project can attach multiple service projects.

Example structure:

```text
Host Project
      |
      v
Shared VPC
   /       \
  /         \
App Project Data Project
```

The example uses placeholder project IDs.

It is not intended to be directly applied without real separate GCP projects.

---

## Terraform Dependency Model

Terraform automatically determines creation order through references.

For example:

```hcl
network_self_link = module.vpc.network_self_link
```

creates a dependency between the subnet and VPC.

Similarly:

```hcl
router_name = module.router_us_central1.router_name
```

creates a dependency between Cloud NAT and Cloud Router.

The current dependency model is approximately:

```text
Development Environment
          |
          v
         VPC
          |
    +-----+-----------------------+
    |             |               |
    v             v               v
 Subnets       Firewall          DNS
    |
    v
Cloud Router
    |
 +--+----------------+
 |                   |
 v                   v
NAT                HA VPN
                      |
                      v
                  BGP Peers
```

---

## Terraform Workflow

The project follows a standard Infrastructure as Code workflow:

```text
Write Terraform
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

## Validation Commands

Format Terraform:

```bash
terraform fmt -recursive
```

Initialize Terraform:

```bash
terraform init
```

Validate configuration:

```bash
terraform validate
```

Review planned infrastructure changes:

```bash
terraform plan
```

Deploy when the target environment is ready:

```bash
terraform apply
```

---

## Git Workflow

Development is performed using feature branches rather than directly modifying `main`.

Example:

```text
main
 |
 +---- feature/base-network
 |
 +---- feature/network-observability
 |
 +---- feature/cloud-dns
 |
 +---- feature/ha-vpn
 |
 +---- feature/shared-vpc
```

Each feature follows:

```text
Create Branch
     |
     v
Develop
     |
     v
Validate
     |
     v
Commit
     |
     v
Push
     |
     v
Pull Request
     |
     v
Review
     |
     v
Merge to main
```

Example commands:

```bash
git switch -c feature/example
git add .
git commit -m "feat: add example feature"
git push -u origin feature/example
```

---

## Security Practices

Sensitive and machine-specific files are excluded from source control.

The repository ignores files such as:

```text
.terraform/
*.tfstate
*.tfstate.*
terraform.tfvars
.DS_Store
```

Terraform state and sensitive local variable files should not be committed to a public repository.

Secrets such as VPN pre-shared keys are defined through sensitive variables and should be provided outside source control.

---

## Current Status

Completed:

- Custom-mode VPC
- Regional subnets
- Firewall module
- Cloud Router
- Cloud NAT
- VPC Flow Logs
- Firewall logging
- Cloud NAT logging
- Private Cloud DNS
- DNS query logging
- HA VPN
- Redundant VPN tunnels
- BGP peers
- Shared VPC module
- Shared VPC example configuration
- Terraform module structure
- Git feature branches
- Pull Request workflow
- Terraform formatting
- Terraform validation

Some real GCP deployment steps are pending billing, API availability, and external peer infrastructure.

---

## Future Enhancements

Planned improvements include:

- Production environment
- Additional subnet segmentation
- Hierarchical firewall policies
- More granular firewall rules
- VPC Service Controls
- Private Service Connect
- Network Connectivity Center
- Cloud Interconnect design
- Additional BGP route policies
- Route advertisements
- Route filtering
- Multi-region Cloud Router design
- DNS routing policies
- DNS failover
- Centralized logging
- Cloud Monitoring dashboards
- Terraform remote state
- GitHub Actions CI/CD
- Terraform security scanning
- Open Policy Agent
- Automated policy validation
- Python network troubleshooting tools
- Automated route analysis
- Architecture diagrams

---

## Skills Demonstrated

This project demonstrates practical experience with:

- Google Cloud Platform
- GCP Networking
- VPC design
- Regional subnet design
- CIDR planning
- Firewall rules
- Cloud Router
- Cloud NAT
- VPC Flow Logs
- Cloud DNS
- Private DNS
- HA VPN
- BGP
- Dynamic routing
- Shared VPC
- Hybrid connectivity
- Terraform
- Terraform modules
- Infrastructure as Code
- Git
- GitHub
- Feature branch workflows
- Pull Requests
- Network troubleshooting
- Cloud network observability
- Enterprise network architecture

---

## Project Goal

The long-term goal of this project is to evolve it into a realistic enterprise GCP networking platform demonstrating:

- Secure connectivity
- Centralized network governance
- Hybrid networking
- Dynamic routing
- Observability
- Troubleshooting
- Infrastructure automation
- Policy enforcement
- Production-style Infrastructure as Code practices