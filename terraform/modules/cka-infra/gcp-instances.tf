resource "google_compute_instance" "cka_master" {

  name         = lower(format("%s", "${var.global_identifiers["google_compute_instance"]}-${var.cluster}-cka-master-01"))
  machine_type = "e2-small"
  zone         = format("%s", "${var.region_name}-a")

  tags = ["ssh"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20200317"
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_key}"
  }

  network_interface {
    subnetwork = var.subnet_cka_name
    access_config {

    }
  }

}

resource "google_compute_instance" "cka_worker" {

  name         = lower(format("%s", "${var.global_identifiers["google_compute_instance"]}-${var.cluster}-cka-worker-${format("%02d", count.index + 1)}"))
  count        = 3
  machine_type = "e2-small"
  zone         = format("%s", "${var.region_name}-a")

  tags = ["ssh"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20200317"
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_key}"
  }

  network_interface {
    subnetwork = var.subnet_cka_name
    access_config {

    }
  }

}
