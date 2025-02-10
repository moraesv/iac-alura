module "vm-dev" {
  source = "../../infra"
  machine_type = "e2-micro"
  zone = "us-central1-a"
  ssh_user = "user-dev"
  ssh_pub_key_file = "iac-alura-key-dev.pub"
}

output "IP" {
  value = module.vm-dev.PUBLIC_IPS
}