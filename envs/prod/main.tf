module "network" {
  source                  = "../../modules/network"
  network_name            = "vpc-gke-prod"
  region                  = var.region
  subnet_ip_cidr          = "10.20.0.0/24"
  pods_secondary_cidr     = "10.21.0.0/16"
  services_secondary_cidr = "10.22.0.0/20"
}

module "nat" {
  source       = "../../modules/nat"
  region       = var.region
  network      = module.network.network_self_link
  network_name = "vpc-gke-prod"
}

module "gke" {
  source                  = "../../modules/gke_standard"
  cluster_name            = "gke-7sulotion-prod"
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
  gsa_name   = "app-prod-sa"
  roles      = ["roles/storage.objectViewer"]
}
