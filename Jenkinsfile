
pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                sh '''
                    set -eu

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
                    set -eu
                    docker build \
                      -t devops-mini-project:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Load Image into Kind') {
            steps {
                sh '''
                    set -eu

                    kind load docker-image \
                      devops-mini-project:${BUILD_NUMBER} \
                      --name kind
                '''
            }
        }

        stage('Terraform Deploy') {
            steps {
                dir('terraform') {
                    sh '''
                        set -eu

                        terraform init \
                          -input=false \
                          -reconfigure \
                          -backend-config="path=/var/jenkins_home/terraform-state/terraform.tfstate"

                        terraform validate

                        terraform plan \
                          -input=false \
                          -var="kube_config_path=/var/jenkins_home/.kube/jenkins-config" \
                          -var="image_tag=${BUILD_NUMBER}" \
                          -out=tfplan

                        terraform apply \
                          -input=false \
                          -auto-approve \
                          tfplan
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    set -eu

                    kubectl rollout status \
                      deployment/devops-mini-app \
                      --timeout=120s

                    echo "Deployed image:"
                    kubectl get deployment devops-mini-app \
                      -o jsonpath='{.spec.template.spec.containers[0].image}{"\\n"}'

                    kubectl get pods
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD completed: tests, build, image load, Terraform deployment, and verification succeeded!'
        }

        failure {
            echo 'Pipeline failed. Check the Console Output to identify the failed stage.'
        }
    }
}

