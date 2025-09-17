resource "google_container_cluster" "autopilot" {
  name     = var.cluster_name
  location = var.region

  enable_autopilot = true

  network    = var.network
  subnetwork = var.subnetwork

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "allow all"
    }
  }

  release_channel { channel = var.release_channel }

  deletion_protection = false
}

output "cluster_name"     { value = google_container_cluster.autopilot.name }
output "cluster_location" { value = google_container_cluster.autopilot.location }
output "endpoint"         { value = google_container_cluster.autopilot.endpoint }
