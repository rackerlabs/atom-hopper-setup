#!/bin/bash

service tomcat7 stop
DIR=`dirname $0`
$DIR/conf.pl --no-restart-tomcat "$@"
$DIR/blitz-ah.sh no-restart-tomcat
service tomcat7 start

RETVAL=7
i=0
while [ "$RETVAL" = "7" ]; do
  sleep 2
  echo "Trying to GET a feed: "
  curl localhost:8080/namespace/feed -s -v
  RETVAL=$?
  if [ $RETVAL != 0 ]; then
    echo "Error - Return value: $RETVAL"
  fi
  if [ $i -gt 3 ]; then
    echo "Couldn't GET the feed, aborting."
    exit $RETVAL
  fi
done
