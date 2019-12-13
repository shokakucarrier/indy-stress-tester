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
* upload-simulation-existing.jmx: using only build-1710.json to download these file and upload them again to a new hosted repo in indy, then do promotion.

## Jmeter properties

Under ./inputs/properties

* builders: number of concurrent load clients.
* prometheus.ip: prometheus exporter listen address.
* hostname: indy instance hostname.
* port: indy instance API service port.
* inputDir: directory of build-data.
* downloadDir: position of maven artifacts downloaded and saved during test.

## Build-data

Under./inputs/build-data

Json format of files need to be download; mainly for simulate artifacts or metadata needed during maven build process.