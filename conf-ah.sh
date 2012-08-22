#!/bin/bash

if [ "$1" == "h2" ]
then
  BACKEND=$1
elif [ "$1" == "mongo" ]
then
  BACKEND=$1
elif [ "$1" == "postgresql" ]
then
  BACKEND=$1
else
  BACKEND=
fi

if [ "$BACKEND" != "" ]; then
  echo "Configuring for $BACKEND back-end"
  service tomcat7 stop

  cp -f ./atom-server.cfg.xml.$BACKEND /etc/atomhopper/atom-server.cfg.xml

  service tomcat7 start
else
  echo 'Usage:'
  BASENAME=`basename $0`
  echo "    $BASENAME {h2|postgresql|mongo}"
  echo ''
  exit
fi
