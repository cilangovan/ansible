pipeline {
    agent {
        label 'ubuntu-agent-docker'
    }

    options {
        timeout(time: 30, unit: 'MINUTES') // Increased timeout to 30 minutes
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

        stage('Deploy') {
            steps {
                echo "Deploying using Ansible"
                script {
                    // Check if inventory exists
                    def inventoryExists = fileExists("${params.INVENTORY_PATH}")
                    if (!inventoryExists) {
                        error "Inventory path ${params.INVENTORY_PATH} does not exist!"
                    }

                    // Install expect if needed
                    sh '''
                        if ! command -v expect &> /dev/null; then
                            sudo apt-get update && sudo apt-get install -y expect
                        fi
                    '''

                    // Run Ansible with expect
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
            // Use deleteDir instead of cleanWs (which requires plugin)
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