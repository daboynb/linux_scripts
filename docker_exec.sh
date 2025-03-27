#!/bin/bash

# Get list of running containers with ID and Name
containers=$(docker ps --format "{{.ID}}\t{{.Names}}")
if [ -z "$containers" ]; then
  echo "No running containers found."
  exit 1
fi

echo "Running Docker Containers:"
echo "$containers" | nl -w2 -s'. '

# Prompt the user to select a container by number
read -p "Enter the number of the container to attach: " selection

# Validate the selection
container_id=$(echo "$containers" | sed -n "${selection}p" | awk '{print $1}')
if [ -z "$container_id" ]; then
  echo "Invalid selection."
  exit 1
fi

echo "Attaching to container $container_id..."
docker exec -it "$container_id" /bin/bash