variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "zone_name" {
  description = "The Cloud DNS managed zone name."
  type        = string
}

variable "dns_name" {
  description = "The DNS suffix for the managed zone. Must end with a period."
  type        = string
}

variable "description" {
  description = "Description of the DNS managed zone."
  type        = string
  default     = "Private DNS zone managed by Terraform."
}

variable "network_self_link" {
  description = "The self-link of the VPC authorized to use the private DNS zone."
  type        = string
}

variable "records" {
  description = "DNS records to create in the managed zone."

  type = map(object({
    type    = string
    ttl     = number
    rrdatas = list(string)
  }))

  default = {}
}