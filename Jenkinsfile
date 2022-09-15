pipeline{
    
    environment{
        
        registry = "registry.tirzok.com:5000/springboot-cicd"
        dockerImage = ''
    }
    
    agent any
    
    stages{
        
        stage('Cloning the repository'){
            
            steps{
                git 'https://github.com/parthaSdeb/springboot-cicd.git'
            }
        }
        
        stage('Build artifact'){
            
            steps(){
                withGradle {
                    sh './gradlew clean bootWar'
                }
           }
            
        }
        
        stage('Code analysis with SonarQube') {
            steps(){
                script{
                    withSonarQubeEnv(installationName: 'sonarqube-9', credentialsId: 'springboot-cicd-pipeline-token'){
                        sh './gradlew sonarqube'
                    }
                }
            }
        }
        
        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        stage('Build application image'){
            
            steps{
                script{
                dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        
        stage('Pushing appplication image to dockerhub'){
            
            steps{
                script {
                    
                    docker.withRegistry( ''){
                        dockerImage.push()
                    }
                }
            }
        }
        
        stage('deploying application'){
            
            steps{
                
                //sh "sed -i s,partha00011/simple_web_app,partha00011/simple_web_app:${BUILD_NUMBER},g simple-web-app.yaml"
                
                sh "sed -i s,registry.tirzok.com:5000/springboot-cicd,registry.tirzok.com:5000/springboot-cicd:${BUILD_NUMBER},g springboot-cicd.yaml"
                sh "kubectl apply -f springboot-cicd.yaml"
            }
        }
      
    }
    
    
}
