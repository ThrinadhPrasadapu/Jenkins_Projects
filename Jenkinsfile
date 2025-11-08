pipeline {
    agent {
        docker {
            image 'maven:3.9.9-eclipse-temurin-17'
            args '-v /root/.m2:/root/.m2'
        }
    }

    environment {
        DOCKERHUB_USER = 'your-dockerhub-username'
        IMAGE_NAME = 'javawebapp'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/ThrinadhPrasadapu/Jenkins_Projects.git'
            }
        }

        stage('Build WAR with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t $DOCKERHUB_USER/$IMAGE_NAME:latest .
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh '''
                    echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                    docker push $DOCKERHUB_USER/$IMAGE_NAME:latest
                '''
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker rm -f javawebapp-container || true
                    docker run -d -p 8080:8080 --name javawebapp-container $DOCKERHUB_USER/$IMAGE_NAME:latest
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Build + Docker Deployment completed successfully!'
        }
        failure {
            echo '❌ Build failed. Check logs!'
        }
    }
}

