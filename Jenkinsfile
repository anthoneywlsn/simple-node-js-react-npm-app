pipeline {
    agent {
        docker {
            image 'node:lts-bullseye-slim' 
            args '-p 3000:3000 ${workspace}' 
        }
    }
    
    tools {nodejs "node"}

    environment {
      AWS_ACCOUNT_ID="195879934828"
      AWS_DEFAULT_REGION="us-east-2"
      CLUSTER_NAME="capstone-Aetna-cluster"
      SERVICE_NAME="simplilearn-capstone-nodejs-container-service"
      TASK_DEFINITION_NAME="aetna-capstone-definition"
      DESIRED_COUNT="1"
      IMAGE_REPO_NAME="simplilearn-capstone-pvt-repo"
      IMAGE_TAG="latest"
      REPOSITORY_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
      stages {
        stage('Build') { 
            steps {
                sh 'npm install' 
            }
        }
        stage('Test') {
            steps {
                sh './jenkins/scripts/test.sh'
            }
        }
        // Uploading Docker images into AWS ECR
        stage('Login to ECR') {
          steps{
            script {
                sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
            }
          }
        }
        // Uploading Docker images into AWS ECR
        stage('Pushing to ECR') {
          steps{  
            script {
                sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
            }
          }
        }  
        stage('Deliver') {
            steps {
                sh './jenkins/scripts/deliver.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
            }
        }
    }
}
