#!/bin/bash

docker run \
  --name traefik \
  --restart unless-stopped \
  --security-opt no-new-privileges:true \
  -p 80:80 \
  -p 443:443 \
  -p 8080:8080 \
  -e NETWORK_NAME=web \
  -e TRAEFIK_DASHBOARD_DOMAIN=traefik.microservices.local \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  traefik-custom:3.6.1

