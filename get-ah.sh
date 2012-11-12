#!/bin/bash

if [ -e .git ]; then
  git pull origin master
else
  git clone https://github.com/rackspace/atom-hopper-setup.git 
  cd atom-hopper-setup
fi

if [ "$1" == "checkout" ]
then
  shift
  BRANCH=$1
  shift
else
  BRANCH=master
fi

git checkout $BRANCH

