resource "aws_instance" "ec2-1" {
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = "t2.micro"
  key_name               = "nasirk17"
  iam_instance_profile   = "nasir-ec2-profile"
  subnet_id              = aws_subnet.pri1.id
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  user_data              = local.user_data_221018

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = "ec2-1"
  }
}

resource "aws_instance" "ec2-2" {
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = "t2.micro"
  key_name               = "nasirk17"
  iam_instance_profile   = "nasir-ec2-profile"
  subnet_id              = aws_subnet.pri3.id
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  user_data              = local.user_data_221018

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = "ec2-2"
  }
}

resource "aws_security_group" "ec2-sg" {
  name        = "ec2-sg"
  description = "Security group for ec2"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["43.201.0.79/32"]
    security_groups = [aws_security_group.bastion-sg.id, aws_security_group.alb-sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}


