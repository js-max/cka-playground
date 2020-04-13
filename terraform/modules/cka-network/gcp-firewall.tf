resource "google_compute_firewall" "allow-internal" {

  name    = lower(format("%s", "${var.global_identifiers["google_compute_firewall"]}-${var.cluster}-fw-allow-internal"))
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [
    "${var.cka-subnet}"
  ]

}

resource "google_compute_firewall" "allow-ssh" {

  name    = lower(format("%s", "${var.global_identifiers["google_compute_firewall"]}-${var.cluster}-fw-allow-ssh"))
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh"]

}
