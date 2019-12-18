#!/bin/bash
if [ "$1" == "da-simulation-existing.jmx" ]; then
    sed -i "s/<dahostname>/$DA_HOSTNAME/g" /src/inputs/properties/da.properties
    sed -i "s/<git_repo_name>/$GIT_REPO_NAME/g" /src/inputs/properties/da.properties
    mkdir -p /usr/share/git
    git clone $GIT_REPO_URL /usr/share/git/$GIT_REPO_NAME
elif [ "$#" == "1" ]; then
    sed -i "s/<thread>/$THREAD/g" /src/inputs/properties/container.properties
    sed -i "s/<url>/$HOSTNAME/g" /src/inputs/properties/container.properties
    sed -i "s/<port>/$PORT/g" /src/inputs/properties/container.properties
    jmeter -n -t /src/tests/$1 -S /src/inputs/properties/container.properties -l /src/$(basename $1).log
elif [ "$#" == "2" ]; then
    jmeter -n -t /src/tests/$1 -S /src/inputs/properties/$2 -l /src/$(basename $1).log
else
    echo "invalid number of arguments"
fi