#!/bin/bash
if [ "$#" == "4" ]; then
    sed -i s/"<thread>"/"$2"/g /src/inputs/properties/container.properties
    sed -i s/"<url>"/"$3"/g /src/inputs/properties/container.properties
    sed -i s/"<port>"/"$4"/g /src/inputs/properties/container.properties
    jmeter -n -t /src/tests/$1 -S /src/inputs/properties/container.properties -l /src/$(basename $1).log
elif [ "$#" == "2" ]; then
    jmeter -n -t /src/tests/$1 -S /src/inputs/properties/$2 -l /src/$(basename $1).log
else
    echo "invalid number of arguments"
fi