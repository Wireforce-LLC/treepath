#!/bin/bash

echo "Starting the Treepath application configurator..."

# Name of the Docker container
CONTAINER_NAME="treepath"

# Check if the container is already running
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Container '$CONTAINER_NAME' is already running. Stopping and removing it..."

    echo "Stopping container '$CONTAINER_NAME'..."
    docker stop $CONTAINER_NAME

    echo "Removing container '$CONTAINER_NAME'..."
    docker rm $CONTAINER_NAME
fi

# Create the Docker network
echo "Creating network 'datahub'..."
docker network create --driver bridge datahub || true

# Run the Docker container with volume mounting
echo "Starting container '$CONTAINER_NAME'..."
docker run \
    -d \
    -p 80:80 \
    -v "$(pwd)/routes.trp:/etc/nginx/routes.trp" \
    --network datahub \
    --restart always \
    --hostname $CONTAINER_NAME \
    --name $CONTAINER_NAME treepath

echo "Container '$CONTAINER_NAME' started."