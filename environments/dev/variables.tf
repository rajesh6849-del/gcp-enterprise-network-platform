variable "project_id" {
  description = "GCP project ID for the development environment."
  type        = string
}
variable "peer_gateway_ip_0" {
  description = "Public IP of peer VPN gateway interface 0."
  type        = string
}

variable "peer_gateway_ip_1" {
  description = "Public IP of peer VPN gateway interface 1."
  type        = string
}

variable "vpn_shared_secret" {
  description = "Pre-shared key for HA VPN tunnels."
  type        = string
  sensitive   = true
}