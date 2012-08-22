#!/bin/bash

###########################
# Mongo
###########################

curl scriptserv/10gen.repo > /etc/yum.repos.d/10gen.repo
yum -y install mongo-10gen-server

