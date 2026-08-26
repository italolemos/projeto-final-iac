# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "${var.nome_projeto}-vpc"
    Environment = terraform.workspace
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.nome_projeto}-igw"
    tags = "${var.nome_projeto}-igw-${terraform.workspace}"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.nome_projeto}-public-subnet"
    Environment = terraform.workspace
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.nome_projeto}-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group portas 22 e 3000.
resource "aws_security_group" "web" {
  name        = "secgrp-${var.nome_projeto}"
  description = "Libera SSH e a porta de aplicacao do modulo servidor-web"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH apenas do IP autorizado"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Porta de HTTP da aplicacao"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "security-grp-${var.nome_projeto}"
    Curso = "pos-devops-iac"
    Ambiente  = terraform.workspace
  }
}