pipeline {
    agent {
        docker {
            image 'node:lts-bullseye-slim'
            reuseNode true
            args '-p 3000:3000'
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
        stage('Deploy') {
          steps {
            script {
              docker.withRegistry(
                'https://195879934828.dkr.ecr.us-east-2.amazonaws.com' ,
                'ecr:us-east-2:AWS') {
                def myImage = docker.build( 'simplilearn-capstone-pvt-repo')
                myImage.push('latest')
                  reuseNode true
              }  
            }  
          }
        }
        // Uploading Docker images into AWS ECR
        stage('Pushing to ECR') {
          steps{
            script {
              docker.withRegistry("https://" + REPOSITORY_URI, "ecr:${AWS_DEFAULT_REGION}:" + registryCredential) {
              dockerImage.push()
              }
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
