
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh '''
                    set -eu

                    mkdir -p /tmp/devops-mini-project-test
                    cp -r . /tmp/devops-mini-project-test/

                    docker run --rm \
                      -v /tmp/devops-mini-project-test:/app \
                      -w /app \
                      python:3.12-slim \
                      sh -c 'pip install -r requirements-dev.txt && python -m pytest -v'
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t devops-mini-project:${BUILD_NUMBER} .
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
    
