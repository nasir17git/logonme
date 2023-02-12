# variable 사전 입력
variable "name_prefix" { default = "logonme" }
variable "env" { default = "init" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "pub_subnet_cidrs" {
  default = {
    1 = "10.0.13.0/24"
    2 = "10.0.23.0/24"
    3 = "10.0.33.0/24"
  }
}
variable "pri_subnet_cidrs" {
  default = {
    1 = "10.0.44.0/24"
    2 = "10.0.50.0/24"
    3 = "10.0.60.0/24"
  }
}
variable "server_port" { default = "80" }

locals {
  web = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "WebServer with PrivateIP: $MYIP. Built by Terraform" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF
}

# ------ 작동을 위해 필요한 값을 받아오는 data들
# AZ
data "aws_availability_zones" "available" { state = "available" }

# amazon linux 
data "aws_ami" "amazonlinux2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
