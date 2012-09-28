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

  if [ "$2" != "no-restart-tomcat" ] ; then
    service tomcat7 stop
  fi

  cp -f ./application-context.xml.$BACKEND /etc/atomhopper/application-context.xml

  if [ "$2" != "no-restart-tomcat" ] ; then
    service tomcat7 start
  fi

else
  echo 'Usage:'
  BASENAME=`basename $0`
  echo "    $BASENAME {h2|postgresql|mongo} [no-restart-tomcat]"
  echo ''
  exit
fi
