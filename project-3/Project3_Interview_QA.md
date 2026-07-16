# Project 3 Interview Questions and Answers

## Terraform

### Q1. What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool used to provision and manage infrastructure using declarative configuration files.

### Q2. What resources did you provision?

- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group
- EC2 Instance

### Q3. What is Terraform State?

Terraform State tracks the current infrastructure and maps resources to the configuration.

### Q4. Difference between terraform plan and apply?

- plan: Shows changes
- apply: Executes changes

---

## AWS

### Q5. Why use a Security Group?

A Security Group acts as a virtual firewall controlling inbound and outbound traffic.

### Q6. What ports were opened?

- 22 SSH
- 8080 Jenkins
- 8081 Application

### Q7. What is user_data?

A startup script executed when an EC2 instance launches.

---

## Jenkins

### Q8. What is Jenkins?

An automation server used to implement CI/CD pipelines.

### Q9. What is a Jenkinsfile?

Pipeline as Code written in Groovy.

### Q10. Difference between Freestyle and Pipeline Jobs?

Freestyle:
- GUI-based
- Less scalable

Pipeline:
- Code-based
- Version controlled
- Reusable

### Q11. What stages did your pipeline contain?

- Clone
- Build
- Deploy

---

## Git & GitHub

### Q12. How did Jenkins connect to GitHub?

Using Git plugin and repository URL.

### Q13. What is a Webhook?

A mechanism that automatically triggers Jenkins when code is pushed to GitHub.

---

## Docker

### Q14. Why use Docker?

- Consistent environments
- Faster deployments
- Portability

### Q15. What is a Docker Image?

A packaged application with all dependencies.

### Q16. What is a Docker Container?

A running instance of a Docker image.

### Q17. How did you deploy the application?

```bash
docker build -t devops-demo .
docker run -d --name devops-demo -p 8081:80 devops-demo
```

---

## CI/CD

### Q18. What is CI?

Continuous Integration automatically builds and validates code changes.

### Q19. What is CD?

Continuous Delivery/Deployment automates application release.

### Q20. Explain your end-to-end project flow.

```text
Developer Push
      |
      v
GitHub
      |
      v
Jenkins
      |
      v
Clone Repository
      |
      v
Docker Build
      |
      v
Deploy Container
      |
      v
Application Available
```

### Q21. What issue did you face?

Docker permission denied for Jenkins user.

### Q22. How did you fix it?

```bash
sudo usermod -aG docker jenkins
sudo systemctl restart docker
sudo systemctl restart jenkins
```

### Q23. What improvements can be added?

- GitHub Webhooks
- Docker Hub Push
- Rollback Strategy
- Multi-environment Deployment
- Kubernetes Deployment

---

## Scenario-Based Questions

### Q24. Jenkins pipeline failed during deployment. What will you do?

- Check Console Output
- Verify Docker service
- Verify Jenkins permissions
- Validate application logs

### Q25. How would you implement rollback?

Deploy previous stable Docker image version and restart container.

### Q26. Why use Pipeline as Code?

- Version Control
- Reusability
- Auditability
- Automation

### Q27. Explain this project in an interview.

I used Terraform to provision AWS infrastructure, automatically installed Jenkins and Docker using user_data, connected Jenkins to GitHub through a Jenkinsfile, built a Docker image, and deployed the application on EC2. The entire workflow automated build and deployment activities through CI/CD.
