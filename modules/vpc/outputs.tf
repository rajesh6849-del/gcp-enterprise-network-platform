output "network_id" {
  description = "The ID of the created VPC network."
  value       = google_compute_network.this.id
}

output "network_name" {
  description = "The name of the created VPC network."
  value       = google_compute_network.this.name
}

output "network_self_link" {
  description = "The self-link of the created VPC network."
  value       = google_compute_network.this.self_link
}