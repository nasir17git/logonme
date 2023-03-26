resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "alb-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = ""
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = ""
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb-sg"
  }
}

resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.pub1.id, aws_subnet.pub3.id]
  idle_timeout       = 300
  tags = {
    Name = "alb"
  }
}

resource "aws_lb_listener" "alb-http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}


resource "aws_lb_target_group" "alb" {
  name        = "alb"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id
  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/health_check"
    healthy_threshold   = "3"
    unhealthy_threshold = "2"
    timeout             = "29"
    interval            = "30"
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "ec2-1" {
  target_group_arn = aws_lb_target_group.alb.arn
  target_id        = aws_instance.ec2-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "ec2-2" {
  target_group_arn = aws_lb_target_group.alb.arn
  target_id        = aws_instance.ec2-2.id
  port             = 80
}