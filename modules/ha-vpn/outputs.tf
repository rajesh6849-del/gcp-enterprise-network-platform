output "gateway_name" {
  description = "The HA VPN gateway name."
  value       = google_compute_ha_vpn_gateway.this.name
}

output "gateway_id" {
  description = "The HA VPN gateway ID."
  value       = google_compute_ha_vpn_gateway.this.id
}

output "gateway_self_link" {
  description = "The HA VPN gateway self-link."
  value       = google_compute_ha_vpn_gateway.this.self_link
}