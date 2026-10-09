output "zone_name" {
  description = "The Cloud DNS managed zone name."
  value       = google_dns_managed_zone.this.name
}

output "zone_dns_name" {
  description = "The DNS suffix of the managed zone."
  value       = google_dns_managed_zone.this.dns_name
}

output "zone_id" {
  description = "The Cloud DNS managed zone ID."
  value       = google_dns_managed_zone.this.id
}