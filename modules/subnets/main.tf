resource "google_compute_subnetwork" "this" {
  name          = var.subnet_name
  project       = var.project_id
  region        = var.region
  network       = var.network_self_link
  ip_cidr_range = var.ip_cidr_range

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}