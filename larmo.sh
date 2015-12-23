#!/usr/bin/env bash

DIRECTORY=$(pwd)"/"
DIRECTORY_SERVER=$DIRECTORY"larmo/server"
DIRECTORY_WEBAPP=$DIRECTORY"larmo/webapp"
DIRECTORY_WEBHOOKS=$DIRECTORY"larmo/webhooks"

git --version >/dev/null 2>&1 || { echo >&2 "I require 'git' but it's not installed.  Aborting."; exit 1; }
docker -v >/dev/null 2>&1 || { echo >&2 "I require 'docker' but it's not installed.  Aborting."; exit 1; }
docker-compose -v >/dev/null 2>&1 || { echo >&2 "I require 'docker-compose' but it's not installed.  Aborting."; exit 1; }

if [ ! -d $DIRECTORY ]; then
    mkdir $DIRECTORY
fi

if [ -d $DIRECTORY_SERVER ]; then
    cd $DIRECTORY_SERVER && git pull origin master && cd $DIRECTORY
else
    git clone git@github.com:larmo-hub/larmo-server.git $DIRECTORY_SERVER
fi

if [ -d $DIRECTORY_WEBAPP ]; then
    cd $DIRECTORY_WEBAPP && git pull origin master && cd $DIRECTORY
else
    git clone git@github.com:larmo-hub/larmo-webapp.git $DIRECTORY_WEBAPP
fi

if [ -d $DIRECTORY_WEBHOOKS ]; then
    cd $DIRECTORY_WEBHOOKS && git pull origin master && cd $DIRECTORY
else
    git clone git@github.com:larmo-hub/larmo-webhooks-agent.git $DIRECTORY_WEBHOOKS
fi

cd $DIRECTORY_SERVER && docker-compose up
cd $DIRECTORY_WEBAPP && docker-compose up
cd $DIRECTORY_WEBHOOKS && docker-compose up