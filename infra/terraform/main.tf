data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"] # Amazon
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_key_pair" "itoc" {
  key_name   = "${var.instance_name}-key"
  public_key = var.ssh_public_key
}

resource "aws_security_group" "observability" {
  name        = "${var.instance_name}-sg"
  description = "Observability Core SG"
  vpc_id      = data.aws_vpc.default.id

  # Core access (POC-open; tighten in prod)
  ingress { from_port = 22   to_port = 22   protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }   # SSH
  ingress { from_port = 80   to_port = 80   protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }   # optional: future reverse-proxy
  ingress { from_port = 3000 to_port = 3000 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }   # Grafana
  ingress { from_port = 9090 to_port = 9090 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }   # Prometheus
  ingress { from_port = 9093 to_port = 9093 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }   # Alertmanager
  ingress { from_port = 3100 to_port = 3100 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }   # Loki
  ingress { from_port = 3200 to_port = 3200 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }   # Tempo (HTTP/UI)

  # App + OTLP ingress
  ingress { from_port = 8080 to_port = 8080 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }   # Service A
  ingress { from_port = 4317 to_port = 4317 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }   # OTLP gRPC
  ingress { from_port = 4318 to_port = 4318 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }   # OTLP HTTP

  egress  { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}

resource "aws_instance" "itoc" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.observability.id]
  key_name               = aws_key_pair.itoc.key_name

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
