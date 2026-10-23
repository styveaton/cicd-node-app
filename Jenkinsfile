pipeline {

    agent any


    environment {

        DOCKER_IMAGE_NAME = "aton85/test-node"

        DOCKER_IMAGE_TAG = "latest"

        ANSIBLE_SERVER = "steve@10.0.0.200"

    }


    stages {


        stage('Checkout') {

            steps {

                git branch: 'main',
                    url: 'https://github.com/styveaton/cicd-node-app.git'

            }

        }


        stage('Remove Existing Local Image') {

            steps {

                sh '''

                    docker rmi \
                    ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} \
                    || true

                '''

            }

        }


        stage('Build Docker Image') {

            steps {

                sh '''

                    docker build \
                    --rm \
                    -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} .

                '''

            }

        }


        stage('Push Docker Image to Docker Hub') {

            steps {

                withCredentials([

                    usernamePassword(

                        credentialsId: 'docker-hub-credentials',

                        usernameVariable: 'DOCKERHUB_USERNAME',

                        passwordVariable: 'DOCKERHUB_PASSWORD'

                    )

                ]) {

                    sh '''

                        echo "${DOCKERHUB_PASSWORD}" \
                        | docker login \
                        -u "${DOCKERHUB_USERNAME}" \
                        --password-stdin


                        docker push \
                        ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}

                    '''

                }

            }

        }


        stage('SonarQube Analysis') {

            steps {

                withSonarQubeEnv('sonar_qube') {

                    sh '''

                        sonar-scanner \
                        -Dsonar.projectKey=test-node \
                        -Dsonar.sources=. \
                        -Dsonar.exclusions=node_modules/**

                    '''

                }

            }

        }


        stage('Run Ansible Playbook') {
    steps {
        sh '''
            ssh -o StrictHostKeyChecking=no ${ANSIBLE_SERVER} \
            "cd /home/steve/ansible-lab && /home/steve/ansible-venv/bin/ansible-playbook -i inventory.ini deploy-node.yml"
        '''
    }
}


        stage('Deploy') {

            steps {

                echo 'Application deployed successfully'

            }

        }

    }


    post {


        success {

            echo 'PIPELINE SUCCESS'

            echo 'Application successfully deployed'

        }


        failure {

            echo 'PIPELINE FAILED'

            echo 'Check Jenkins Console Output'

        }

    }

}
