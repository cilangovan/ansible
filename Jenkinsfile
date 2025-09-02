pipeline {
    agent {
        label 'ubuntu-agent-docker'
    }

    options {
        timeout(time: 30, unit: 'MINUTES')
    }

    parameters {
        string(name: 'INVENTORY_PATH', defaultValue: 'int-dev', description: 'Path to inventory folder')
        string(name: 'PLAYBOOK_FILE', defaultValue: 'new-user.yml', description: 'Ansible playbook file to run')
        string(name: 'BECOME_PASS', defaultValue: 'lubuntu', description: 'Ansible become password')
        string(name: 'BUILD_VERSION', defaultValue: '1.0.0', description: 'Build version number')
        booleanParam(name: 'VERBOSE', defaultValue: true, description: 'Enable verbose output')
    }

    environment {
        BUILD_ID = "${BUILD_NUMBER}"
        PACKAGE_NAME = "app-build-${BUILD_NUMBER}.tar.gz"
    }

    stages {
        stage('Build & Package') {
            steps {
                echo "Building version ${params.BUILD_VERSION}"
                sh '''
                    mkdir -p build/package
                    echo "Build version: ${BUILD_VERSION}" > build/package/version.txt
                    echo "Build ID: ${BUILD_ID}" >> build/package/version.txt
                    date > build/package/build-time.txt
                    tar -czf ${PACKAGE_NAME} build/package/*
                    ls -la *.tar.gz
                '''
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: '*.tar.gz', fingerprint: true
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying using Ansible"
                script {
                    // Check if inventory exists
                    def inventoryExists = fileExists("${params.INVENTORY_PATH}")
                    if (!inventoryExists) {
                        error "Inventory path ${params.INVENTORY_PATH} does not exist!"
                    }

                    // Check if playbook exists
                    def playbookExists = fileExists("${params.PLAYBOOK_FILE}")
                    if (!playbookExists) {
                        error "Playbook file ${params.PLAYBOOK_FILE} does not exist!"
                    }

                    // Method 1: Use expect if available (non-interactive)
                    def expectAvailable = sh(script: 'command -v expect', returnStatus: true) == 0

                    if (expectAvailable) {
                        echo "Using expect for automated password input"
                        sh """
                            /usr/bin/expect <<EOF
                            set timeout 300
                            spawn ansible-playbook \\
                                -i ${params.INVENTORY_PATH} \\
                                --extra-vars="ansible_become_pass=${params.BECOME_PASS} build_version=${params.BUILD_VERSION} build_id=${BUILD_NUMBER} package_name=${PACKAGE_NAME}" \\
                                ${params.VERBOSE ? '-vvv' : ''} \\
                                --become \\
                                --ask-become-pass \\
                                ${params.PLAYBOOK_FILE}
                            expect "BECOME password:"
                            send "${params.BECOME_PASS}\\\\r"
                            expect eof
                            catch wait result
                            exit [lindex \\\$result 3]
                            EOF
                        """
                    } else {
                        // Method 2: Use SSH keys or alternative authentication
                        echo "Using non-interactive method with become password in extra vars"
                        sh """
                            ansible-playbook \\
                                -i ${params.INVENTORY_PATH} \\
                                --extra-vars="ansible_become_pass=${params.BECOME_PASS} build_version=${params.BUILD_VERSION} build_id=${BUILD_NUMBER} package_name=${PACKAGE_NAME}" \\
                                ${params.VERBOSE ? '-vvv' : ''} \\
                                --become \\
                                ${params.PLAYBOOK_FILE}
                        """
                    }
                }
            }
        }

        stage('Verify') {
            steps {
                echo "Verifying deployment"
                sh """
                    ansible -i ${params.INVENTORY_PATH} -m ping all || true
                    echo "Deployment completed!"
                """
            }
        }
    }

    post {
        always {
            deleteDir()
        }
        success {
            echo "CI/CD Pipeline completed successfully!"
        }
        failure {
            echo "CI/CD Pipeline failed!"
        }
    }
}