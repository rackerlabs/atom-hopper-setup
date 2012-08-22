#!/bin/bash

# this script will download and install a given version of atomhopper 
#   with the default configuration, and run it in tomcat as the 
#   ROOT.war file

# this is all run as root

function log {
  echo '[' `date` '] ' $1 >> setup-ah.log
}

source ./ah-vars.sh "$*"
source ./catalina-vars.sh

./teardown-ah.sh

echo "wget -qP $CATALINA_HOME/webapps/ $AH_ARTIFACT_URL"
log "wget -qP $CATALINA_HOME/webapps/ $AH_ARTIFACT_URL"
wget -qP $CATALINA_HOME/webapps/ $AH_ARTIFACT_URL
rm -rf $CATALINA_HOME/webapps/ROOT/
mv $CATALINA_HOME/webapps/$AH_FILE $CATALINA_HOME/webapps/ROOT.war

mkdir -p /etc/atomhopper
mkdir -p /opt/atomhopper
mkdir -p /var/log/atomhopper
chown -R tomcat:tomcat /etc/atomhopper /opt/atomhopper /var/log/atomhopper

# copy config files
cp ./context.xml /etc/atomhopper/
cp ./log4j.properties /etc/atomhopper/
cp ./application-context.xml /etc/atomhopper/
./conf-ah.sh h2

# start up
#$CATALINA_HOME/bin/startup.sh
service tomcat7 start

sleep 3
curl -s localhost:8080/namespace/feed


