def userInput = []
def jmxDir = "/src/tests"

def jmxNames = []

def jmx = null
def inputThreads = null
def inputUrl = null
def inputPort = null

pipeline {
    agent {
      node {label 'indystress'}
    }
    stages {
        stage('Test Suites'){
            steps {
                script {
                    dir(jmxDir){
                        def jmeterScripts = findFiles(glob: "*.jmx")
                        jmeterScripts.each{
                            jmxNames << it.name
                        }
                    }
                    echo "Scripts : ${jmxNames}"
                }
            }
        }
        stage('Enter Parameters'){
            steps {
                script {
                    userInput = input(
                        id: 'userInput', message: "Please enter a test suite to run:",
                        parameters:[
                            choice(name: 'SCRIPT', choices: jmxNames, description: "Test suite"),
                            string(name: 'threads', defaultValue: '5', description: 'Jmeter treads'),
                            string(name: 'url', defaultValue: 'indy-infra-nos-automation.cloud.paas.psi.redhat.com', description: 'Indy URL to test'),
                            string(name: 'port', defaultValue: '80', description: 'Indy port to test')
                        ]
                    )
                    jmx = userInput['SCRIPT']
                    inputThreads = userInput.threads?:'5'
                    inputUrl = userInput.url?:''
                    inputPort = userInput.port?:'80'
                }
            }
        }
        stage('Run Test'){
            steps {
                script {
                    echo "Jmeter running ${jmx}"
                    sh script: "THREADS=${inputThreads} HOSTNAME=${inputUrl} PORT=${inputPort} /src/entrypoint.sh ${jmx}"
                }
            }
        }
    }
}