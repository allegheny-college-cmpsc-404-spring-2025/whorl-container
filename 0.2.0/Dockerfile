# Use the official Ubuntu image as the base image
FROM mcr.microsoft.com/devcontainers/python:3.12-bookworm

# Create build argument for NFS_DEST
ARG NFS_DEST="universe-a"

# Set the DEBIAN_FRONTEND environment variable to noninteractive to disable interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables for API host, port values
ENV API_HOST=""
ENV API_PORT=""
ENV NFS_DEST=$NFS_DEST

# Set the system timezone to America/New_York
RUN echo "America/New_York" > /etc/timezone

# Update the package lists for upgrades and new package installations, then install the listed packages
RUN apt-get update && apt-get install -y \
  jq \
  git \
  curl \ 
  nano \
  sudo \
  tree \ 
  wget \
  tzdata \ 
  python3 \
  sqlite3 \
  nfs-common \
  python3-dev \
  python3-pip \
  libcairo2-dev \
  python-is-python3 

# Install the listed Python packages using pip
RUN python -m pip install \
  rich \
  typer \
  pillow \
  pyyaml \
  openai \
  arglite \
  seaborn \
  requests \
  matplotlib \
  gatorgrader \
  python-dotenv --break-system-packages

# Clone the client libraries and install at root level, system-wide
RUN git clone -b endpoint_authentication https://github.com/hellowhorl/whorl-client

RUN cd whorl-client && python -m pip install . --break-system-packages

# Define an argument for the GitHub CDN URL for later scripts
ARG GITHUB_CDN=https://raw.githubusercontent.com/hellowhorl/whorl-container/main

# Download a script from the GitHub CDN and append it to the bashrc file, download and execute a script from the GitHub CDN
RUN curl -fsSL $GITHUB_CDN/scripts/direvents.sh | cat >> /etc/bash.bashrc
RUN curl -fsSL $GITHUB_CDN/scripts/gginstall.sh | sh

# Install and setup KRB5 ticketing system; TODO: automate ticket stuff (seems implausible)
RUN sudo -E apt -y -qq install krb5-user
RUN curl -fsSL $GITHUB_CDN/scripts/krb5.conf | cat > /etc/krb5.conf

# Set up NFS services
RUN sudo update-rc.d rpcbind enable
RUN sudo update-rc.d nfs-common enable
RUN sudo mkdir /universe
RUN sudo mkdir -p /run/sendsigs.omit.d

# Create halfway-dynamic call to set up NFS server mount
RUN sudo echo "warehouse.chompe.rs:/mounts/$NFS_DEST /universe nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> /etc/fstab

# Setup call to omnipresence to register new users; update old
RUN echo "presence" >> /etc/bash.bashrc

# Create .gatorgrade.yml call as alias
RUN echo "alias gatorgrade='gatorgrade --config .gatorgrade.yml'"

# Setup Python not to write __pycache__
RUN export PYTHONDONTWRITEBYTECODE=1

# Add the "entrypoint.sh" file from the Docker build context to the image, and make the "entrypoint.sh" file executable
ADD entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

# Set the "entrypoint.sh" script as the entrypoint of the container (this script will be executed when a container is run from the image)
ENTRYPOINT /entrypoint.sh

