variable "aws_region" {
  type        = string
  description = "AWS region, e.g., ap-south-1"
}

variable "ssh_public_key" {
  type        = string
  description = "Your ED25519/RSA public key contents"
}

variable "instance_name" {
  type        = string
  default     = "itoc-week1"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
}
