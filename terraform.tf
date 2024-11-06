# AWS provider configuration (including hardcoded credentials)
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAXZ5NGF4COXWV4QML"  # Replace with your own key
  secret_key = "T7qJZ50EKWwOtEj93skZORcspAkwFpIm8s/AF5sg"  # Replace with your own secret
}

# EC2 instance resource configuration
resource "aws_instance" "docker_host" {
  ami           = "ami-0866a3c8686eaeeba" # Example AMI (Ubuntu)
  instance_type = "t2.micro"
  key_name      = "DevOps-Capstone-Project"
  security_groups = ["web_sg"]

  tags = {
    Name = "web-server"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ec2_public_ip" {
  value = aws_instance.web_server.public_ip
}
