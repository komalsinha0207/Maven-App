pipeline {
    agent {label 'agent' }
    tools { maven 'maven'}

    environment {
        CI = 'true'
        registry = 'docker-services-training/aleesha/'
    }
    
    stages {
       
        stage('Clone') {
            steps {
                checkout scm
            }
        } 
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


        

      stage('SonarCube analysis') {
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
    }
}


