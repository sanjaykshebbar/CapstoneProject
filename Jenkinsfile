pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS = credentials('docker-hub-credentials')
        GIT_CREDENTIALS = credentials('github-credentials')
        AWS_CREDENTIALS = credentials('aws-secret-key-1')
    }
    stages {
        stage('Clone Repository') {
            steps {
                git credentialsId: "${GIT_CREDENTIALS}", url: 'https://github.com/sanjaykshebbar/CapstoneProject.git', branch: 'main'
            }
        }
        stage('Install NodeJS') {
            steps {
                sh 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash'
                sh 'nvm install 22'
            }
        }
        stage('Terraform Apply') {
            steps {
                dir('terraform-directory') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('Update Ansible Hosts') {
            steps {
                sh 'chmod +x update_hosts.sh'  // Ensure the script is executable
                sh './update_hosts.sh'  // Run the script to update hosts.ini
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("sanjaykshebbar/asi-insurance-app:${env.BUILD_ID}")
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS}") {
                        docker.image("sanjaykshebbar/asi-insurance-app:${env.BUILD_ID}").push('latest')
                    }
                }
            }
        }
        stage('Deploy with Ansible') {
            steps {
                ansiblePlaybook credentialsId: 'ansible-ssh-key', inventory: 'hosts.ini', playbook: 'deploy-playbook.yml'
            }
        }
    }
}
