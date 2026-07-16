#!/bin/bash

dnf update -y

dnf install git -y

dnf install java-21-amazon-corretto -y

wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import \
https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

dnf install jenkins -y

systemctl enable jenkins
systemctl start jenkins

dnf install docker -y

systemctl enable docker
systemctl start docker

usermod -aG docker jenkins

systemctl restart jenkins