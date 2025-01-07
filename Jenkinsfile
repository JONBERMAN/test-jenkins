pipeline {
    agent any
    environment {
        BUILD_NUMBER = "v1"  // 빌드 번호
        IMAGE_NAME = "taehoon981/grey"  // Docker 이미지 이름
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-id') // jenkins에 등록한 dockerhub 자격증명 이름
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github_access_token',  // 미리 설정한 GitHub 자격증명 ID
                    url: 'https://github.com/JONBERMAN/test-jenkins.git'  // 내 Git URL
            }
        }
        
        stage('Login to Docker') {
            steps {
                script {
                    // Docker Hub 로그인
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Start to Build the Image"
                    // Docker 이미지 빌드
                    sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
                    echo "Build Success"
                }
            }
        }

        stage('Push Image to ACR') {
            steps {
                script {
                    echo "Push to Docker Hub"
                    // Docker 이미지를 Docker Hub에 푸시
                    sh "docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                    echo "Push Success"
                }
            }
        }
    }
}

