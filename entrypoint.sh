#!/bin/bash
if [ "$#" == "4" ]; then
    sed -i s/"<thread>"/"$2"/g ./inputs/properties/container.properties
    sed -i s/"<url>"/"$3"/g ./inputs/properties/container.properties
    sed -i s/"<port>"/"$4"/g ./inputs/properties/container.properties
    jmeter -n -t ./tests/$1 -S ./inputs/properties/container.properties -l ./$(basename $1).log
elif [ "$#" == "2" ]; then
    jmeter -n -t ./tests/$1 -S ./inputs/properties/$2 -l ./$(basename $1).log
else
    echo "invalid number of arguments"
fi