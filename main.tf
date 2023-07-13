module "resource" {
  source = "./modules/resource"
}

module "config" {
  source = "./modules/config"
}

module "network" {
  source = "./modules/network"
}

module "controller" {
  source   = "./modules/compute"
  instance = {
    count        = 2
    name_prefix  = "controller"
    tags         = ["bcf23-surokkha", "controller"]
    machine_type = "e2-standard-8"
    boot_disk    = {
      size = 50
    }
  }
  network = {
    name              = module.network.network.name
    subnet_name       = module.network.subnet.name
    subnet_cidr_range = module.config.subnet_ip_cidr_range.controller
  }
}


module "worker" {
  source   = "./modules/compute"
  instance = {
    count        = 3
    name_prefix  = "worker"
    tags         = ["bcf23-surokkha", "worker"]
    machine_type = "e2-standard-2"
  }
  network = {
    name              = module.network.network.name
    subnet_name       = module.network.subnet.name
    subnet_cidr_range = module.config.subnet_ip_cidr_range.worker
  }
}
