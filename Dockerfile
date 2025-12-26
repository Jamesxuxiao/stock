# Base image
FROM jupyter/base-notebook:latest

LABEL maintainer="Jupyter Notebook <xuxiao.ca@gmail.com>"

# Switch to root to install system dependencies
USER root

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python packages
COPY ./requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# Switch back to jovyan user
USER $NB_UID

# Set working directory
WORKDIR /home/$NB_USER/work
