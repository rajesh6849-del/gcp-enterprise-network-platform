variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "rule_name" {
  description = "The firewall rule name."
  type        = string
}

variable "network_self_link" {
  description = "The VPC self-link."
  type        = string
}

variable "direction" {
  description = "Firewall direction."
  type        = string
  default     = "INGRESS"
}

variable "priority" {
  description = "Firewall rule priority."
  type        = number
  default     = 1000
}

variable "source_ranges" {
  description = "Source CIDR ranges."
  type        = list(string)
}

variable "target_tags" {
  description = "Target network tags."
  type        = list(string)
  default     = []
}

variable "protocol" {
  description = "Allowed protocol."
  type        = string
}

variable "ports" {
  description = "Allowed ports."
  type        = list(string)
}