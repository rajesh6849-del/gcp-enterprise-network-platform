variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "gateway_name" {
  description = "The HA VPN gateway name."
  type        = string
}

variable "region" {
  description = "The GCP region where the HA VPN gateway will be created."
  type        = string
}

variable "network_self_link" {
  description = "The VPC self-link."
  type        = string
}