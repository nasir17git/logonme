data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazonlinux2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

locals {
  user_data_221018 = <<EOF
#!/bin/bash

## timezone
sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "  
export HISTSIZE=100000
export HISTFILESIZE=100000' >> /home/ec2-user/.bash_profile

# https setting
wget https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-x86_64
mv busybox-x86_64 busybox
chmod +x busybox
RZAZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone-id)
IID=$(curl 169.254.169.254/latest/meta-data/instance-id)
LIP=$(curl 169.254.169.254/latest/meta-data/local-ipv4)
echo "<h1>RegionAz($RZAZ) : Instance ID($IID) : Private IP($LIP) : Web Server</h1>" > index.html
nohup ./busybox httpd -f -p 80 &
EOF 

  bastion_221018 = <<EOF
#!/bin/bash

## timezone
sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "  
export HISTSIZE=100000
export HISTFILESIZE=100000' >> /home/ec2-user/.bash_profile

# nat instance conf
sudo sysctl -w net.ipv4.ip_forward=1
sudo /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo yum install -y iptables-services
sudo service iptables save
EOF 
}