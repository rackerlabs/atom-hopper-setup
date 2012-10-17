#!/bin/bash

if [ -e .git ]; then
  git pull origin master
else
  git clone https://github.com/rich4632/atom-hopper-setup.git 
  cd atom-hopper-setup
fi

#chmod u+x *.sh
#chmod u+x setup*/*.sh

if [ "$1" == "checkout" ]
then
  shift
  BRANCH=$1
  shift
else
  BRANCH=master
fi

git checkout $BRANCH

if [ "$1" == "hostname" ]
then
  export REPLACE=$HOSTNAME
elif [ "$1" == "no-domain" ]
then
  export REPLACE=
else
  # use the ip address
  export REPLACE=`/sbin/ifconfig | grep '\<inet\>' | sed -n '1p' | tr -s ' ' | cut -d ' ' -f3 | cut -d ':' -f2`
fi

if [ "$REPLACE" != "" ]
then
  mv atom-server.cfg.xml atom-server.cfg.xml.2
  cat atom-server.cfg.xml.2 | sed "s/\${hostname}/$REPLACE/g" > atom-server.cfg.xml
  rm atom-server.cfg.xml.2
fi


