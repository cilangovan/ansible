pipeline {
    agent { label 'ubuntu-agent' } // Replace with your actual slave label

    parameters {
        string(name: 'INT_DEV_FOLDER', defaultValue: 'int-dev', description: 'Inventory folder for Ansible')
    }

    environment {
        REPO_URL = 'https://github.com/your-org/your-repo.git' // Replace with your repo
        BUILD_DIR = "build-${env.BUILD_NUMBER}"
        TAR_FILE = "package-${env.BUILD_NUMBER}.tar.gz"
    }

    stages {
        stage('Clone Repo') {
            steps {
                sh "git clone ${REPO_URL} ${BUILD_DIR}"
            }
        }

        stage('Package Code') {
            steps {
                sh "tar -czf ${TAR_FILE} ${BUILD_DIR}"
            }
        }

        stage('Deploy with Ansible') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'ansible-creds', usernameVariable: 'ANSIBLE_USER', passwordVariable: 'ANSIBLE_PASS')]) {
                    sh """
                        ansible-playbook -i ${params.INT_DEV_FOLDER} \\
                        --extra-vars="ansible_become_pass=${ANSIBLE_PASS}" \\
                        new-user.yml -vvv --become
                    """
                }
            }
        }
    }

    post {
        always {
            sh "rm -rf ${BUILD_DIR} ${TAR_FILE}"
        }
    }
}
