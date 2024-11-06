pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "sanjaykshebbar/asi-insurance-app:latest"
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-1')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key-1')
        GITHUB_CREDENTIALS = credentials('github-credentials')
    }

    stages {
        stage('Pull Repo') {
            steps {
                // Pull the latest repo from GitHub
                git credentialsId: 'github-credentials', url: 'https://github.com/sanjaykshebbar/CapstoneProject.git', branch: 'main'
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image from the Dockerfile
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Login to Docker Hub
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'

                    // Push the Docker image to Docker Hub
                    sh 'docker push ${DOCKER_IMAGE}'
                }
            }
        }

        stage('Initialize Terraform') {
            steps {
                script {
                    // Initialize Terraform for infrastructure creation
                    sh 'terraform init'
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                script {
                    // Apply the Terraform plan to create the EC2 instance and security group
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Update Ansible Hosts') {
            steps {
                script {
                    // Get the EC2 instance public IP and update the hosts file
                    def output = sh(script: "terraform output -json", returnStdout: true).trim()
                    def ec2PublicIp = readJSON(text: output).ec2_public_ip.value
                    
                    // Update the hosts file with the EC2 public IP
                    sh """
                    echo '[webserver]' > hosts
                    echo '${ec2PublicIp}' >> hosts
                    """
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                script {
                    // Run the Ansible playbook to deploy the Docker container
                    sh 'ansible-playbook -i hosts deploy-playbook.yml'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
