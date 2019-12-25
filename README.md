Indy stress tester
========

This is a [Jmeter](https://jmeter.apache.org/) stress test designed for [indy](https://github.com/Commonjava/indy)

Supports Download and Upload+promotion test, Dependency Analyse and PME support will be included in the future.

## Useage

This script supports multiple startup method, `start.sh` is only for debug this script and should not used for reference.

To initial a local test, please checkout specially modified version of dockprom.

To start a OpenShift tester container: use Jenkinsfile.pipeline for Jenkins script, indystress template should be predefined in the Jenkins Kubernetes Plugin; Refer to [jenkins-plugin](https://github.com/openshift/jenkins-plugin).

## Test suites

Under ./tests

* build-simulation-existing.jmx: grab a random set of download files and download from the indy instance. only upload small xml files and do promotion.
* download-simulation-existing.jmx: download a selection of files to cache and continues download them from cache.
* upload-simulation-existing.jmx: using only build-1710.json to download these file and upload them again to a new hosted repo in indy, then do promotion.
* da-simulation-existing.jmx: clone git maven repo and do dependency analysis simulation, it is not capatible with multithreading.

## Jenkins parameter

* SCRIPT: auto detect scripts under ./tests/ ,choose one for benchmark
* threads: jmeter threads for scale up the load (dosen't apply to DA); e.g: 5
* loops: loops to control duration of script running time (dosen't apply to DA); e.g: 10
* url: indy instance URL await for testing (dosen't apply to DA); e.g:indy-infra-nos-automation.cloud.paas.psi.redhat.com (do not add http:// in the head)
* port: indy instance port awaith for testing (dosen't apply to DA); e.g: 80
* daUrl: dependency analysis address for testing (only apply to DA); e.g: da-stage.psi.redhat.com (do not add http:// in the head)
* gitRepoName & gitRepoUrl: maven data provide to dependency analysis (only apply to DA) e.g: weft ; https://github.com/Commonjava/weft.git (must be the same thing and must have https:// and .git in the URL)

## Jmeter properties

Under ./inputs/properties

* builders: number of concurrent load clients.
* loops: number of loop to be excute during benchmark, not affecting setup and teardown.
* prometheus.ip: prometheus exporter listen address.
* hostname: indy instance hostname.
* port: indy instance API service port.
* inputDir: directory of build-data.
* downloadDir: position of maven artifacts downloaded and saved during test.

## Build-data

Under./inputs/build-data

Json format of files need to be download; mainly for simulate artifacts or metadata needed during maven build process.