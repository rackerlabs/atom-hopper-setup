#!/bin/bash

if [ -e .git ]; then
  git pull origin master
elif [ -e atom-hopper-setup ]; then
  if [ -e atom-hopper-setup/.git ]; then
    cd atom-hopper-setup
    git pull origin master
  else
    echo "Can't clone the repo." >&2
    exit 1
  fi
else
  git clone https://github.com/rackspace/atom-hopper-setup.git
  cd atom-hopper-setup
fi

if [ "$1" == "checkout" ]
then
  shift
  BRANCH=$1
  git checkout $BRANCH
  shift
fi


