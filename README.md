# ☁️ Java WebApp CI/CD Pipeline using Jenkins, Docker, and AWS EC2

## 🚀 Overview
This project demonstrates a **complete CI/CD pipeline** for a Java Web Application using **Jenkins**, **Maven**, and **Docker** — deployed on an **AWS EC2** instance.

Whenever code is pushed to GitHub, Jenkins automatically:
1. Builds the project using Maven.
2. Packages it as a WAR file.
3. Builds a Docker image containing Tomcat + the app.
4. Pushes the image to Docker Hub.
5. Deploys it as a running container on EC2.

---

## 🧰 Tech Stack
- **Jenkins** – CI/CD Automation
- **Maven** – Build & Dependency Management
- **Docker** – Containerization
- **Tomcat** – Application Server
- **AWS EC2 (Ubuntu)** – Deployment Host
- **GitHub** – Source Code Management

---

## 🧱 Project Structure

---

## ⚙️ Jenkins Pipeline Stages
| Stage | Description |
|-------|--------------|
| **Checkout Code** | Clones the GitHub repository |
| **Build WAR with Maven** | Runs `mvn clean package` to create the WAR |
| **Build Docker Image** | Builds a Tomcat-based Docker image |
| **Push to Docker Hub** | Pushes image to Docker Hub registry |
| **Deploy Container** | Runs the Docker container on EC2 |

---

## 🐳 Dockerfile
```dockerfile
FROM tomcat:9.0
RUN rm -rf /usr/local/tomcat/webapps/*
COPY target/*.war /usr/local/tomcat/webapps/mywebapp.war
EXPOSE 8080
CMD ["catalina.sh", "run"]


🔧 Jenkinsfile
pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'thrinadhprasadapu'
        DOCKERHUB_PASS = credentials('dockerhub-pass')
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
                sh 'docker build -t $DOCKERHUB_USER/$IMAGE_NAME:latest .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-pass', variable: 'DOCKERHUB_PASS')]) {
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
                    docker ps -q --filter "name=javawebapp-container" | grep -q . && docker rm -f javawebapp-container || true
                    docker run -d -p 9090:8080 --name javawebapp-container $DOCKERHUB_USER/$IMAGE_NAME:latest
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Build and Deployment Successful!"
        }
        failure {
            echo "❌ Build failed. Check logs!"
        }
    }
}


🌍 Deployment URL

After successful Jenkins build, access the app at:

http://<EC2-PUBLIC-IP>:9090/mywebapp/



💡 How It Works

Jenkins pulls the latest code from GitHub.

Maven compiles the project and packages it as mywebapp.war.

Docker builds a new Tomcat image containing the WAR file.

Jenkins logs into Docker Hub and pushes the image.

Jenkins deploys a fresh container using the pushed image on port 9090.


🧠 Key Learning Outcomes

Automated builds with Jenkins Pipelines

Continuous integration using Maven + Jenkins

Continuous deployment using Docker + EC2

Credential management and environment variables in Jenkins

Full end-to-end CI/CD flow for Java-based applications


📸 Output

✅ Build completed successfully
✅ Docker image pushed to Docker Hub
✅ Deployed container accessible on port 9090
