#!/bin/bash

if [ -e .git ]; then
  git pull origin master
else
  git clone https://github.com/rich4632/atom-hopper-setup.git 
  cd atom-hopper-setup
fi

