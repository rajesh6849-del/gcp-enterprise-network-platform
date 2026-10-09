output "host_project_id" {
  description = "The Shared VPC host project ID."
  value       = google_compute_shared_vpc_host_project.host.project
}

output "service_project_ids" {
  description = "The service projects attached to the Shared VPC host."
  value       = var.service_project_ids
}