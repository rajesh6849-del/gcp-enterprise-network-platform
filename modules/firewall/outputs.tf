output "firewall_rule_name" {
  description = "The firewall rule name."
  value       = google_compute_firewall.this.name
}