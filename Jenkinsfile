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
     stage('Unit Test') {
             steps {
                 script {
                     sh "mvn -B clean test"
                     stash name: "unit_tests", includes: "target/surefire-reports/**"
                 }
             } 
         }

         stage('Integration Test') {
             steps {
                 script {
                     sh "mvn -B clean verify -Dsurefire.skip=true"
                     stash name: 'it_tests', includes: 'target/failsafe-reports/**'
                 }                
             } 
         }

         stage('Static analysis') {
             steps {
                 script {
                     withSonarQubeEnv('sonar'){
                         unstash 'it_tests'
                         unstash 'unit_tests'
                         sh 'mvn sonar:sonar -DskipTests'
                     }
                 }                 
             } 
         }

         
         stage('Build the image') { 
            steps { 
                script {
                    unstash name:"artifact"
                    docker.withTool('docker') {
                        docker.withRegistry('https://artifactory.dagility.com', 'aleesha-registry'){
                            docker.build(registry + "maven:latest").push()
                        }
                    }
                } 
            }
         }
         
         stage('Deploy the application') {
            steps {
                ansiblePlaybook (
                credentialsId: 'aleesha-private-key',
                disableHostKeyChecking: true,
                extraVars: [password : "${params.registry_pass}"],
                installation: 'ansible',
                inventory: 'ansible/inventory.ini',
                playbook: 'ansible/maven.yml')
            }
        }
    }
}


