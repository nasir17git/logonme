resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = "t2.micro"
  key_name               = "nasirk17"
  subnet_id              = aws_subnet.pub1.id
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  source_dest_check      = false
  user_data              = local.bastion_221018

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = "test-bastion"
  }
}

resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  description = "Security group for bastion+nat"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["182.222.29.58/32", "43.201.0.79/32", "211.209.175.214/32"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.subnet_cidrs["pri1"], var.subnet_cidrs["pri2"], var.subnet_cidrs["pri3"]]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

