# Nginx Dynamic Router

This project provides a Dockerized solution for dynamically routing incoming traffic based on a configuration file. It is particularly useful for scenarios where the routing configuration needs to be updated dynamically without restarting the Nginx server.

## Features

- **Dynamic Routing**: Automatically routes incoming traffic based on a configuration file (`routes.trp`).
- **Real-time Updates**: Changes to the routing configuration file are detected in real-time, and the Nginx server configuration is updated accordingly without requiring a server restart.
- **Easy Configuration**: The routing configuration file follows a simple format (`domain => host:port`), making it easy to manage.

## How it works

The project utilizes Docker containers along with inotify-tools to monitor changes to the `routes.trp` file. When changes are detected, a script updates the Nginx server configuration dynamically to reflect the changes in routing.

## Usage

1. Clone the repository:

   ```bash
   git clone https://github.com/your_username/nginx-dynamic-router.git
    ```
2. Place your routing configuration in `routes.trp` following the format `domain => host:port`.

3. Build the Docker image:

   ```bash
   docker build -t nginx-dynamic-router .
    ```
4. Run the Docker container:

```bash
docker run -d -p 80:80 nginx-dynamic-router
```