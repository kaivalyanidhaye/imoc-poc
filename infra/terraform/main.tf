# Flexible VPC selection: if var.vpc_id is empty, use the default VPC
data "aws_vpc" "default" {
  count   = var.vpc_id == "" ? 1 : 0
  default = true
}

locals {
  effective_vpc_id = var.vpc_id != "" ? var.vpc_id : one([for v in data.aws_vpc.default : v.id])
}

# Discover subnets in the chosen VPC
data "aws_subnets" "in_vpc" {
  filter {
    name   = "vpc-id"
    values = [local.effective_vpc_id]
  }
}

# Get details for each subnet (to read its AZ)
data "aws_subnet" "details" {
  for_each = toset(data.aws_subnets.in_vpc.ids)
  id       = each.value
}

# Pick a subnet automatically unless one was provided; avoid blocked AZs (e.g., us-east-1e)
locals {
  candidate_subnets = [
    for s in data.aws_subnet.details :
    s.id if !contains(var.blocked_azs, s.availability_zone)
  ]
  # Use provided subnet if set; otherwise first candidate (or null if none)
  chosen_subnet_id = var.subnet_id != "" ? var.subnet_id : try(local.candidate_subnets[0], null)
}

# Decoupled key pair: explicit name + injected public key
resource "aws_key_pair" "itoc" {
  key_name   = var.key_name
  public_key = var.public_key
}

# SG name is explicit; same open ports as your POC
resource "aws_security_group" "observability" {
  name        = var.sg_name
  description = "Observability Core SG"
  vpc_id      = local.effective_vpc_id

  # Core access (POC-open; tighten in prod)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3200
    to_port     = 3200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # App + OTLP ingress
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 4317
    to_port     = 4317
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 4318
    to_port     = 4318
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "itoc" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.itoc.key_name
  subnet_id              = local.chosen_subnet_id
  vpc_security_group_ids = [aws_security_group.observability.id]

  lifecycle {
    precondition {
      condition     = local.chosen_subnet_id != null
      error_message = "No available subnet found in VPC after excluding blocked AZs. Set var.subnet_id explicitly."
    }
  }

  # keep your original bootstrap for Docker-based POC
  user_data = <<-EOF
    #!/usr/bin/bash
    set -eux
    dnf update -y
    dnf install -y docker git tar
    systemctl enable --now docker
    usermod -aG docker ec2-user
    dnf install -y docker-compose-plugin || true
    mkdir -p /opt/itoc
    # basic docker log rotation
    cat >/etc/docker/daemon.json <<JSON
    {"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"3"}}
JSON
    systemctl restart docker || true
  EOF

  tags = { Name = var.instance_name }
}
