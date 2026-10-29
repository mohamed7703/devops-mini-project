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
    }

    post {
        success {
            echo 'CI Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the stage logs.'
        }
    }
}
