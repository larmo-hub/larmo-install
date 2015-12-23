#!/usr/bin/env bash

# variables

DIRECTORY=$(pwd)"/"

SERVER_DIRECTORY=$DIRECTORY"larmo/server"
SERVER_REPOSITORY="git@github.com:larmo-hub/larmo-server.git"

WEBAPP_DIRECTORY=$DIRECTORY"larmo/webapp"
WEBAPP_REPOSITORY="git@github.com:larmo-hub/larmo-webapp.git"

WEBHOOKS_DIRECTORY=$DIRECTORY"larmo/webhooks"
WEBHOOKS_REPOSITORY="git@github.com:larmo-hub/larmo-webhooks-agent.git"

# check required software

git --version >/dev/null 2>&1 || { echo >&2 "I require 'git' but it's not installed.  Aborting."; exit 1; }
docker -v >/dev/null 2>&1 || { echo >&2 "I require 'docker' but it's not installed.  Aborting."; exit 1; }
docker-compose -v >/dev/null 2>&1 || { echo >&2 "I require 'docker-compose' but it's not installed.  Aborting."; exit 1; }

# functions

function updateSourceCode {
    TARGET_DIRECTORY=$1
    GIT_REPOSITORY_URL=$2
    
    if [ -d $TARGET_DIRECTORY ]; then
        cd $TARGET_DIRECTORY && git pull origin master && cd $DIRECTORY
    else
        git clone $GIT_REPOSITORY_URL $TARGET_DIRECTORY
    fi
}

# create root directory

if [ ! -d $DIRECTORY ]; then
    mkdir $DIRECTORY
fi

# update source code

updateSourceCode $SERVER_DIRECTORY $SERVER_REPOSITORY
updateSourceCode $WEBAPP_DIRECTORY $WEBAPP_REPOSITORY
updateSourceCode $WEBHOOKS_DIRECTORY $WEBHOOKS_REPOSITORY

# run containers

cd $SERVER_DIRECTORY && docker-compose up
cd $WEBAPP_DIRECTORY && docker-compose up
cd $WEBHOOKS_DIRECTORY && docker-compose up