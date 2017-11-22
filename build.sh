#!/bin/bash

# ensure running bash
if ! [ -n "$BASH_VERSION" ];then
    echo "this is not bash, calling self with bash....";
    SCRIPT=$(readlink -f "$0")
    /bin/bash $SCRIPT
    exit;
fi

# Get the path to script just in case executed from elsewhere.
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
cd $SCRIPTPATH

# Load the variables from settings file.
source settings.sh



if [[ $REGISTRY ]]; then
    APACHE_IMAGE_NAME="`echo $REGISTRY`/`echo $APACHE_VERSION_PROJECT_NAME`"
    NGINX_IMAGE_NAME="`echo $REGISTRY`/`echo $NGINX_VERSION_PROJECT_NAME`"
else
    APACHE_IMAGE_NAME=$APACHE_VERSION_PROJECT_NAME
    NGINX_IMAGE_NAME=$NGINX_VERSION_PROJECT_NAME
fi

# Build the apache version
# Copy the docker file up and run it in order to build the container.
# We need to move the dockerfile up so that it can easily add everything to the container.
cp -f $SCRIPTPATH/apache/Dockerfile .
docker build  --pull --tag="$APACHE_IMAGE_NAME" .
rm $SCRIPTPATH/Dockerfile


# build the nginx version
cp -f $SCRIPTPATH/nginx/Dockerfile .
docker build --pull --tag="$NGINX_IMAGE_NAME" .
rm $SCRIPTPATH/Dockerfile


# Push images if the user spcified a registry
if [[ $REGISTRY ]]; then
    docker push $APACHE_IMAGE_NAME
    docker push $NGINX_IMAGE_NAME
fi
