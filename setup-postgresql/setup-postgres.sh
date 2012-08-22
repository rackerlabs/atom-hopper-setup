#!/bin/bash

###########################
# Setup PostgreSQL
###########################

wget scriptserv/pgdg-centos91-9.1-4.noarch.rpm
yum -y --nogpgcheck localinstall pgdg-centos91-9.1-4.noarch.rpm
yum -y install postgresql91-server

#su - postgres
#/usr/pgsql-9.1/bin/initdb -D /var/lib/pgsql/9.1/data
#/usr/pgsql-9.1/bin/postgres -D /var/lib/pgsql/9.1/data >~/pg-logfile 2>&1 &
#/usr/pgsql-9.1/bin/createdb atomhopper
#wget scriptserv/atomhopper-ddl.sql
#psql -f atomhopper-ddl.sql atomhopper postgres

