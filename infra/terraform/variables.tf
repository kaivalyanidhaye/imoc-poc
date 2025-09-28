variable "aws_region" {
  type        = string
  description = "AWS region to use"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type"
}

variable "instance_name" {
  type        = string
  default     = "itoc-week1"
  description = "Name tag for the EC2 instance"
}

variable "ami_id" {
  type        = string
  default     = "ami-07c1fa5792ef8fe27" # AL2023 in us-east-1
  description = "AMI ID"
}

variable "key_name" {
  type        = string
  default     = "itoc-week1-key"
  description = "EC2 key pair name"
}

variable "public_key" {
  type        = string
  description = "Public key material for the key pair (ssh-ed25519 ...)"
}

variable "sg_name" {
  type        = string
  default     = "itoc-week1-sg"
  description = "Security group name"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "Optional VPC id. If empty, default VPC is used."
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = "Optional Subnet id. If empty, we auto-pick a default subnet not in blocked_azs."
}

variable "blocked_azs" {
  type        = list(string)
  default     = ["us-east-1e"]
  description = "AZs to avoid when auto-selecting a default subnet."
}
