variable "api_key" {
  type        = string
  sensitive   = true
  description = "The Magalu Cloud API Key"
}

variable "region" {
  type = string
}
variable "machine_type" {
  type = string
}
variable "image" {
  type = string
}
variable "ssh_user" {
  type    = string
  default = "user-local"
}
variable "ssh_pub_key_file" {
  type    = string
  default = "iac-alura-key.pub"
}
