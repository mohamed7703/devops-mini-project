
pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                sh '''
                    docker build \
                      -f Dockerfile.ci \
                      -t devops-mini-project-test:${BUILD_NUMBER} .

                    docker run --rm \
                      devops-mini-project-test:${BUILD_NUMBER}
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                      -t devops-mini-project:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform init \
                          -input=false \
                          -reconfigure \
                          -backend-config="path=/var/jenkins_home/terraform-state/terraform.tfstate"

                        terraform validate

                        terraform plan \
                          -input=false \
                          -var="kube_config_path=/var/jenkins_home/.kube/jenkins-config"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'CI pipeline and Terraform plan completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the stage logs.'
        }
    }
}

