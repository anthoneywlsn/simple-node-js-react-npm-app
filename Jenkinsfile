pipeline {
    agent {
        docker {
            image 'node:lts-bullseye-slim'
            args '-p 3000:3000'
        }
    }

    environment {
      AWS_ACCOUNT_ID="195879934828"
      AWS_DEFAULT_REGION="us-east-2"
      CLUSTER_NAME="capstone-Aetna-cluster"
      SERVICE_NAME="simplilearn-capstone-nodejs-container-service"
      TASK_DEFINITION_NAME="aetna-capstone-definition"
      DESIRED_COUNT="1"
      IMAGE_REPO_NAME="simplilearn-capstone-pvt-repo"
      IMAGE_TAG="latest"
      docker_repo_uri ="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
      registryCredential="Anthoney_Wilson"
      exec_role_arn = "arn:aws:iam::195879934828:role/Jenkins"  
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
        stage('Pushing to ECR') {
          steps{
            script {
              docker.withRegistry("https://" + docker_repo_uri, "ecr:${AWS_DEFAULT_REGION}:" + registryCredential) {
              dockerImage.push('latest')
              }
            }
          }
        }    
        stage('Deliver') {
            steps {
                sh './jenkins/scripts/deliver.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh './jenkins/scripts/kill.sh'
            }
        }
    }
}
