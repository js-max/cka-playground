variable "cluster" {

}

variable "cka-subnet" {

  default = "10.25.1.0/24"

}

variable "region_name" {

  default = "CHANGE_ME"

}

variable "global_identifiers" {

  type = map

  default = {
    google_compute_instance    = "VM"
    google_compute_firewall    = "FW"
    google_compute_network     = "VPC"
    google_compute_subnetwork  = "SN"
  }

}
