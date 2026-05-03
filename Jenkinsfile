pipeline {
    agent {
        kubernetes {
            defaultContainer 'kaniko'
            yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:debug
      command: ["/busybox/cat"]
      tty: true
      volumeMounts:
        - name: aws-credentials
          mountPath: /root/.aws

    - name: git
      image: alpine/git:latest
      command: ["cat"]
      tty: true

  volumes:
    - name: aws-credentials
      secret:
        secretName: aws-credentials
"""
        }
    }

    environment {
        AWS_REGION  = "us-west-2"
        AWS_ACCOUNT = "660619595389"

        ECR_REPO    = "ivan-lesson-5-ecr"
        IMAGE_REPO  = "${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"

        IMAGE_TAG   = "${BUILD_NUMBER}"

        GIT_REPO    = "https://github.com/Pug10rd/devops_rep.git"
        GIT_BRANCH   = "lesson-8-9"
        VALUES_FILE = "charts/django-app/values.yaml"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: "${GIT_BRANCH}",
                    url: "${GIT_REPO}",
                    credentialsId: 'github-creds'
            }
        }

        stage('Build & Push Image (Kaniko)') {
            steps {
                container('kaniko') {
                    sh """
                    /kaniko/executor \
                      --context \"${WORKSPACE}\" \
                      --dockerfile \"${WORKSPACE}/Dockerfile\" \
                      --destination \"${IMAGE_REPO}:${IMAGE_TAG}\" \
                      --destination \"${IMAGE_REPO}:latest\" \
                      --cache=true
                    """
                }
            }
        }

        stage('Update Helm values.yaml') {
            steps {
                container('git') {
                    sh """
                    sed -i "s|repository: .*|repository: ${IMAGE_REPO}|" ${VALUES_FILE}
                    sed -i "s|tag: .*|tag: ${IMAGE_TAG}|" ${VALUES_FILE}

                    echo "Updated values.yaml:"
                    cat ${VALUES_FILE}
                    """
                }
            }
        }

        stage('Commit & Push changes') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'github-creds',
                    usernameVariable: 'GIT_USERNAME',
                    passwordVariable: 'GIT_TOKEN'
                )]) {
                    container('git') {
                        sh """
                        git config --global user.email "jenkins@local"
                        git config --global user.name "Jenkins"
                        git config --global --add safe.directory "${WORKSPACE}"

                        git add ${VALUES_FILE}
                        git commit -m "Update image tag to ${IMAGE_TAG}" || echo "No changes"

                        git push https://${GIT_USERNAME}:${GIT_TOKEN}@github.com/YOUR_USER/YOUR_REPO.git HEAD:${GIT_BRANCH}
                        """
                    }
                }
            }
        }
    }
}