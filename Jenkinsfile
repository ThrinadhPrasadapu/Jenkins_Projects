pipeline {
    agent any  // <-- run on Jenkins host instead of inside Maven Docker container

    environment {
        DOCKERHUB_USER = 'thrinadhprasadapu'
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
        withCredentials([usernamePassword(
            credentialsId: 'dockerhub',
            usernameVariable: 'DOCKERHUB_USER',
            passwordVariable: 'DOCKERHUB_PASS'
        )]) {
            sh '''
                echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                docker push $DOCKERHUB_USER/$IMAGE_NAME:latest
            '''
        }
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

