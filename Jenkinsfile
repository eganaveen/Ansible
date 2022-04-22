pipeline{
    agent any
    stages{
        stage('Do a Dry Run'){
            steps{
                sh 'sudo ansible-playbook roboshop.yml -e HOST=localhost -e role_name=frontend -C'
            }
        }
    }
}