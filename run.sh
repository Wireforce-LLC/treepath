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

# Check if the 'datahub' network exists
if [ ! "$(docker network ls | grep datahub)" ]; then
  echo "Creating 'datahub' network ..."
  docker network create datahub
else
  echo "'datahub' network exists."
fi

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

echo "Happy TreePathing!"
echo """Congratulations, TreePath is up and running and ready to receive your traffic!
What's next? 

- Connect all the containers you want TreePath to access to the 'datahub' network. It was created automatically
- All! Each change to the routes.trp file will automatically create Nginx configurations for your containers
"""
