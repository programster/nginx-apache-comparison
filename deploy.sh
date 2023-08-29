#!/bin/bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

# Setup for relative paths.
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT") 
cd $SCRIPTPATH

# load the variables
source settings.sh

if [[ $REGISTRY ]]; then
    APACHE_IMAGE_NAME="`echo $REGISTRY`/`echo $APACHE_VERSION_PROJECT_NAME`"
    NGINX_IMAGE_NAME="`echo $REGISTRY`/`echo $NGINX_VERSION_PROJECT_NAME`"
else
    APACHE_IMAGE_NAME=$APACHE_VERSION_PROJECT_NAME
    NGINX_IMAGE_NAME=$NGINX_VERSION_PROJECT_NAME
fi

APACHE_VERSION_CONTAINER_NAME="apache-version"
NGINX_VERSION_CONTAINER_NAME="nginx-version"

# Kill the container if it is already running.
docker kill $APACHE_VERSION_CONTAINER_NAME
docker kill $NGINX_VERSION_CONTAINER_NAME
docker rm $APACHE_VERSION_CONTAINER_NAME
docker rm $NGINX_VERSION_CONTAINER_NAME


# Now start the apache container on port 8000
docker run -d \
  --restart=always \
  -p 8000:80 \
  --name="$APACHE_VERSION_CONTAINER_NAME" \
  $APACHE_IMAGE_NAME

# Start the nginx container on port 8080
docker run -d \
  --restart=always \
  -p 8080:80 \
  --name="$NGINX_VERSION_CONTAINER_NAME" \
  $NGINX_IMAGE_NAME
