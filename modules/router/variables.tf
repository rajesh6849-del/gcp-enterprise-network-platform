variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "router_name" {
  description = "The Cloud Router name."
  type        = string
}

variable "region" {
  description = "The GCP region where the Cloud Router will be created."
  type        = string
}

variable "network_self_link" {
  description = "The VPC self-link."
  type        = string
}

variable "bgp_asn" {
  description = "The BGP ASN used by the Cloud Router."
  type        = number
  default     = 64514
}