#!/bin/bash

upgrade_project() {
    echo "Pulling latest changes from git..."
    git pull

    echo "Building the project..."
    chmod +X ./build.sh
    sh ./build.sh

    echo "Restarting the application..."
    chmod +X ./run.sh
    sh ./run.sh
}

upgrade_project
