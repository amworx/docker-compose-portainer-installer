# docker-compose-portainer-installer
Automates Docker, Docker Compose Plugin, and Portainer installation on Debian/Ubuntu. The script prompts users for options like installing Compose and setting a custom port for Portainer. It simplifies setup by handling everything in one go, making it perfect for developers and sysadmins who want a quick and easy deployment process.
# Docker, Compose, and Portainer Installer Script

## Overview

This script automates the installation of Docker, Docker Compose Plugin, and Portainer on Debian/Ubuntu systems. It's designed to be user-friendly, with options to customize the installation based on your requirements.

It:
- Installs Docker Engine and Docker CLI.
- Offers an option to install the Docker Compose plugin.
- Offers an option to install Portainer and lets you choose the port for exposing the Portainer service.
- Provides a fancy output of your nickname and GitHub link using `figlet` and `lolcat` (optional).
  
## Script Name
`docopo.sh`

---

## Features

- **User Prompts**: The script prompts the user for their preferences before starting the installation.
- **Automated Installation**: Once questions are answered, the script installs everything in one go without interruptions.
- **Fancy Output**: Optionally displays a styled nickname and GitHub link at the start using `figlet` and `lolcat`.
- **Silent Install**: Installs necessary dependencies (like `figlet`, `lolcat`, and Docker-related packages) silently if not already installed.

---

## Prerequisites

- Debian or Ubuntu operating system.
- Internet connection to download Docker and other required packages.

---

## Installation

1. Clone the repository to your local machine:

  ```bash
  git clone https://github.com/amworx/docker-compose-portainer-installer.git
  ```
 2. Navigate to the directory:

  ```bash
  cd docker-compose-portainer-installer
  ```

3. Make the script executable:

  ```bash
  chmod +x docopo.sh
  ```

4. Run the script:

  ```bash
  ./docopo.sh
  ```

## Usage
The script will ask you the following questions before installation:

Do you want to install the Docker Compose plugin?
Do you want to install Portainer? (You can also choose the port to expose for Portainer, default is 9000).
After answering the questions, the script will:

Uninstall any conflicting Docker versions.
Install the latest version of Docker Engine, Docker CLI, and Compose plugin (if chosen).
Install Portainer with the specified port (if chosen).
Run a test container (hello-world) to verify Docker installation.
License
This script is open source and available for free under the MIT License.

Feel free to use it and contribute!

## Author
Developed by AMWORX.
