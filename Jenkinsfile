pipeline {
    agent any

    environment {
        // Define database connection parameters (change with your values)
        DB_USER = 'myuser'
        DB_PASSWORD = 'mypassword'
        DB_NAME = 'mydatabase'
        DB_HOST = '172.105.61.181'  // MySQL server's IP address
        SQL_DIR = 'pran'  // The directory where your .sql files are located
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    // Pull the latest code from the GitHub repository
                    checkout scm
                }
            }
        }

        // stage('Identify Modified SQL Files') {
        //     steps {
        //         script {
        //             // Fetch the list of modified SQL files in the 'pran' directory
        //             modifiedFiles = sh(script: 'git diff --name-only HEAD HEAD~1 | grep "^${SQL_DIR}/.*\\.sql$"', returnStdout: true).trim()

        //             // Check if there are any modified SQL files
        //             if (modifiedFiles) {
        //                 echo "Modified SQL files: ${modifiedFiles}"
        //             } else {
        //                 echo "No modified SQL files found."
        //                 currentBuild.result = 'SUCCESS'
        //                 return
        //             }
        //         }
        //     }
        // }

        // stage('Execute SQL Files') {
        //     steps {
        //         script {
        //             // Loop over each modified SQL file and execute it against the remote MySQL database
        //             def sqlFiles = modifiedFiles.split('\n')
        //             sqlFiles.each { sqlFile ->
        //                 echo "Executing SQL file: ${sqlFile}"
                        
        //                 // Run the SQL file on the remote MySQL server
        //                 def exitCode = sh(script: "mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < ${sqlFile}", returnStatus: true)
                        
        //                 // Check if the SQL execution was successful
        //                 if (exitCode != 0) {
        //                     error "Error executing SQL file: ${sqlFile}"
        //                 } else {
        //                     echo "Successfully executed: ${sqlFile}"
        //                 }
        //             }
        //         }
        //     }
        // }

        stage('Identify Modified SQL Files') {
    steps {
        script {
            // Get list of modified SQL files
            def modifiedSQLFiles = sh(script: "git diff --name-only HEAD HEAD~1 | grep '^pran/.*\\.sql$'", returnStdout: true).trim()

            // Check if files are modified
            if (modifiedSQLFiles) {
                echo "Found modified SQL files: ${modifiedSQLFiles}"
                env.MODIFIED_SQL_FILES = modifiedSQLFiles
            } else {
                echo "No modified SQL files found."
                // You can set a variable or handle it here for further conditions
                env.MODIFIED_SQL_FILES = ""
            }
        }
    }
}

stage('Execute SQL Files') {
    when {
        expression { return env.MODIFIED_SQL_FILES != "" }
    }
    steps {
        script {
            // Loop through and execute SQL files if any are modified
            def sqlFiles = env.MODIFIED_SQL_FILES.split("\n")
            sqlFiles.each { sqlFile ->
                echo "Running SQL file: ${sqlFile}"
                sh "mysql -h 172.105.61.181 -u myuser -pmypassword mydatabase < ${sqlFile}"
            }
        }
    }
}

  }

    post {
        success {
            echo "All SQL files executed successfully."
        }
        failure {
            echo "Pipeline failed."
        }
        always {
            cleanWs()  // Clean workspace after build
        }
    }
}
