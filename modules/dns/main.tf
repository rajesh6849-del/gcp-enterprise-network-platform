resource "google_dns_managed_zone" "this" {
  name        = var.zone_name
  project     = var.project_id
  dns_name    = var.dns_name
  description = var.description

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = var.network_self_link
    }
  }
}

resource "google_dns_record_set" "records" {
  for_each = var.records

  name         = "${each.key}.${var.dns_name}"
  project      = var.project_id
  managed_zone = google_dns_managed_zone.this.name
  type         = each.value.type
  ttl          = each.value.ttl
  rrdatas      = each.value.rrdatas
}
resource "google_dns_policy" "logging" {
  name    = "${var.zone_name}-logging-policy"
  project = var.project_id

  enable_logging = true

  networks {
    network_url = var.network_self_link
  }
}