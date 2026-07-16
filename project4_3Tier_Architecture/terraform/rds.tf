# Create DB Subnet Group
resource "aws_db_subnet_group" "main" {

  name = "devops-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_db_a.id,
    aws_subnet.private_db_b.id
  ]

  tags = {
    Name = "devops-db-subnet-group"
  }
}

# Create RDS MySQL
resource "aws_db_instance" "mysql" {

  identifier = "devops-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  username = "admin"
  password = "Devops123!"

  db_name = "devopsdb"

  publicly_accessible = false

  multi_az = false

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    aws_security_group.db_sg.id
  ]

  skip_final_snapshot = true

  tags = {
    Name = "devops-mysql"
  }
}

