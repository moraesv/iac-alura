terraform {
  required_providers {
    mgc = {
      source = "magalucloud/mgc"
    }
  }
}

resource "mgc_ssh_keys" "my_key" {
  name = var.ssh_user
  key  = file(var.ssh_pub_key_file)
}

provider "mgc" {
  api_key = var.api_key
  region  = var.region
}

# Create VPC
resource "mgc_network_vpcs" "main_vpc" {
  name = "main-vpc"
}

# Create subnet pool
resource "mgc_network_subnetpools" "main_subnetpool" {
  name        = "main-subnetpool"
  description = "Main Subnet Pool"
  type        = "pip"
  cidr        = "172.5.0.0/16"
}

# Create subnet
resource "mgc_network_vpcs_subnets" "primary_subnet" {
  cidr_block      = "172.5.1.0/24"
  description     = "Primary Network Subnet"
  dns_nameservers = ["8.8.8.8", "1.1.1.1"]
  ip_version      = "IPv4"
  name            = "primary-subnet"
  subnetpool_id   = mgc_network_subnetpools.main_subnetpool.id
  vpc_id          = mgc_network_vpcs.main_vpc.id
}

# Create security group
resource "mgc_network_security_groups" "vm_sg" {
  name        = "vm-security-group"
  description = "Security group for VM access"
}

# Add SSH rule to security group
resource "mgc_network_security_groups_rules" "ssh_rule" {
  description       = "Allow SSH access"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.vm_sg.id
}

# Add App rule to security group
resource "mgc_network_security_groups_rules" "app_rule" {
  description       = "Allow App access"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 8000
  port_range_max    = 8000
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.vm_sg.id
}

# Create network interface
resource "mgc_network_vpcs_interfaces" "vm_interface" {
  name   = "vm-interface"
  vpc_id = mgc_network_vpcs.main_vpc.id

  # Important: Wait for subnet to be created
  depends_on = [mgc_network_vpcs_subnets.primary_subnet]
}

# Attach security group to interface
resource "mgc_network_security_groups_attach" "sg_attachment" {
  security_group_id = mgc_network_security_groups.vm_sg.id
  interface_id      = mgc_network_vpcs_interfaces.vm_interface.id
}

# Create public IP
resource "mgc_network_public_ips" "vm_public_ip" {
  description = "VM public IP"
  vpc_id      = mgc_network_vpcs.main_vpc.id
}

# Attach public IP to interface
resource "mgc_network_public_ips_attach" "ip_attachment" {
  public_ip_id = mgc_network_public_ips.vm_public_ip.id
  interface_id = mgc_network_vpcs_interfaces.vm_interface.id
}

# Create VM
resource "mgc_virtual_machine_instances" "custom_vm" {
  name         = "custom-vm"
  machine_type = var.machine_type
  image        = var.image
  ssh_key_name = mgc_ssh_keys.my_key.name
}

# Attach interface to VM
resource "mgc_virtual_machine_interface_attach" "interface_attachment" {
  instance_id  = mgc_virtual_machine_instances.custom_vm.id
  interface_id = mgc_network_vpcs_interfaces.vm_interface.id
}

# Output the public IP
output "vm_public_ip" {
  value = mgc_network_public_ips.vm_public_ip.public_ip
}

