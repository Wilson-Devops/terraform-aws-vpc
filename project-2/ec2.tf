resource "aws_instance" "bastion" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.public_a.id

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  key_name = "devops-key"

  associate_public_ip_address = true

  tags = {
    Name = "Bastion-Host"
  }
}

resource "aws_instance" "private_server" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.private_a.id

  vpc_security_group_ids = [
    aws_security_group.private_sg.id
  ]

  key_name = "devops-key"

  associate_public_ip_address = false

  tags = {
    Name = "Private-Server"
  }
}