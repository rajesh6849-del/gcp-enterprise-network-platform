variable "project_id" {
  description = "The GCP project ID where the subnet will be created."
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
}

variable "region" {
  description = "The GCP region where the subnet will be created."
  type        = string
}

variable "network_self_link" {
  description = "The self-link of the VPC network."
  type        = string
}

variable "ip_cidr_range" {
  description = "The IPv4 CIDR range for the subnet."
  type        = string
}