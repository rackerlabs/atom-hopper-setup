#!/bin/bash

if [ "$1" != "no-restart-tomcat" ]
then
  service tomcat7 stop
  sleep 3
fi

rm -f /opt/atomhopper/*

MONGO=`which mongo 2>/dev/null`
if [[ "$MONGO" != "" && -x "$MONGO" ]]
then
  mongo atomhopper --eval 'db.persistedentry.remove()'
else
  echo no mongo
fi

PSQL=`which psql 2>/dev/null`
if [[ "$PSQL" != "" && -x "$PSQL" ]]
then
  psql -c 'delete from entries; delete from categoryentryreferences; delete from categories; delete from feeds;' atomhopper postgres
  psql -c 'delete from entries;' atomhoppernew postgres
else
  echo no psql
fi

if [ "$1" != "no-restart-tomcat" ]
then
  service tomcat7 start
  sleep 3
fi

