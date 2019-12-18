#!/bin/bash
if [ "$#" == "1" ]; then
    sed -i "s/<thread>/$THREAD/g" /src/inputs/properties/container.properties
    sed -i "s/<url>/$HOSTNAME/g" /src/inputs/properties/container.properties
    sed -i "s/<port>/$PORT/g" /src/inputs/properties/container.properties
    jmeter -n -t /src/tests/$1 -S /src/inputs/properties/container.properties -l /src/$(basename $1).log
elif [ "$#" == "2" ]; then
    jmeter -n -t /src/tests/$1 -S /src/inputs/properties/$2 -l /src/$(basename $1).log
else
    echo "invalid number of arguments"
fi