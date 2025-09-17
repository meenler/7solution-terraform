resource "google_compute_router" "router" {
  name    = "${var.network_name}-router"
  region  = var.region
  network = var.network
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

output "router_name" { value = google_compute_router.router.name }
output "nat_name"    { value = google_compute_router_nat.nat.name }
