#!/bin/bash

# Script to set up a fresh Bazzite Linux system with development applications
# Run with: bash setup_bazzite.sh

set -e  # Exit on error

echo "============================================"
echo "Bazzite Linux Setup Script"
echo "============================================"
echo ""

# Check if running as root or with sudo
if [[ $EUID -ne 0 ]]; then
    echo "⚠️  This script needs to be run with sudo"
    echo "   Run: sudo bash setup_bazzite.sh"
    echo ""
    exit 1
fi

echo "📦 Updating system packages..."
dnf update -y

echo ""
echo "============================================"
echo "Installing Applications"
echo "============================================"
echo ""

# Install Google Chrome
echo "🌐 Installing Google Chrome..."
dnf install -y google-chrome-stable

# Install p7zip (7-Zip for Linux)
# echo "📦 Installing p7zip (7-Zip)..."
# dnf install -y p7zip p7zip-plugins

# Install Python (latest version)
# echo "🐍 Installing Python (latest)..."
# dnf install -y python3 python3-pip python3-devel

# Install Node.js (latest LTS version)
echo "📗 Installing Node.js (latest LTS)..."
dnf install -y nodejs npm

# Install Visual Studio Code
echo "💻 Installing Visual Studio Code..."
rpm --import https://packages.microsoft.com/keys/microsoft.asc
dnf install -y code

# Install Postman
echo "📮 Installing Postman..."
dnf install -y postman

# Install Docker & Docker Engine
echo "🐳 Installing Docker..."
dnf install -y docker docker-compose

# Start and enable Docker
systemctl enable docker
systemctl start docker

# Add current user to docker group (requires logout/login or newgrp)
if ! groups "$SUDO_USER" | grep -q docker; then
    usermod -aG docker "$SUDO_USER"
    echo "⚠️  Added $SUDO_USER to docker group (requires logout/login to take effect)"
fi

# Install KDE Plasma tweaks and tools
# echo "🎨 Installing KDE Plasma tools..."
# dnf install -y plasma-workspace-x11-wayland sddm-kcm kde-applications

# Install Dolphin file manager extensions
# echo "📁 Installing Dolphin file manager..."
# dnf install -y dolphin dolphin-plugins

# Install VLC (media player)
echo "🎬 Installing VLC..."
dnf install -y vlc

# Install build essentials for development
echo "🔨 Installing development tools..."
dnf install -y gcc g++ make cmake

# Install Java Development Kit
# echo "☕ Installing Java (OpenJDK)..."
# dnf install -y java-latest-openjdk java-latest-openjdk-devel

echo ""
echo "============================================"
echo "Installation Complete!"
echo "============================================"
echo ""
echo "Installed versions:"
echo "-------------------"
python3 --version
node --version
npm --version
git --version
java -version 2>&1 | head -2
echo ""
echo "📝 Notes:"
echo "- Docker service is now enabled and running"
echo "- You may need to logout and login for docker group membership to take effect"
echo "- VS Code can be launched with 'code' command"
echo "- Use '7z' command for 7-Zip archive operations"
echo "- Python pip packages can be installed with 'pip3' or 'python3 -m pip'"
echo "- Node.js packages can be installed with 'npm' or 'yarn'"
echo ""
echo "🎉 Setup completed successfully!"
