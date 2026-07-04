# Day 1 – Terraform & AWS Fundamentals

## 1. What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool created by HashiCorp that allows you to create, modify, and manage infrastructure using code instead of manually configuring resources through a web console.

### Benefits
- Automates infrastructure provisioning
- Version controls infrastructure changes
- Reduces manual errors
- Supports multiple cloud providers (AWS, Azure, GCP, etc.)

### Example

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

---

## 2. What is a Provider?

A provider is a plugin that allows Terraform to communicate with a specific platform or service.

Examples:
- AWS Provider
- Azure Provider
- Google Cloud Provider
- GitHub Provider

### Example

```hcl
provider "aws" {
  region = "us-east-1"
}
```

Terraform uses the AWS provider to create and manage AWS resources.

---

## 3. Difference Between Terraform Plan and Apply

### terraform plan

Checks what changes Terraform will make before actually creating or modifying resources.

```bash
terraform plan
```

Purpose:
- Preview changes
- Detect mistakes
- Safe to run multiple times

### terraform apply

Executes the changes and creates/modifies infrastructure.

```bash
terraform apply
```

Purpose:
- Creates resources
- Updates resources
- Deletes resources if required

### Summary

| Command | Purpose |
|----------|----------|
| terraform plan | Shows what will happen |
| terraform apply | Makes the changes happen |

---

## 4. What is a Terraform State File?

Terraform stores information about created resources in a state file.

File:

```text
terraform.tfstate
```

The state file helps Terraform:
- Track infrastructure
- Compare desired vs current state
- Determine required changes

### Example

Terraform knows:
- VPC ID
- EC2 Instance ID
- Security Group ID

Without the state file, Terraform would not know what resources it previously created.

---

# AWS Fundamentals

## 5. What is a VPC?

VPC (Virtual Private Cloud) is a logically isolated network inside AWS where you launch and manage resources.

Think of a VPC as your private data center in AWS.

### Example

```text
VPC CIDR: 10.0.0.0/16
```

Resources inside a VPC:
- EC2 Instances
- Load Balancers
- Databases
- Lambda Functions

### Benefits
- Isolation
- Security
- Network control

---

## 6. Difference Between Public and Private Subnet

A subnet is a smaller network inside a VPC.

### Public Subnet

A subnet that has a route to the Internet Gateway.

Typical resources:
- Web Servers
- Bastion Hosts
- Load Balancers

Example:

```text
10.0.1.0/24
```

### Private Subnet

A subnet without direct internet access.

Typical resources:
- Databases
- Application Servers
- Internal Services

Example:

```text
10.0.2.0/24
```

### Comparison

| Public Subnet | Private Subnet |
|--------------|---------------|
| Internet Access | No Direct Internet Access |
| Web Servers | Databases |
| Bastion Hosts | Internal Applications |
| Public IP Allowed | Usually No Public IP |

---

## 7. What is CIDR?

CIDR (Classless Inter-Domain Routing) defines the IP address range available in a network.

### Example

```text
10.0.0.0/16
```

Meaning:
- Network starts at 10.0.0.0
- Approximately 65,536 IP addresses available

### Common Examples

```text
10.0.0.0/16
10.0.1.0/24
192.168.1.0/24
```

### Quick Reference

| CIDR | Approx IPs |
|-------|------------|
| /16 | 65,536 |
| /24 | 256 |
| /32 | 1 |

---

## 8. What is a Security Group?

A Security Group acts as a virtual firewall for AWS resources.

It controls:
- Incoming traffic (Ingress)
- Outgoing traffic (Egress)

### Example Rules

| Port | Protocol | Purpose |
|--------|----------|----------|
| 22 | TCP | SSH |
| 80 | TCP | HTTP |
| 443 | TCP | HTTPS |

### Example

```text
Allow:
SSH 22 from your IP
HTTP 80 from internet
HTTPS 443 from internet
```

### Important Characteristics

- Stateful firewall
- Allow rules only
- Applied at instance level
- Can be attached to multiple EC2 instances

---

# Interview Quick Answers

### What is Terraform?
Terraform is an Infrastructure as Code tool used to provision and manage infrastructure through code.

### What is a Provider?
A provider allows Terraform to interact with a platform such as AWS, Azure, or GCP.

### Difference Between Plan and Apply?
Plan shows proposed changes; Apply executes those changes.

### What is a State File?
A file that stores information about infrastructure managed by Terraform.

### What is a VPC?
A private virtual network in AWS where resources are deployed.

### Difference Between Public and Private Subnet?
Public subnets have internet access through an Internet Gateway; private subnets do not.

### What is CIDR?
CIDR defines the IP address range available within a network.

### What is a Security Group?
A stateful virtual firewall that controls inbound and outbound traffic for AWS resources.
