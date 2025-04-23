# Use Amazon Linux 2023 as the base image
FROM amazonlinux:2023

# Install development tools, Python 3.12, and pip
RUN yum -y update && \
    yum install -y \
    gcc \
    make \
    zlib-devel \
    openssl-devel \
    libffi-devel \
    python3.12 \
    python3.12-devel \
    python3-pip

# Set environment variables
ENV PYTHON_VERSION=3.12
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/root/.local/bin:$PATH"

# Upgrade pip and set it as the default pip
RUN pip3 install --upgrade pip && \
    ln -s /usr/bin/pip3.12 /usr/bin/pip

# Create a non-root user for security best practices
RUN groupadd appuser && useradd -g appuser appuser
USER appuser
WORKDIR /home/appuser

# Switch back to root for installing dependencies
USER root

# Copy the installation script and make it executable
COPY docker_install.sh /tmp/docker_install.sh
RUN chmod +x /tmp/docker_install.sh

# Run the installation script to set up the virtual environment and install dependencies
RUN /tmp/docker_install.sh

# Clean up temporary files and yum cache to reduce image size
RUN yum clean all && \
    rm -rf /var/cache/yum

# Switch to the non-root user for subsequent commands
USER appuser
