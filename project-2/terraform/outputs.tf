output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "private_server_ip" {
  value = aws_instance.private_server.private_ip
}