resource "google_compute_router_nat" "this" {
  name    = var.nat_name
  project = var.project_id
  region  = var.region
  router  = var.router_name

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ALL"
  }
}