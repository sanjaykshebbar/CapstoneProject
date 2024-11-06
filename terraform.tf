# AWS provider configuration (including hardcoded credentials)
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAXZ5NGF4COXWV4QML"  # Replace with your own key
  secret_key = "T7qJZ50EKWwOtEj93skZORcspAkwFpIm8s/AF5sg"  # Replace with your own secret
}

# EC2 instance resource configuration
resource "aws_instance" "docker_host" {
  ami           = "ami-0c55b159cbfafe1f0" # Example AMI (Ubuntu)
  instance_type = "t2.micro"
  key_name      = "DevOps-Capstone-Project"

  tags = {
    Name = "DockerHost"
  }

  # Security group to allow SSH and HTTP
  security_groups = ["docker-sg"]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install docker.io -y
              sudo systemctl start docker
              sudo systemctl enable docker
              EOF
}

# Output the EC2 instance's public IP
output "ec2_public_ip" {
  value = aws_instance.docker_host.public_ip
}