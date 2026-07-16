# Project 3: CI/CD Pipeline with Terraform + Jenkins + Docker + AWS

## Objective
Build a complete CI/CD pipeline where Terraform provisions infrastructure, Jenkins builds and deploys a Dockerized application from GitHub onto AWS EC2.

## Architecture

```text
GitHub
   |
   v
Jenkins Pipeline
   |
   v
Docker Build
   |
   v
Docker Container
   |
   v
AWS EC2
```

## Prerequisites

- AWS Account
- Terraform
- GitHub Account
- AWS Key Pair
- IAM permissions for EC2, VPC, Security Groups

---

## Phase 1: Terraform Infrastructure

### Create Files

```text
terraform-jenkins-project/
│
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── terraform.tfvars
└── scripts/install.sh
```

### Resources Created

- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group
- EC2 Instance
- User Data Script

### Deploy

```bash
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

---

## Phase 2: Automatic Jenkins Installation

User data installs:

- Java 21
- Git
- Jenkins
- Docker

Verify:

```bash
sudo systemctl status jenkins
sudo systemctl status docker
```

Get Jenkins password:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

## Phase 3: GitHub Repository

Repository:

```text
devops-demo-app
```

Files:

### index.html

```html
<h1>CI/CD Pipeline Successful!</h1>
```

### Dockerfile

```dockerfile
FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
```

### Jenkinsfile

```groovy
pipeline {
    agent any

    stages {

        stage('Clone') {
            steps {
                git 'https://github.com/Wilson-Devops/devops-demo-app.git'
            }
        }

        stage('Build') {
            steps {
                sh 'docker build -t devops-demo .'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                docker rm -f devops-demo || true
                docker run -d --name devops-demo -p 8081:80 devops-demo
                '''
            }
        }
    }
}
```

---

## Phase 4: Jenkins Pipeline

Create Job:

```text
New Item
→ Pipeline
```

Configuration:

```text
Definition: Pipeline script from SCM
SCM: Git
Repository URL:
https://github.com/Wilson-Devops/devops-demo-app.git

Branch:
*/master

Script Path:
Jenkinsfile
```

---

## Phase 5: Fix Docker Permission

```bash
sudo usermod -aG docker jenkins
sudo systemctl restart docker
sudo systemctl restart jenkins
```

Verify:

```bash
id jenkins
```

---

## Phase 6: Build and Deploy

Run:

```text
Build Now
```

Verify:

```bash
docker ps
```

Expected:

```text
devops-demo
0.0.0.0:8081->80
```

Open:

```text
http://<EC2-PUBLIC-IP>:8081
```

Expected:

```text
CI/CD Pipeline Successful!
```

---

## Achievements

- Infrastructure as Code using Terraform
- Automated Jenkins Installation
- Pipeline as Code using Jenkinsfile
- Dockerized Application Deployment
- End-to-End CI/CD Automation

## Resume Point

Implemented an end-to-end CI/CD pipeline using Terraform, AWS EC2, Jenkins, Docker, and GitHub. Automated infrastructure provisioning, application build, containerization, and deployment using Jenkins Pipeline as Code.
