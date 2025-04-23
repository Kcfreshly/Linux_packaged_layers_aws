#!/bin/bash
# This script builds the Docker image, creates a container, copies the necessary files,
# and creates a zip archive for a Lambda layer.

# Build the Docker image
docker build -t lambda-python-layer:latest .

# Create a container from the image
container_id=$(docker create lambda-python-layer:latest)

# Create a directory to store the files from the container
mkdir -p layer_contents

# Copy the contents of the virtual environment's 'python' directory to the local 'layer_contents' directory
docker cp "$container_id:/home/appuser/venv/lib/python$PYTHON_VERSION/site-packages" layer_contents/python

# Create the zip archive, changing to the parent directory first.
cd layer_contents
zip -r9 ../python_layer.zip python
cd .. # Go back to the original directory

# Remove the container and the temporary directory
docker rm "$container_id"
rm -rf layer_contents

echo "Lambda layer zip file 'python_layer.zip' has been created."
