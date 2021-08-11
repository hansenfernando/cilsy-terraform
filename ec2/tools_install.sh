#!/bin/bash

#Install aws-cli
echo "###Install aws-cli###"
sudo apt-get update
sudo snap install aws-cli --classic

#aws-cli configuration
echo "###aws-cli configure###"
aws configure set default.region ap-southeast-1
aws configure set aws_access_key_id '$AWS_ACCESS_KEY_ID'
aws configure set aws_secret_access_key '$AWS_SECRET_ACCESS_KEY'

#Install docker
echo "###Install docker###"
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
#Configure docker
sudo usermod -aG docker $USER

#Install jenkins
echo "###Install jenkins###"
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install openjdk-8-jdk -y
sudo apt-get install jenkins -y
sudo usermod -aG docker jenkins

#Install kubectl
echo "###Install kubectl###"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

#Install kops
echo "###Install kops###"
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops

#Key-generate configuration-for cluster
ssh-keygen -t rsa -f /home/ubuntu/.ssh/id_rsa -q -P ''