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
    application_gateway        = "GW"
    application_security_group = "AG"
    availability_set           = "AS"
    encryption_key             = "EK"
    disk                       = "VD"
    eventhub                   = "EH"
    eventhub_auth_rule         = "ER"
    eventhub_namespace         = "EN"
    key_vault                  = "KV"
    load_balancer              = "LB"
    nic                        = "NI"
    postgresql                 = "PS"
    resource_group             = "RG"
    resource_lock              = "RL"
    subnet                     = "SN"
    udr                        = "UR"
    vip                        = "IP"
    vnet                       = "VN"
    vnet_gateway               = "VG"
    google_compute_instance    = "VM"
    google_compute_firewall    = "FW"
    google_compute_network     = "VPC"
    google_compute_subnetwork  = "SN"
  }

}
