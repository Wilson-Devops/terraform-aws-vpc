# AWS & Terraform Interview Questions
## Project 2 - AWS 3-Tier Infrastructure using Terraform

---

# Terraform Fundamentals

## What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool used to provision and manage infrastructure using declarative configuration files.

Benefits:

- Automation
- Version Control
- Reusability
- Consistency
- Multi-Cloud Support

---

## What is Infrastructure as Code (IaC)?

Infrastructure is defined using code instead of manual configuration.

Examples:

- Terraform
- CloudFormation
- ARM Templates

---

## What is a Terraform Provider?

A provider is a plugin that allows Terraform to interact with cloud platforms.

Examples:

- AWS
- Azure
- GCP

Example:

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

---

## Difference Between Terraform and CloudFormation?

| Terraform | CloudFormation |
|------------|------------|
| Multi-cloud | AWS Only |
| HCL Language | JSON/YAML |
| Open Source | AWS Service |
| Large Community | AWS Ecosystem |

---

## What is Terraform State?

Terraform state tracks resources managed by Terraform.

Default file:

```text
terraform.tfstate
```

---

## Why is Terraform State Important?

Terraform compares:

```text
Current State
vs
Desired State
```

to determine infrastructure changes.

---

## What is Remote State?

State stored in a shared backend such as S3.

Benefits:

- Collaboration
- Backup
- Security
- Reliability

---

## Why Use DynamoDB with Terraform?

To provide state locking.

Prevents:

```text
Engineer A
Engineer B

terraform apply
```

from modifying state simultaneously.

---

## What is State Locking?

Locks Terraform state during:

```bash
terraform apply
```

to prevent corruption.

---

## Why Enable S3 Versioning?

Benefits:

- Rollback
- Recovery
- Protection from accidental deletion

---

## Difference Between Variables and Locals?

Variables:

```hcl
variable "environment" {}
```

Used for external input.

Locals:

```hcl
locals {
  project_name = "devops"
}
```

Used internally.

---

## What Does Terraform Plan Do?

Shows infrastructure changes before applying.

```bash
terraform plan
```

---

## Difference Between Plan and Apply?

Plan:

```bash
terraform plan
```

Preview only.

Apply:

```bash
terraform apply
```

Actually creates resources.

---

## What Does Terraform Destroy Do?

Removes all managed resources.

```bash
terraform destroy
```

---

# AWS Networking

## What is a VPC?

Virtual Private Cloud.

A logically isolated network inside AWS.

---

## Why Create a Custom VPC Instead of Default VPC?

Reasons:

- Better Security
- Custom Routing
- Compliance
- Network Segmentation

---

## Why Use CIDR 10.0.0.0/16?

Provides:

```text
65,536 IP Addresses
```

Suitable for future growth.

---

## Difference Between /16 and /24?

| CIDR | Total IPs |
|--------|---------|
| /16 | 65,536 |
| /24 | 256 |

---

## What is an Availability Zone?

An isolated AWS datacenter within a Region.

Example:

```text
ap-south-1a
ap-south-1b
```

---

## Why Deploy Across Multiple AZs?

To achieve:

```text
High Availability
```

and fault tolerance.

---

## What is a Public Subnet?

A subnet with a route to an Internet Gateway.

Examples:

- Bastion Host
- Load Balancer
- NAT Gateway

---

## What is a Private Subnet?

A subnet without direct Internet access.

Examples:

- Application Servers
- Databases

---

## Why Place Databases in Private Subnets?

Security.

Databases should not be directly accessible from the Internet.

---

## What is an Internet Gateway?

Allows communication between:

```text
VPC <--> Internet
```

Supports:

- Inbound Traffic
- Outbound Traffic

---

## What Happens Without an Internet Gateway?

Instances cannot access the Internet even if they have a Public IP.

---

## What is a NAT Gateway?

Allows private instances to access the Internet while remaining private.

Example:

```text
Private EC2
    |
NAT Gateway
    |
Internet
```

---

## Why Must NAT Gateway Be in a Public Subnet?

Because NAT itself needs Internet access through the Internet Gateway.

---

## Difference Between Internet Gateway and NAT Gateway?

