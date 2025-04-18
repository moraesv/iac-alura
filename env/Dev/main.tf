module "vm-dev" {
  source           = "../../infra"
  api_key          = file("../../apikey")
  region           = "br-se1"
  machine_type     = "BV1-1-10"
  image            = "cloud-ubuntu-24.04 LTS"
  ssh_user         = "user-dev"
  ssh_pub_key_file = "../../iac-alura-key-dev.pub"
}

output "IP" {
  value = module.vm-dev.vm_public_ip
}
