# Project 4: AWS 3-Tier Architecture using Terraform

## Architecture

Internet
│
Application Load Balancer
│
Web Tier (Apache)
│
Application Tier (Python)
│
RDS MySQL

---

## Technologies Used

- AWS VPC
- EC2
- ALB
- RDS MySQL
- Terraform
- Security Groups
- NAT Gateway
- Internet Gateway
- Bastion Host

---

# Phase 1: Network Setup

Created:

- Custom VPC
- Public Subnet A
- Public Subnet B
- Private App Subnet A
- Private App Subnet B
- Private DB Subnet A
- Private DB Subnet B

CIDR:

VPC: 10.0.0.0/16

Public-A: 10.0.1.0/24
Public-B: 10.0.2.0/24

App-A: 10.0.3.0/24
App-B: 10.0.4.0/24

DB-A: 10.0.5.0/24
DB-B: 10.0.6.0/24

---

# Phase 2: Internet Connectivity

Created:

- Internet Gateway
- Elastic IP
- NAT Gateway

Configured:

- Public Route Table
- Private Route Table

---

# Phase 3: Security Groups

Created:

## Bastion SG

Port 22
Source: My IP

## ALB SG

Port 80
Source: 0.0.0.0/0

## Web SG

Port 80
Source: ALB SG

Port 22
Source: Bastion SG

## App SG

Port 8080
Source: Web SG

Port 22
Source: Bastion SG

## DB SG

Port 3306
Source: App SG

---

# Phase 4: EC2 Deployment

Instances:

- Bastion Host
- Web Server 1
- Web Server 2
- App Server 1
- App Server 2

Instance Type:

t3.micro

---

# Phase 5: Web Tier Setup

Installed Apache:

sudo dnf install httpd -y

Started service:

sudo systemctl enable httpd
sudo systemctl start httpd

Created test page:

<h1>Web Server 2</h1>

Verified:

curl http://localhost

---

# Phase 6: Application Tier Setup

Installed Python

Created:

app.py

Application:

Application Tier Running

Verified:

curl http://localhost:8080

---

# Phase 7: Application Load Balancer

Created:

- Target Group
- Listener
- ALB

Attached:

- Web Server 2

Verified:

http://ALB-DNS

Output:

Web Server 2

---

# Phase 8: RDS MySQL

Created:

- DB Subnet Group
- MySQL RDS

Engine:

MySQL 8.0

Instance Class:

db.t3.micro

Database:

devopsdb

Verified:

mysql -h <endpoint> -u admin -p

Successfully connected.

---

# Final Architecture

Internet
│
ALB
│
Web Tier
│
App Tier
│
RDS MySQL

Project Status: COMPLETED