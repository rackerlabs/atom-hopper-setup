#!/bin/bash

# this script will delete atomhopper

source ./catalina-vars.sh

service tomcat7 stop
sleep 3

./blitz-ah.sh no-restart-tomcat

rm -rf /etc/atomhopper
rm -rf /opt/atomhopper
rm -rf /var/log/atomhopper

rm -rf $CATALINA_HOME/webapps/ROOT.war
rm -rf $CATALINA_HOME/webapps/ROOT

