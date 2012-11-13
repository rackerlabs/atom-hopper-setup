#!/bin/bash

service tomcat7 stop
DIR=`dirname $0`
$DIR/conf.pl --no-restart-tomcat "$@"
$DIR/blitz-ah.sh no-restart-tomcat
service tomcat7 start

sleep 2

curl localhost:8080/namespace/feed -s
