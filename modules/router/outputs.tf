output "router_name" {
  description = "The Cloud Router name."
  value       = google_compute_router.this.name
}

output "router_id" {
  description = "The Cloud Router ID."
  value       = google_compute_router.this.id
}