variable "aws_region" {
  type        = string
  description = "us-east-1"
}

variable "ssh_public_key" {
  type        = string
  description = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+I6NPahrhQZN19f6ulX55HFFAqEMT30yFH7Ocsep+j itoc-poc"
}

variable "instance_name" {
  type    = string
  default = "itoc-week1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
