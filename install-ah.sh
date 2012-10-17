#!/bin/bash

# this script will download and install the most recent version of atomhopper 
#   with the specified configuration

function log {
  echo '[' `date` '] ' $1 >> install-ah.log
  echo '[' `date` '] ' $1
}

RELEASE=snapshot
SRC=war
CONF=h2

command_name=$0
function print_usage {
  echo "Usage: " `basename $command_name` "[ARG]..." 1>&2
  echo "where ARG can be zero or more of the following:" 1>&2
  echo "    release    - install the latest release build" 1>&2
  echo "    snapshot   - install the latests snapshot build" 1>&2
  echo "    war        - install by copying the WAR file into tomcat's webapps folder as ROOT.war" 1>&2
  echo "    rpm        - install by running the RPM file via yum" 1>&2
  echo "    jetty      - install by running the embedded Jetty JAR file as a background process" 1>&2
  echo "    h2         - configure to use the h2 backend on the local filesystem" 1>&2
  echo "    postgresql - configure to use the postgresql backend installed on localhost" 1>&2
  echo "    mongo      - configure to use the mongo backend installed on localhost" 1>&2
  echo "" 1>&2
}

if [ "$1" == "--help" ]; then
  print_usage
  exit 0
fi

for arg in "$@"
do
  if [ "$arg" == "release" ]; then 
    RELEASE=release
  elif [ "$arg" == "snapshot" ]; then
    RELEASE=snapshot
  elif [ "$arg" == "war" ]; then
    SRC=war
  elif [ "$arg" == "rpm" ]; then
    SRC=rpm
  elif [ "$arg" == "jetty" ]; then
    SRC=jetty
  elif [ "$arg" == "h2" ]; then
    CONF=h2
  elif [ "$arg" == "postgresql" ]; then
    CONF=postgresql
  elif [ "$arg" == "mongo" ]; then
    CONF=mongo
  else
    echo "Unknown arg \"$arg\""
    print_usage
    exit 1
  fi
done

### calculate variables and urls
source ./ah-vars.sh $RELEASE $SRC
source ./catalina-vars.sh

### log the setup attempt
log "install-ah.sh - RELEASE=$RELEASE, SRC=$SRC, CONF=$CONF, AH_ARTIFACT_URL=$AH_ARTIFACT_URL"

service tomcat7 stop
java -jar jetty-killer.jar &>/dev/null    # shutdown any ah jetty
sleep 3

# clean out the database
./blitz-ah.sh no-restart-tomcat

### tear down any previous versions

# uninstall any rpm
yum erase -y -q atomhopper.noarch

# uninstall any WAR file
rm -rf $CATALINA_HOME/webapps/ROOT.war
rm -rf $CATALINA_HOME/webapps/ROOT

# remove any jetty files
#

# delete left-over config files
rm -rf /etc/atomhopper
rm -rf /opt/atomhopper
rm -rf /var/log/atomhopper

rm -rf $AH_FILE

wget -q $AH_ARTIFACT_URL

### install the newest version based on the desired deployment mechanism
if [ "$SRC" == "war" ] ; then

  mkdir -p /etc/atomhopper
  mkdir -p /opt/atomhopper
  mkdir -p /var/log/atomhopper
  chown -R tomcat:tomcat /etc/atomhopper /opt/atomhopper /var/log/atomhopper

  mv $AH_FILE $CATALINA_HOME/webapps/
  rm -rf $CATALINA_HOME/webapps/ROOT/
  mv $CATALINA_HOME/webapps/$AH_FILE $CATALINA_HOME/webapps/ROOT.war

elif [ "$SRC" == "rpm" ]; then

  if [ -e /srv/tomcat -a ! -L /srv/tomcat ]; then
    rm -rf /srv/tomcat
  fi
  if [ -e /srv/tomcat7 -a ! -L /srv/tomcat7 ]; then
    rm -rf /srv/tomcat7
  fi

  ln -s /usr/share/tomcat7/ /srv/tomcat7
  ln -s /usr/share/tomcat7/ /srv/tomcat

  yum install --nogpgcheck -y -q $AH_FILE

elif [ "$SRC" == "jetty" ]; then

  mkdir -p /etc/atomhopper
  mkdir -p /opt/atomhopper
  mkdir -p /var/log/atomhopper
  chown -R tomcat:tomcat /etc/atomhopper /opt/atomhopper /var/log/atomhopper

fi

chmod 755 /opt/atomhopper

### copy config files
cp ./atom-server.cfg.xml /etc/atomhopper/
cp ./context.xml /etc/atomhopper/
cp ./log4j.properties /etc/atomhopper/
cp ./application-context.xml /etc/atomhopper/

./conf.pl $CONF --no-restart-tomcat --param hostname=`./calc-ip.sh`

# start up
if [ "$SRC" != "jetty" ]; then
  service tomcat7 start
else
  java -jar $AH_FILE start &>/var/log/atomhopper/jetty.log &
fi

sleep 3
curl -s localhost:8080/namespace/feed


