# AWS상에 간단한 HTTP WEB EC2 배포
terraform {
  cloud {
    organization = "logonme"
    workspaces {
      name = "init"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.10.0"
    }
  }
}

# ------ Provider 
provider "aws" {
  region = "ap-northeast-2"
}

# ------ VPC and Internet Gateway
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "${var.env}-${var.name_prefix}-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "${var.env}-${var.name_prefix}-igw" }
}

# ------ Public Subnets and Routing
resource "aws_subnet" "pub" {
  for_each          = var.pub_subnet_cidrs
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[each.key - 1]
  cidr_block        = each.value
  tags              = { Name = "${var.env}-${var.name_prefix}-pub${each.key}" }
}

resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.env}-${var.name_prefix}-pub-rt" }
}

resource "aws_route_table_association" "pub-rta" {
  for_each       = aws_subnet.pub
  subnet_id      = each.value.id
  route_table_id = aws_route_table.pubrt.id
}

# ------ Web EC2
resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazonlinux2.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.pub[1].id
  vpc_security_group_ids      = [aws_security_group.web.id]
  user_data                   = local.web
  tags = {
    Name = "${var.env}-${var.name_prefix}-ec2"
  }
}
resource "aws_security_group" "web" {
  name        = "${var.env}-${var.name_prefix}-sg"
  description = "${var.env}-${var.name_prefix}-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-${var.name_prefix}-sg"
  }
}

# ------ Outputs
output "remote_ip" {
  value = aws_instance.web.public_ip
}