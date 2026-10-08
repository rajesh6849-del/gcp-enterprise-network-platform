module "vpc" {
  source = "../../modules/vpc"

  project_id   = var.project_id
  network_name = "enterprise-dev-vpc"
  routing_mode = "GLOBAL"
}
module "subnet_us_central1" {
  source = "../../modules/subnets"

  project_id        = var.project_id
  subnet_name       = "dev-us-central1-subnet"
  region            = "us-central1"
  network_self_link = module.vpc.network_self_link
  ip_cidr_range     = "10.10.0.0/24"
}

module "subnet_us_east1" {
  source = "../../modules/subnets"

  project_id        = var.project_id
  subnet_name       = "dev-us-east1-subnet"
  region            = "us-east1"
  network_self_link = module.vpc.network_self_link
  ip_cidr_range     = "10.20.0.0/24"
}
module "allow_internal" {
  source = "../../modules/firewall"

  project_id        = var.project_id
  rule_name         = "allow-internal-dev"
  network_self_link = module.vpc.network_self_link

  source_ranges = [
    "10.10.0.0/24",
    "10.20.0.0/24"
  ]

  protocol = "tcp"

  ports = [
    "22",
    "443"
  ]
}
module "router_us_central1" {
  source = "../../modules/router"

  project_id        = var.project_id
  router_name       = "dev-us-central1-router"
  region            = "us-central1"
  network_self_link = module.vpc.network_self_link
  bgp_asn           = 64514
}
module "nat_us_central1" {
  source = "../../modules/nat"

  project_id  = var.project_id
  nat_name    = "dev-us-central1-nat"
  region      = "us-central1"
  router_name = module.router_us_central1.router_name
}