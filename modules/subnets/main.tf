resource "google_compute_subnetwork" "this" {
  name          = var.subnet_name
  project       = var.project_id
  region        = var.region
  network       = var.network_self_link
  ip_cidr_range = var.ip_cidr_range

  private_ip_google_access = true
}