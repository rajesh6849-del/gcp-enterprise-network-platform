variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "nat_name" {
  description = "The Cloud NAT name."
  type        = string
}

variable "region" {
  description = "The GCP region where Cloud NAT will be created."
  type        = string
}

variable "router_name" {
  description = "The Cloud Router name used by Cloud NAT."
  type        = string
}