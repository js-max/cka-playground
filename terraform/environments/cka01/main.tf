# To create network
module "cka01_network" {

  source  = "../../modules/cka-network"
  cluster = "cka01"

}

# To create cka infra
module "cka01_infra" {

  source = "../../modules/cka-infra"

  cluster         = "cka01"
  ssh_user        = "CHANGE_ME"
  ssh_key         = "CHANGE_ME"
  vpc_name        = module.cka01_network.vpc_name
  vpc_self_link   = module.cka01_network.vpc_self_link
  subnet_cka_name = module.cka01_network.subnet_cka_name

}
