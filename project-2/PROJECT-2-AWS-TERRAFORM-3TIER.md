# Project 2 - AWS 3-Tier Infrastructure using Terraform

## Objective

Build a production-style AWS network using Terraform.

This project covers:

- AWS Networking
- Terraform
- VPC
- Public & Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- EC2
- Bastion Host
- SSH Connectivity
- Terraform State Management

---

# Architecture

                    Internet
                        |
                 Internet Gateway
                        |
              -------------------
              |                 |
        Public Subnet-A   Public Subnet-B
              |
         NAT Gateway
              |
        Private Route Table
              |
      -------------------
      |                 |
 Private-A         Private-B


---

# Prerequisites

## Install Terraform

Verify:

```bash
terraform -version
```

Expected:

```bash
Terraform v1.x
```

## Install AWS CLI

Verify:

```bash
aws --version
```

Configure:

```bash
aws configure
```

Verify:

```bash
aws sts get-caller-identity
```

---

# Project Structure

```text
terraform-vpc-project
|
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── vpc.tf
├── subnet.tf
├── igw.tf
├── nat.tf
├── route-table.tf
├── security-group.tf
├── ec2.tf
└── outputs.tf
```

---

# Step 1 - Provider Configuration

## provider.tf

```hcl
terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

---

# Step 2 - Variables

## variables.tf

```hcl
variable "aws_region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
```

## terraform.tfvars

```hcl
aws_region = "ap-south-1"
vpc_cidr   = "10.0.0.0/16"
```

---

# Step 3 - Create VPC

## vpc.tf

```hcl
resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "DevOps-VPC"
  }
}
```

Apply:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Created:

- DevOps-VPC
- CIDR: 10.0.0.0/16

---

# Interview Notes

## Why enable DNS Hostnames?

Required for:

- Load Balancers
- EKS
- Service Discovery

Example:

```text
ip-10-0-1-10.ec2.internal
```

---

## Why use 10.0.0.0/16?

Provides:

```text
65,536 IPs
```

Enough for future scaling.

---

# Step 4 - Create Subnets

## subnet.tf

### Public Subnet A

```hcl
resource "aws_subnet" "public_a" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-A"
  }
}
```

### Public Subnet B

```hcl
resource "aws_subnet" "public_b" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-B"
  }
}
```

### Private Subnet A

```hcl
resource "aws_subnet" "private_a" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Private-Subnet-A"
  }
}
```

### Private Subnet B

```hcl
resource "aws_subnet" "private_b" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Private-Subnet-B"
  }
}
```

Created:

- Public-Subnet-A
- Public-Subnet-B
- Private-Subnet-A
- Private-Subnet-B

---

# Interview Notes

## Difference Between Public and Private Subnet

Public Subnet:

- Has route to Internet Gateway

Examples:

- Bastion Host
- NAT Gateway
- Load Balancer

Private Subnet:

- No direct Internet access

Examples:

- Application Servers
- Databases

---

# Step 5 - Internet Gateway

## igw.tf

```hcl
resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "DevOps-IGW"
  }
}
```

Created:

- DevOps-IGW

---

# Interview Notes

## What is Internet Gateway?

Internet Gateway allows communication between:

```text
VPC <--> Internet
```

Provides:

- Inbound connectivity
- Outbound connectivity

---

# Step 6 - NAT Gateway

## nat.tf

### Elastic IP

```hcl
resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = {
    Name = "NAT-EIP"
  }
}
```

### NAT Gateway

```hcl
resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat_eip.id

  subnet_id = aws_subnet.public_a.id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name = "DevOps-NAT"
  }
}
```

Created:

- NAT Gateway
- Elastic IP

---

# Interview Notes

## Why NAT Gateway?

Allows:

```text
Private EC2 --> Internet
```

Examples:

- yum update
- apt update
- Download packages

Without exposing the server publicly.

---

## Why NAT Gateway must be in Public Subnet?

Because NAT itself needs Internet access through IGW.

---

# Step 7 - Route Tables

## Public Route Table

```hcl
resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-RT"
  }
}
```

### Public Associations

```hcl
resource "aws_route_table_association" "public_a" {

  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b" {

  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}
```

---

## Private Route Table

```hcl
resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private-RT"
  }
}
```

### Private Associations

```hcl
resource "aws_route_table_association" "private_a" {

  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_b" {

  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_rt.id
}
```

Created:

- Public-RT
- Private-RT

---

# Interview Notes

## Difference Between IGW and NAT Gateway

| Internet Gateway | NAT Gateway |
|-----------------|-------------|
| Public Access | Private Access |
| Inbound + Outbound | Outbound Only |
| Attached to VPC | Inside Public Subnet |
| Free | Paid Service |

---

# Current Status

Completed:

- VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- Elastic IP
- NAT Gateway
- Public Route Table
- Private Route Table

Next:

- Security Groups
- Bastion Host
- Private EC2
- SSH Connectivity
- Terraform Remote State
- Modules

# Step 8 - Security Groups

## Bastion Security Group

```hcl
resource "aws_security_group" "bastion_sg" {

  name        = "bastion-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Bastion-SG"
  }
}
```

## Private Security Group

```hcl
resource "aws_security_group" "private_sg" {

  name   = "private-sg"
  vpc_id = aws_vpc.main.id

  ingress {

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    security_groups = [
      aws_security_group.bastion_sg.id
    ]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private-SG"
  }
}
```

### Created

- Bastion-SG
- Private-SG

### Security Design

```text
Internet
   |
Bastion Host
   |
Private EC2
```

Only Bastion can SSH to Private EC2.

### Interview Questions

Q: Why not allow SSH directly to private instances?

A:

- Security
- Compliance
- Reduced attack surface

Q: Why use Security Group references?

A:

- Dynamic
- Secure
- Easier maintenance