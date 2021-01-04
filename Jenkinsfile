def userInput = []
def jmxDir = "/src/tests"

def jmxNames = []

def jmx = null
def inputThreads = null
def inputLoops = null
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
                            string(name: 'loops', defaultValue: '10', description: 'Script loops, controls running time'),
                            string(name: 'url', defaultValue: 'indy-perf-spmm-automation.apps.ocp4.prod.psi.redhat.com', description: 'Indy URL to test'),
                            string(name: 'port', defaultValue: '80', description: 'Indy port to test'),
                            string(name: 'daUrl', defaultValue: 'indy-perf-da-spmm-automation.apps.ocp4.prod.psi.redhat.com', description: '*only in DA stress* DA service hostname'),
                            string(name: 'gitRepoName', defaultValue: 'weft', description: '*only in DA stress* git test sample'),
                            string(name: 'gitRepoUrl', defaultValue: 'https://github.com/Commonjava/weft.git', description: '*only in DA stress* git test sample url')
                        ]
                    )
                    jmx = userInput['SCRIPT']
                    inputThreads = userInput.threads?:'5'
                    inputLoops = userInput.loops?:''
                    inputUrl = userInput.url?:''
                    inputPort = userInput.port?:'80'
                    inputDAUrl = userInput.daUrl?: ''
                    inputGitRepoName = userInput.gitRepoName?: 'indy'
                    inputGitRepoUrl = userInput.gitRepoUrl?: 'https://github.com/Commonjava/indy.git'
                }
            }
        }
        stage('Run Test'){
            steps {
                script {
                    echo "Jmeter running ${jmx}"
                    sh "printenv"
                    sh script: "THREAD=${inputThreads} HOSTNAME=${inputUrl} LOOPS=${inputLoops} PORT=${inputPort} DA_HOSTNAME=${inputDAUrl} GIT_REPO_NAME=${inputGitRepoName} GIT_REPO_URL=${inputGitRepoUrl} /src/entrypoint.sh ${jmx}"
                }
            }
        }
        stage('Archive & Publish'){
            steps{
                script{
                    sh script: "cp /src/*.log $WORKSPACE"
                }
                archiveArtifacts artifacts: "*.log"
                perfReport "${jmx}.log"
            }
        }
    }
}