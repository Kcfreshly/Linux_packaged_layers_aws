#!/bin/bash
# This script sets up a virtual environment and installs the necessary Python packages.

# Create a virtual environment
python3.12 -m venv /home/appuser/venv

# Activate the virtual environment.  Important: Use 'source' for venv activation.
source /home/appuser/venv/bin/activate

# Check if the virtual environment was activated successfully.
if [ -z "$VIRTUAL_ENV" ]; then
    echo "Error: Virtual environment not activated."
    exit 1
fi

# Install psycopg2 and paramiko within the virtual environment
pip install psycopg2-binary==2.9.9  # Use psycopg2-binary for easier installation in Lambda
pip install paramiko==3.5.0

# Deactivate the virtual environment (Good practice, though not strictly needed here, and prevents issues)
deactivate
