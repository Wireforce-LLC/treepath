#!/bin/bash

# Name of the Docker container
CONTAINER_NAME="treepath"

# Check if the container is already running
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Container $CONTAINER_NAME is already running. Stopping and removing it..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# Run the Docker container with volume mounting
echo "Starting container $CONTAINER_NAME..."
docker run -d -p 80:80 -v "$(pwd)/routes.trp:/etc/nginx/routes.trp" --name $CONTAINER_NAME treepath
