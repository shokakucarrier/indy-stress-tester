#!/bin/bash

SCRIPT=$(cd ${0%/*} && echo $PWD/${0##*/})
# THIS=`realpath ${0}`
DIR=`dirname ${SCRIPT}`

#INDY_WORKDIR=${INDY_WORKDIR:-$PWD}

JMETER=${JMETER:-$HOME/apache-jmeter-5.1.1/bin/jmeter}
TEST=${JMETER_TEST:-$DIR/tests/upload-simulation-existing.jmx}
LOG=${JMETER_LOG:-"$DIR/$(basename $TEST).log"}
PROPS=${JMETER_PROPS:-$DIR/inputs/properties/local5.properties}

rm -rf $DIR/test-downloads
rm -f $LOG

echo "Starting Indy..."
docker run --rm --name indy_local -d -p 8080:8080 -p 8081:8081 quay.io/factory2/indy:latest-release

echo "Waiting for Indy startup to complete..."
while ! lsof -i -P | grep 8080 | grep LISTEN 2>&1 > /dev/null; do
  #ps ax | grep $INDY_PID | grep -v grep 2>&1 > /dev/null
  if [ $? -ne 0 ]; then
  	echo "Indy did not start properly."
  	exit 2
  fi

  sleep 0.1 # wait for 1/10 of the second before check again
done


echo "$JMETER -n -t $TEST -S $PROPS -l $LOG"
$JMETER -n -t $TEST -S $PROPS -l $LOG
#docker stop indy_local