# -------------------------------
# Cluster (Standard)
# -------------------------------
resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.region

  # Standard Cluster (not Autopilot)
  remove_default_node_pool = true
  initial_node_count       = 1

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

  release_channel {
    channel = var.release_channel
  }

  deletion_protection = false
}

# -------------------------------
# Node Pool (separate resource)
# -------------------------------
resource "google_container_node_pool" "primary_nodes" {
  name     = "primary-pool"
  cluster  = google_container_cluster.gke.name
  location = google_container_cluster.gke.location

  # Initial number of nodes in the pool
  node_count = 1

  # Enable autoscaling
  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 40
    disk_type    = "pd-standard"

    # Enable preemptible nodes (~70% cheaper, but terminated every 24h)
    preemptible = true

    # Labels for nodes in this pool
    labels = {
      env = "dev"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

# -------------------------------
# Outputs
# -------------------------------
output "cluster_name" {
  value = google_container_cluster.gke.name
}

output "cluster_location" {
  value = google_container_cluster.gke.location
}

output "endpoint" {
  value = google_container_cluster.gke.endpoint
}

# Helper command to fetch kubeconfig credentials
output "kubeconfig_command" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.gke.name} --region ${google_container_cluster.gke.location}"
}
