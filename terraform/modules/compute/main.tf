// Module: compute
// Purpose: Provision EC2 instances that run k3s (server and agent)

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

# ─── k3s Server (control-plane + workloads) ───────────────────────────────────
# Public subnet so we can kubectl from laptop directly
resource "aws_instance" "k3s_server" {
  ami                    = data.aws_ami.ubuntu_22.id
  instance_type          = var.server_instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.k3s_server_sg_id]
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile

  root_block_device {
    volume_size = 40
    volume_type = "gp3"
  }

  tags = {
    Name    = "${var.project_name}-${var.environment}-k3s-server"
    Role    = "k3s-server"
    Project = var.project_name
  }
}

# ─── k3s Agent (worker node) ──────────────────────────────────────────────────
# Private subnet - no public IP, reaches internet via NAT
resource "aws_instance" "k3s_agent" {
  ami                    = data.aws_ami.ubuntu_22.id
  instance_type          = var.agent_instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.k3s_agent_sg_id]
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name    = "${var.project_name}-${var.environment}-k3s-agent"
    Role    = "k3s-agent"
    Project = var.project_name
  }
}
