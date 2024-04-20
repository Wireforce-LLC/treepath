#!/bin/bash

# Command to run the Docker container with volume mounting
docker run -d -p 80:80 -v "$(pwd)/routes.trp:/etc/nginx/routes.trp" treepath

