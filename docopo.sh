#!/bin/bash

# Function to install a package silently
install_if_missing() {
    if ! dpkg -l | grep -q $1; then
        echo "Installing $1..."
        apt-get install -y $1 > /dev/null 2>&1
    fi
}

# Install figlet and lolcat silently for fancy text display
install_if_missing figlet
install_if_missing lolcat

# Verify if lolcat was installed correctly, otherwise print a warning
if ! command -v lolcat &> /dev/null; then
    echo "Warning: lolcat could not be installed. Proceeding without color effects."
    use_lolcat=false
else
    use_lolcat=true
fi

# Fancy display of nickname and GitHub link
clear
if $use_lolcat; then
    figlet "AMWORX" | lolcat
    echo "GitHub: https://github.com/amworx" | lolcat
else
    figlet "AMWORX"
    echo "GitHub: https://github.com/amworx"
fi

# Function to ask for yes/no confirmation
ask_yes_no() {
    while true; do
        read -p "$1 [y/n]: " yn
        case $yn in
            [Yy]* ) return 0;;  # Yes
            [Nn]* ) return 1;;  # No
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Ask all the questions at the beginning
echo "Let's gather the required information first."

install_compose=false
if ask_yes_no "Do you want to install the Docker Compose plugin?"; then
    install_compose=true
fi

install_portainer=false
port=9000  # Default Port
if ask_yes_no "Do you want to install Portainer?"; then
    install_portainer=true
    read -p "Which port do you want to expose for Portainer? (default is 9000): " port_input
    port=${port_input:-9000}
fi

# Uninstall conflicting packages
echo "Uninstalling old versions of Docker and related packages..."
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
  apt-get remove -y $pkg
done

# Update package index and install dependencies
echo "Updating package index and installing required packages..."
apt-get update
apt-get install -y ca-certificates curl

# Create directory for Docker GPG key
echo "Setting up Docker's official GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo "Adding Docker repository to apt sources..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index to include the Docker repository
apt-get update

# Install Docker Engine, CLI, containerd, and Docker Buildx plugin
echo "Installing Docker packages..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin

# Install Docker Compose Plugin if requested
if $install_compose; then
    echo "Installing Docker Compose plugin..."
    apt-get install -y docker-compose-plugin
    echo "Verifying Docker Compose installation..."
    docker compose version
fi

# Install Portainer if requested
if $install_portainer; then
    # Create the Portainer data volume
    echo "Creating Portainer data volume..."
    docker volume create portainer_data

    # Run Portainer container with the selected or default port
    echo "Installing Portainer on port $port..."
    docker run -d -p 8000:8000 -p $port:9443 --name portainer --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data \
    portainer/portainer-ce:2.21.3

    echo "Portainer installed and running on port $port."
fi

# Verify Docker installation by running a test container
echo "Verifying Docker installation by running 'hello-world' container..."
docker run hello-world

echo "Docker installation completed successfully!"
