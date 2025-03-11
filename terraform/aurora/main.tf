# # terraform setup
# provider "aws" {
#   region = "ap-northeast-2"
# }

# # network setup
# resource "aws_vpc" "vpc" {
#   cidr_block           = var.vpc_cidr
#   enable_dns_hostnames = true
#   enable_dns_support   = true
#   tags = {
#     "Name" = "vpc"
#   }
# }

# resource "aws_subnet" "pub1" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.subnet_cidrs["pub1"]
#   availability_zone       = data.aws_availability_zones.available.names[0]
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "test-pub1"
#   }
# }

# resource "aws_subnet" "pub2" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.subnet_cidrs["pub2"]
#   availability_zone       = data.aws_availability_zones.available.names[2]
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "test-pub2"
#   }
# }

# resource "aws_subnet" "pri1" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.subnet_cidrs["pri1"]
#   availability_zone       = data.aws_availability_zones.available.names[0]
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "test-pri1"
#   }
# }

# resource "aws_subnet" "pri2" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.subnet_cidrs["pri2"]
#   availability_zone       = data.aws_availability_zones.available.names[2]
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "test-pri2"
#   }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.vpc.id

#   tags = {
#     Name = "igw"
#   }
# }

# resource "aws_route_table" "pubrt" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "pubrt"
#   }
# }

# # RDS Aurora setup
# resource "aws_db_subnet_group" "db-subnet-group" {
#   name = "db-subnet-group"
#   subnet_ids = [aws_subnet.pub1.id, aws_subnet.pub2.id]

# resource "aws_rds_cluster" "aurora-mysql-db" {
#   cluster_identifier = "main" 
#   engine_mode = "provisioned" # DB 인스턴스 생성 시 Provisioned(미설정 시 default) 또는 Serverless 모드 지정
#   db_subnet_group_name = aws_db_subnet_group.db-subnet-group.name # DB가 배치될 서브넷 그룹(.name으로 지정)
#   vpc_security_group_ids = [aws_security_group.db-sg.id] # db 보안그룹 지정
#   engine = "aurora-mysql" # 엔진 유형
#   engine_version = "5.7.mysql_aurora.2.11.1" # 엔진 버전
#   availability_zones = ["ap-northeast-2a", "ap-northeast-2c"] 
#   database_name = var.rds_db_name
#   master_username = var.rds_master_user
#   master_password = var.rds_master_pwd
#   skip_final_snapshot = true
# }

# resource "aws_rds_cluster_instance" "aurora-mysql-db-instance" {
#   identifier = "main-instance"
#   cluster_identifier = aws_rds_cluster.aurora-mysql-db.id
#   instance_class = "db.t3.small" # DB 인스턴스 Class 
#   engine = "aurora-mysql"
#   engine_version = "5.7.mysql_aurora.2.11.1"
# }

# # MySQL instance setup
# resource "aws_instance" "ec2-1" {
#   ami                    = data.aws_ami.amazonlinux2.id
#   instance_type          = "t2.micro"
#   key_name               = var.ec2_key_name
#   iam_instance_profile   = "nasir-ec2-profile"
#   subnet_id              = aws_subnet.pub1.id
#   vpc_security_group_ids = [aws_security_group.ec2-sg.id]
#   user_data              = local.user_data

#   lifecycle {
#     ignore_changes = [ami]
#   }

#   tags = {
#     Name = "mysql-ec2"
#   }
# }

# resource "aws_security_group" "ec2-sg" {
#   name        = "ec2-sg"
#   description = "Security group for ec2"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     from_port       = 0
#     to_port         = 0
#     protocol        = "-1"
#     cidr_blocks     = ["43.201.0.79/32"]
#     security_groups = [aws_security_group.bastion-sg.id, aws_security_group.alb-sg.id]
#   }

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "ec2-sg"
#   }
# }
