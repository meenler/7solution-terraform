module "network" {
  source                  = "../../modules/network"
  network_name            = "vpc-gke-dev"
  region                  = var.region
  subnet_ip_cidr          = "10.10.0.0/24"
  pods_secondary_cidr     = "10.11.0.0/16"
  services_secondary_cidr = "10.12.0.0/20"
}

module "nat" {
  source       = "../../modules/nat"
  region       = var.region
  network      = module.network.network_self_link
  network_name = "vpc-gke-dev"
}

module "gke" {
  source                  = "../../modules/gke_autopilot"
  cluster_name            = "gke-autopilot-dev"
  region                  = var.region
  network                 = module.network.network_self_link
  subnetwork              = module.network.subnet_self_link
  authorized_cidrs        = var.authorized_cidrs
  release_channel         = "REGULAR"
  enable_private_nodes    = true
  enable_private_endpoint = false
  master_ipv4_cidr        = "172.16.0.0/28"
}

module "iam_app" {
  source     = "../../modules/iam"
  project_id = var.project_id
  gsa_name   = "app-dev-sa"
  roles      = ["roles/storage.objectViewer"]
}
