resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type

  subnet_id              = var.source_subnet_ids[0]
  key_name               = aws_secretsmanager_secret.ec2.name
  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  user_data = file("${path.module}/setup_ec2.sh")

  lifecycle {
    ignore_changes = [ami]
  }

  depends_on = [aws_security_group.ec2, aws_key_pair.ec2]
  tags       = { Name = local.name }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server*",
    ] # Needs to be as restrictive as possible
  }

  filter {
    name = "root-device-type"

    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"

    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical (Ubuntu)
}

# Generate SSH key
resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create keypair in AWS using generated SSH key
resource "aws_key_pair" "ec2" {
  key_name   = local.name
  public_key = tls_private_key.generated_key.public_key_openssh
}

# Store SSH key in Secret Manager
resource "aws_secretsmanager_secret" "ec2" {
  name                    = local.name
  description             = "EC2 Keypair for ${local.name}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "ec2" {
  secret_id     = aws_secretsmanager_secret.ec2.id
  secret_string = tls_private_key.generated_key.private_key_pem
}

resource "aws_security_group" "ec2" {
  name        = local.name
  description = "Open SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
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
