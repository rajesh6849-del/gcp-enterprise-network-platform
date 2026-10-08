resource "google_compute_router" "this" {
  name    = var.router_name
  project = var.project_id
  region  = var.region
  network = var.network_self_link

  bgp {
    asn = var.bgp_asn
  }
}