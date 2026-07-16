output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_a" {
  value = aws_subnet.public_a.id
}

output "public_subnet_b" {
  value = aws_subnet.public_b.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}

output "public_route_table" {
  value = aws_route_table.public_rt.id
}

output "private_route_table" {
  value = aws_route_table.private_rt.id
}

output "bastion_sg" {
  value = aws_security_group.bastion_sg.id
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "web_sg" {
  value = aws_security_group.web_sg.id
}

output "app_sg" {
  value = aws_security_group.app_sg.id
}

output "db_sg" {
  value = aws_security_group.db_sg.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "web1_private_ip" {
  value = aws_instance.web1.private_ip
}

output "web2_private_ip" {
  value = aws_instance.web2.private_ip
}

output "app1_private_ip" {
  value = aws_instance.app1.private_ip
}

output "app2_private_ip" {
  value = aws_instance.app2.private_ip
}

output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}