| Internet Gateway | NAT Gateway |
|------------------|-------------|
| Public Access | Private Access |
| Inbound + Outbound | Outbound Only |
| Attached to VPC | Located in Public Subnet |
| Free | Charged |

---

## What is an Elastic IP?

A static public IPv4 address provided by AWS.

Use Cases:

- NAT Gateway
- Bastion Host
- Whitelisting

---

## What is a Route Table?

A set of routing rules that control network traffic.

---

## Why Associate a Route Table with a Subnet?

Without association, routing rules are not applied.

---

## What Routes Exist in Public Route Table?

```text
10.0.0.0/16 -> local
0.0.0.0/0 -> Internet Gateway
```

---

## What Routes Exist in Private Route Table?

```text
10.0.0.0/16 -> local
0.0.0.0/0 -> NAT Gateway
```

---

# Security

## What is a Security Group?

A virtual firewall attached to EC2 instances.

---

## Is a Security Group Stateful?

Yes.

Return traffic is automatically allowed.

---

## What is a NACL?

Network Access Control List.

A subnet-level firewall.

---

## Difference Between Security Group and NACL?

| Security Group | NACL |
|----------------|------|
| Stateful | Stateless |
| Instance Level | Subnet Level |
| Allow Only | Allow and Deny |
| Most Common | Less Common |

---

## Why Use Security Group References Instead of CIDR?

Example:

```hcl
security_groups = [
  aws_security_group.bastion_sg.id
]
```

Benefits:

- Dynamic
- Secure
- Easier Maintenance

---

## Why Restrict SSH Access to Bastion Host Only?

Improves security by reducing attack surface.

---

# EC2 & Bastion Host

## What is a Bastion Host?

A public EC2 instance used to securely access private instances.

Architecture:

```text
Laptop
   |
Internet
   |
Bastion Host
   |
Private EC2
```

---

## Why Place Bastion Host in a Public Subnet?

Engineers need Internet access to connect to it.

---

## Why Does Private EC2 Not Have a Public IP?

For security reasons.

Access only through Bastion Host.

---

## How Do You SSH into a Private EC2?

```text
Laptop
  |
Bastion Host
  |
Private EC2
```

---

## What Authentication Method Does AWS Use?

SSH Key Pair.

```text
Private Key (.pem)
Public Key (EC2)
```

---

## What Happens If You Lose the PEM File?

Options:

- SSM Session Manager
- Create New AMI
- Replace authorized_keys

---

## Why Did SSH Fail with "Permission Denied (publickey)"?

Possible Causes:

- Wrong Key Pair
- Missing Private Key
- Incorrect User
- Missing Authorized Key

---

## Why Did SSH Timeout?

Possible Causes:

- Wrong Security Group
- Wrong IP Address
- SSH Port Blocked
- Instance Not Running

---

## How Can a Private EC2 Access the Internet?

```text
Private EC2
      |
Private Route Table
      |
NAT Gateway
      |
Internet Gateway
      |
Internet
```

---

## Why Can Nobody SSH from the Internet Directly to Private EC2?

Because:

- No Public IP
- No Internet Route
- Security Group Restrictions

---

# Real-World Troubleshooting Questions

## Bastion Can SSH Yesterday But Not Today. What Do You Check?

1. EC2 Status
2. Security Groups
3. Route Tables
4. NACLs
5. SSH Service

```bash
sudo systemctl status sshd
```

6. Key Permissions

```bash
chmod 400 devops-key.pem
```

---

## Bastion Can Ping Private EC2 But SSH Fails. Why?

Possible Causes:

- Wrong Key Pair
- Authentication Failure
- SSH Service Down

---

## Terraform Apply Failed Halfway. What Happens?

Terraform updates state only for successfully created resources.

Subsequent applies reconcile the infrastructure.

---

# Project Summary Interview Answer

"I designed and deployed a production-style AWS VPC using Terraform with public and private subnets across multiple Availability Zones. I configured Internet Gateway, NAT Gateway, Route Tables, Security Groups, Bastion Host access, and Private EC2 instances. I implemented Terraform remote state using S3 and DynamoDB locking and validated secure SSH connectivity from Bastion to Private EC2."