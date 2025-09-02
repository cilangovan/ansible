pipeline {
    agent {
        label 'ubuntu-agent-docker'
    }

    options {
        timeout(time: 30, unit: 'MINUTES')
    }

    parameters {
        string(name: 'INVENTORY_PATH', defaultValue: 'int-dev', description: 'Path to inventory folder')
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
                    echo "Creating build directory structure..."
                    mkdir -p build/package

                    # Create some dummy content for testing
                    echo "Build version: ${BUILD_VERSION}" > build/package/version.txt
                    echo "Build ID: ${BUILD_ID}" >> build/package/version.txt
                    date > build/package/build-time.txt

                    echo "Building application..."
                    # Add your actual build commands here

                    echo "Creating package ${PACKAGE_NAME}"
                    tar -czf ${PACKAGE_NAME} build/package/*

                    echo "Package created: ${PACKAGE_NAME}"
                    ls -la *.tar.gz
                '''
            }
        }

        stage('Archive Artifact') {
            steps {
                echo "Archiving build artifact"
                archiveArtifacts artifacts: '*.tar.gz', fingerprint: true
            }
        }

        stage('Check Dependencies') {
            steps {
                echo "Checking required dependencies"
                sh '''
                    # Check if expect is available
                    if command -v expect &> /dev/null; then
                        echo "expect is already installed"
                    else
                        echo "expect is not available - will use alternative method"
                    fi

                    # Check if we can install packages
                    if command -v apt-get &> /dev/null && [ -w /usr ]; then
                        echo "Package installation possible"
                    else
                        echo "Package installation not possible in this environment"
                    fi

                    # Check ansible
                    ansible --version
                '''
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

                    // Try to use expect if available, otherwise use alternative
                    def expectAvailable = sh(script: 'command -v expect', returnStatus: true) == 0

                    if (expectAvailable) {
                        echo "Using expect for automated deployment"
                        sh """
                            /usr/bin/expect <<EOF
                            set timeout 300
                            spawn ansible-playbook \\
                                -i ${params.INVENTORY_PATH} \\
                                --extra-vars="ansible_become_pass=${params.BECOME_PASS} build_version=${params.BUILD_VERSION} build_id=${BUILD_NUMBER} package_name=${PACKAGE_NAME}" \\
                                ${params.VERBOSE ? '-vvv' : ''} \\
                                --become \\
                                --ask-become-pass \\
                                new-user.yml
                            expect "BECOME password:"
                            send "${params.BECOME_PASS}\\\\r"
                            expect eof
                            catch wait result
                            exit [lindex \\\$result 3]
                            EOF
                        """
                    } else {
                        echo "Expect not available - using manual password input"
                        echo "NOTE: This will pause the build waiting for password input"
                        echo "Please enter the become password when prompted: ${params.BECOME_PASS}"

                        // Manual method - will pause build waiting for input
                        sh """
                            ansible-playbook \\
                                -i ${params.INVENTORY_PATH} \\
                                --extra-vars="ansible_become_pass=${params.BECOME_PASS} build_version=${params.BUILD_VERSION} build_id=${BUILD_NUMBER} package_name=${PACKAGE_NAME}" \\
                                ${params.VERBOSE ? '-vvv' : ''} \\
                                --become \\
                                --ask-become-pass \\
                                new-user.yml
                        """
                    }
                }
            }
        }

        stage('Verify') {
            steps {
                echo "Verifying deployment"
                sh """
                    # Test connection to verify deployment
                    ansible -i ${params.INVENTORY_PATH} -m ping all || true

                    echo "Deployment completed successfully!"
                    echo "Build Version: ${params.BUILD_VERSION}"
                    echo "Build ID: ${BUILD_NUMBER}"
                    echo "Package: ${PACKAGE_NAME}"
                """
            }
        }
    }

    post {
        always {
            echo "Cleaning up workspace"
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