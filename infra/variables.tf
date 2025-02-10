variable "zone" {
  type = string
}
variable "machine_type" {
  type = string
}
variable "ssh_user" {
  type = string
  default = "user-local"
}
variable "ssh_pub_key_file" {
  type = string
  default = "iac-alura-key.pub"
}
