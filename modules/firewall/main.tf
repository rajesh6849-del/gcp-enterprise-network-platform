resource "google_compute_firewall" "this" {
  name    = var.rule_name
  project = var.project_id
  network = var.network_self_link

  direction = var.direction
  priority  = var.priority

  source_ranges = var.source_ranges
  target_tags   = var.target_tags

  allow {
    protocol = var.protocol
    ports    = var.ports
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}