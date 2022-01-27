pipeline {
    agent {
        label 'testintegration'
    }

    environment {
        // Default credentials for testing on devspace
        MAVEN_SNAPSHOTS_REPO_URL = 'http://nexus:8081/nexus/repository/maven-internal/'
        MAVEN_USER = 'admin'
        MAVEN_PASSWORD = 'admin123'

        // Disable Gradle daemon
        GRADLE_OPTS = '-Dorg.gradle.daemon=false'
    }

    stages {
        stage('Versions') {
            steps {

                copyArtifacts(projectName: 'OMERO-gradle-plugins-build', flatten: true, filter: 'version.properties')

                // build is in .gitignore so we can use it as a temp dir
                sh """
                    mkdir ${env.WORKSPACE}/build
                    cd ${env.WORKSPACE}/build && curl -sfL https://github.com/ome/build-infra/archive/master.tar.gz | tar -zxf -
                    export PATH=$PATH:${env.WORKSPACE}/build/build-infra-master/
                    cd ..
                    # Workaround for "unflattened" file, possibly due to matrix
                    find . -name version.properties -exec cp {} . \\;
                    test -e version.properties
                    foreach-get-version-as-property >> version.properties
                """
                archiveArtifacts artifacts: 'version.properties'
            }
        }
        stage('Build') {
            steps {
                // Currently running on a build node with multiple jobs so incorrect jar may be cached
                // (Moving to Docker should fix this)
                sh '''
                    source /opt/omero/server/venv3/bin/activate
                    gradle --init-script init-ci.gradle publishToMavenLocal --refresh-dependencies
                '''
                archiveArtifacts artifacts: 'omero-blitz/build/**/*python.zip'
            }
        }
        stage('Deploy') {
            steps {
                sh 'gradle --init-script init-ci.gradle publish'
            }
        }
    }

    post {
        always {
            // Cleanup workspace
            deleteDir()
        }
    }

}
