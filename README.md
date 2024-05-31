
# w/treepath

<img src="https://i.ibb.co/7g17JrQ/Frame-6-1.png" align="right" width="80" height="80">

This project provides a Dockerized solution for dynamically routing incoming traffic based on a configuration file. It is particularly useful for scenarios where the routing configuration needs to be updated dynamically without restarting the Nginx server.

![Bash](https://img.shields.io/badge/bash-black?style=for-the-badge&logo=zsh&logoColor=white)
![Docker](https://img.shields.io/badge/docker-black?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/nginx-black?style=for-the-badge&logo=nginx&logoColor=white)

## Features

- **Dynamic Routing**: Automatically routes incoming traffic based on a configuration file (`routes.trp`).
- **Real-time Updates**: Changes to the routing configuration file are detected in real-time, and the Nginx server configuration is updated accordingly without requiring a server restart.
- **Easy Configuration**: The routing configuration file follows a simple format (`domain => host:port`), making it easy to manage.

## How it works

The project utilizes Docker containers along with inotify-tools to monitor changes to the `routes.trp` file. When changes are detected, a script updates the Nginx server configuration dynamically to reflect the changes in routing.

## Usage

1. Clone the repository:

   ```bash
   git clone https://shorturl.at/E4uKQ    
   sh build.sh
   sh run.sh
   ```