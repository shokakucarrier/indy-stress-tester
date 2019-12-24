def userInput = []
def jmxDir = "/src/tests"

def jmxNames = []

def jmx = null
def inputThreads = null
def inputUrl = null
def inputPort = null

def inputDAUrl = null
def inputGitRepoName = null
def inputGitRepoUrl = null

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
                            string(name: 'port', defaultValue: '80', description: 'Indy port to test'),
                            string(name: 'da-url', defaultValue: 'da-stage.psi.redhat.com', description: '*only in DA stress* DA service hostname'),
                            string(name: 'git_repo_name', defaultValue: 'weft', description: '*only in DA stress* git test sample'),
                            string(name: 'git_repo_url', defaultValue: 'https://github.com/Commonjava/weft.git', description: '*only in DA stress* git test sample url')
                        ]
                    )
                    jmx = userInput['SCRIPT']
                    inputThreads = userInput.threads?:'5'
                    inputUrl = userInput.url?:''
                    inputPort = userInput.port?:'80'
                    inputDAUrl = userInput.da-url?: ''
                    inputGitRepoName = userInput.git_repo_name?: ''
                    inputGitRepoUrl = userInput.git_repo_url?: ''
                }
            }
        }
        stage('Run Test'){
            steps {
                script {
                    echo "Jmeter running ${jmx}"
                    sh "printenv"
                    sh script: "THREADS=${inputThreads} HOSTNAME=${inputUrl} PORT=${inputPort} DA_HOSTNAME=${inputDAUrl} GIT_REPO_NAME=${inputGitRepoName} GIT_REPO_URL=${inputGitRepoUrl} /src/entrypoint.sh ${jmx}"
                }
            }
        }
        stage('Archive'){
            steps{
                archiveArtifacts artifacts: "/src/*.xml, /src/*.log"
            }
        }
    }
}