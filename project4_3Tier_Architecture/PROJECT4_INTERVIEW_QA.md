# AWS 3-Tier Architecture Interview Questions

## Q1. What is a 3-Tier Architecture?

Presentation Layer
Business Layer
Database Layer

Benefits:

- Scalability
- Security
- High Availability

---

## Q2. Why use Private Subnets?

To prevent direct internet access.

Application and database servers remain protected.

---

## Q3. Why use NAT Gateway?

Allows private instances to access the internet for updates.

Prevents inbound internet access.

---

## Q4. Why use a Bastion Host?

Provides secure SSH access to private servers.

---

## Q5. What is an Application Load Balancer?

Layer 7 Load Balancer.

Distributes HTTP/HTTPS traffic across backend instances.

---

## Q6. Difference Between ALB and NLB?

ALB:
- Layer 7
- HTTP/HTTPS

NLB:
- Layer 4
- TCP/UDP

---

## Q7. What is a Target Group?

Logical group of backend servers.

ALB forwards requests to targets.

---

## Q8. What are Health Checks?

Used by ALB to determine instance health.

Unhealthy instances stop receiving traffic.

---

## Q9. Why place RDS in Private Subnets?

Databases should not be exposed to the internet.

---

## Q10. How does App Server connect to RDS?

Security Group to Security Group communication.

App SG → DB SG

Port 3306

---

## Q11. Difference Between RDS and EC2 MySQL?

RDS:
- Managed
- Automated backups
- Patching

EC2:
- Manual management

---

## Q12. Why Terraform?

Infrastructure as Code.

Benefits:

- Version Control
- Repeatability
- Automation

---

## Q13. What Terraform Commands Did You Use?

terraform init

terraform fmt

terraform validate

terraform plan

terraform apply

terraform destroy

---

## Q14. What Challenges Did You Face?

1. VCPU quota exceeded

Resolution:
- Used existing instances
- Avoided recreation

2. RDS password validation

Resolution:
- Changed password format

3. MySQL authentication issue

Resolution:
- Verified actual password

---

## Q15. Explain End-to-End Request Flow

User
→ ALB
→ Web Tier
→ App Tier
→ RDS

Response returned back through same path.