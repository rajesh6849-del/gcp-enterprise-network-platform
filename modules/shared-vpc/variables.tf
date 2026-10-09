variable "host_project_id" {
  description = "The GCP project ID that will act as the Shared VPC host project."
  type        = string
}

variable "service_project_ids" {
  description = "List of GCP service project IDs to attach to the Shared VPC host project."
  type        = list(string)
  default     = []
}