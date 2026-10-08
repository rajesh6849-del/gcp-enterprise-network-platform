variable "project_id" {
  description = "The GCP project ID where the VPC will be created."
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network."
  type        = string
}

variable "routing_mode" {
  description = "The dynamic routing mode for the VPC."
  type        = string
  default     = "GLOBAL"
}