data "aws_ami" "ubuntu_22" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ─── Vault Security Group ─────────────────────────────────────────────────────
resource "aws_security_group" "vault" {
  name        = "${var.project_name}-${var.environment}-sg-vault"
  description = "HashiCorp Vault: API from EKS nodes + admin SSH"
  vpc_id      = var.vpc_id

  ingress {
    description = "Vault API from VPC (EKS nodes)"
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "SSH from admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.your_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-${var.environment}-sg-vault" }
}

# ─── Vault EC2 Instance ────────────────────────────────────────────────────────
# t3.micro is sufficient for Vault dev/portfolio mode
resource "aws_instance" "vault" {
  ami                    = data.aws_ami.ubuntu_22.id
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.vault.id]
  key_name               = var.key_name

  # Install Vault automatically on boot
  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Install Vault
    apt-get update -y
    apt-get install -y wget gpg

    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com jammy main" > /etc/apt/sources.list.d/hashicorp.list
    apt-get update -y
    apt-get install -y vault

    # Create Vault config
    mkdir -p /etc/vault.d /opt/vault/data

    cat > /etc/vault.d/vault.hcl <<'VAULTCONF'
ui = true

storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = true
}

api_addr = "http://0.0.0.0:8200"
cluster_addr = "http://0.0.0.0:8201"
VAULTCONF

    # Create systemd service
    cat > /etc/systemd/system/vault.service <<'SVCCONF'
[Unit]
Description=HashiCorp Vault
After=network.target

[Service]
ExecStart=/usr/bin/vault server -config=/etc/vault.d/vault.hcl
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
LimitNOFILE=65536
User=vault
Group=vault

[Install]
WantedBy=multi-user.target
SVCCONF

    useradd -r -s /bin/false vault 2>/dev/null || true
    chown -R vault:vault /opt/vault /etc/vault.d

    systemctl daemon-reload
    systemctl enable vault
    systemctl start vault

    echo "Vault installed and started" > /tmp/vault-init.log
  EOF

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name    = "${var.project_name}-${var.environment}-vault"
    Project = var.project_name
  }
}
