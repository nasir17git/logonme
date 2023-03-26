output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "alb" {
  value = aws_lb.alb.dns_name
}