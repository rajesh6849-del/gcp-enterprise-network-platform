output "subnet_id" {
  description = "The ID of the subnet."
  value       = google_compute_subnetwork.this.id
}

output "subnet_name" {
  description = "The name of the subnet."
  value       = google_compute_subnetwork.this.name
}

output "subnet_self_link" {
  description = "The self-link of the subnet."
  value       = google_compute_subnetwork.this.self_link
}