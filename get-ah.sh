#!/bin/bash

if [ -e .git ]; then
  git pull origin origin master
else
  git clone https://github.com/rich4632/atom-hopper-setup.git .
fi

chmod u+x *.sh
chmod u+x setup*/*.sh

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
  mv atom-server.cfg.xml.template atom-server.cfg.xml.template.2
  cat atom-server.cfg.xml.template.2 | sed "s/\${hostname}/$REPLACE/g" > atom-server.cfg.xml.template
  rm atom-server.cfg.xml.template.2
fi

if [ "$1" != "no-domain" ]
then
  cat atom-server.cfg.xml.template | sed 's/\${backend}/h2/g' > atom-server.cfg.xml.h2
  cat atom-server.cfg.xml.template | sed 's/\${backend}/mongo/g' > atom-server.cfg.xml.mongo
  cat atom-server.cfg.xml.template | sed 's/\${backend}/postgresql/g' > atom-server.cfg.xml.postgresql
fi

