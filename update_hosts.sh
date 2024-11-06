#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR=$(dirname "$0")

# Navigate to the directory where Terraform is configured
cd "$SCRIPT_DIR"

# Run Terraform output to get the public IP of the EC2 instance
PUBLIC_IP=$(terraform output -raw ec2_public_ip)

# Check if the public IP was fetched
if [ -z "$PUBLIC_IP" ]; then
  echo "Error: Unable to fetch the EC2 public IP"
  exit 1
fi

# Update the Ansible hosts.ini file with the new EC2 public IP
echo "[aws-host]" > "$SCRIPT_DIR/hosts.ini"
echo "${PUBLIC_IP} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/DevOps-Capstone-Project.pem" >> "$SCRIPT_DIR/hosts.ini"

echo "hosts.ini updated with EC2 public IP: $PUBLIC_IP"
