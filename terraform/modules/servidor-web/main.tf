data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Chave SSH
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "main" {
  key_name   = "${var.nome_projeto}-${var.environment}"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Instância EC2 t3.micro
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.main.key_name

  tags = {
    Name     = "instancia-ec2-${var.nome_projeto}-${var.environment}"
    Curso    = "pos-devops-iac"
    Ambiente = var.environment
  }
}
