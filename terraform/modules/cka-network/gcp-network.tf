resource "google_compute_network" "vpc" {

  name                    = lower(format("%s", "${var.global_identifiers["google_compute_network"]}-${var.cluster}-vnet"))
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"

}

resource "google_compute_subnetwork" "cka-subnet" {

  name          = lower(format("%s", "${var.global_identifiers["google_compute_subnetwork"]}-${var.cluster}-cka-subnet"))
  ip_cidr_range = var.cka-subnet
  network       = google_compute_network.vpc.self_link
  region        = var.region_name

}
