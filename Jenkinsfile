pipeline {

    agent any

    parameters {
        choice(
            choices: ['plan', 'apply', 'destroy'],
            description: 'Terraform Action to Perform',
            name: 'PERFORM_ACTION')

        choice(
            choices: ['development', 'production'],
            description: 'Environment to Provision Infrastructure',
            name: 'ENVIRONMENT')
    }

    stages {
        stage('Terraform Initialisation') {
            steps {
                sh 'rm -rf .terraform'
                sh 'terraform init -no-color -backend-config="${ENVIRONMENT}/${ENVIRONMENT}.tfbackend" '
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate -no-color'
            }
        }

        stage('Terraform Plan') {
            when {
                expression { params.PERFORM_ACTION == 'plan' || params.PERFORM_ACTION == 'apply' }
            }

            steps {
                sh 'terraform plan -input=false -no-color -out=tfplan --var-file=${ENVIRONMENT}/${ENVIRONMENT}.tfvars'
            }
        }

        stage('Terraform Approval') {
            when {
                expression { params.PERFORM_ACTION == 'apply' }
            }

            steps {
                sh 'terraform show -no-color tfplan > tfplan.txt'
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Apply the Terraform Plan..??",
                    parameters: [text(name: 'Plan', description: 'Review the Terraform Plan', defaultValue: plan)]
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.PERFORM_ACTION == 'apply' }
            }

            steps {
                sh 'terraform apply -no-color -input=false tfplan'
            }
        }

        stage('Terraform Preview Destroy') {
            when {
                expression { params.PERFORM_ACTION == 'destroy' }
            }

            steps {
                sh 'terraform plan -no-color -destroy -out=tfplan --var-file=${ENVIRONMENT}/${ENVIRONMENT}.tfvars'
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.PERFORM_ACTION == 'destroy' }
            }

            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Delete the Stack..??",
                    parameters: [text(name: 'Plan', description: 'Review the Terraform Plan', defaultValue: plan)]
                }
                sh 'terraform destroy -no-color --auto-approve'
            }
        }
    }
}
