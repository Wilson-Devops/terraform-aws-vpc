# Data Source for Amazon Linux 2023
data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }
}

# Bastion Host
resource "aws_instance" "bastion" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.public_a.id

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  key_name = "devops-key"

  tags = {
    Name = "bastion-host"
  }
}

# Web Server 1
resource "aws_instance" "web1" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.public_a.id

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  key_name  = "devops-key"
  user_data = file("${path.module}/userdata/web.sh")

  tags = {
    Name = "web-server-1"
  }
}

# Web Server 2
resource "aws_instance" "web2" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.public_b.id

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  key_name  = "devops-key"
  user_data = file("${path.module}/userdata/web.sh")

  tags = {
    Name = "web-server-2"
  }
}


# App Server 1
resource "aws_instance" "app1" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.private_app_a.id

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  key_name  = "devops-key"
  user_data = file("${path.module}/userdata/app.sh")

  tags = {
    Name = "app-server-1"
  }
}

# App Server 2
resource "aws_instance" "app2" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.private_app_b.id

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  key_name  = "devops-key"
  user_data = file("${path.module}/userdata/app.sh")

  tags = {
    Name = "app-server-2"
  }
}





