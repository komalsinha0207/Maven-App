pipeline {
    agent {label 'agent' }
    tools { maven 'maven'}

    environment {
        CI = 'true'
        registry = 'docker-services-training/aleesha/'
    }
    
    stages {
         stage('Build') {
             steps {
                 script {
                     sh "mvn -B -Dmaven.test.skip=true clean package"
                     stash name: "artifact", includes: "target/soccer-stats-*.war"
                 }                               
             } 
         }
    }
}

