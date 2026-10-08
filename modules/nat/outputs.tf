output "nat_name" {
  description = "The Cloud NAT name."
  value       = google_compute_router_nat.this.name
}