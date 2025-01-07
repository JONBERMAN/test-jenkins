pipeline {
    agent any
    environment {
        BUILD_NUMBER = "v8"  // 빌드 번호
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

        stage('Push Image to HUB') {
            steps {
                script {
                    echo "Push to Docker Hub"
                    // Docker 이미지를 Docker Hub에 푸시
                    sh "docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                    echo "Push Success"
                }
            }
        }

        stage('K8S Manifest Update') {
            steps {
                // GitHub에서 Kubernetes manifest 레포지토리 체크아웃
                git credentialsId: 'github_access_token', 
                    url: 'https://github.com/JONBERMAN/k8s-manifest.git',
                    branch: 'main'
                sh 'git config user.email "jenkins@yourdomain.com"'
                sh 'git config user.name "Jenkins CI"'
                // deployment.yaml 파일의 버전 정보를 현재 빌드 번호로 업데이트
                sh """
                    sed -i 's|image: taehoon981/grey:.*|image: taehoon981/grey:v${BUILD_NUMBER}|g' deployment.yaml
                """
                // Git에 변경 사항 추가
                sh "git add deployment.yaml"
                sh "git commit -m '[UPDATE] my-app ${BUILD_NUMBER} image versioning'"

                // SSH로 GitHub에 푸시
                sshagent(credentials: ['k8s-manifest-credential']) {
                    sh "git remote set-url origin git@github.com:JONBERMAN/k8s-manifest.git"
                    sh "git push -u origin main"
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs.'
        }
    }
}

