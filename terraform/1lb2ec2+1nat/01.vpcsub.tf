resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = "vpc"
  }
}

resource "aws_subnet" "pub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidrs["pub1"]
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "test-pub1"
  }
}

resource "aws_subnet" "pub2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidrs["pub2"]
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "test-pub2"
  }
}

resource "aws_subnet" "pub3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidrs["pub3"]
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name = "test-pub3"
  }
}

resource "aws_subnet" "pri1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidrs["pri1"]
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "test-pri1"
  }
}

resource "aws_subnet" "pri2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidrs["pri2"]
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "test-pri2"
  }
}

resource "aws_subnet" "pri3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidrs["pri3"]
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = false

  tags = {
    Name = "test-pri3"
  }
}