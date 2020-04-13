output "vpc_name" {

  value = google_compute_network.vpc.name

}

output "vpc_self_link" {

  value = google_compute_network.vpc.self_link

}

output "subnet_cka_name" {

  value = google_compute_subnetwork.cka-subnet.name

}
