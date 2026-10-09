module "shared_vpc" {
  source = "../../modules/shared-vpc"

  host_project_id = var.host_project_id

  service_project_ids = [
    var.app_service_project_id,
    var.data_service_project_id
  ]
}