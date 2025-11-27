#!/bin/bash

# Bazzite Linux Fresh Setup Script
# This script sets up development tools and applications on a fresh Bazzite installation
# Note: Bazzite comes with Steam, Python, and Git pre-installed

set -e  # Exit on error

echo "============================================"
echo "Bazzite Fresh Setup Script"
echo "============================================"
echo ""

# Update system first
echo "🔄 Updating system..."
rpm-ostree upgrade
echo ""

# Install Flatpak if not available
echo "📦 Ensuring Flatpak is installed..."
if ! command -v flatpak >/dev/null 2>&1; then
    rpm-ostree install flatpak
    echo "⚠️  Flatpak installed - you may need to reboot before installing Flatpak apps"
fi
echo ""

# Ensure Flathub is enabled
echo "📦 Ensuring Flathub repository is enabled..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo ""

# Install development tools via rpm-ostree (requires reboot)
echo "============================================"
echo "Installing Development Tools"
echo "============================================"
echo ""

LAYER_PKGS=(
    nodejs
    npm
    gcc
    gcc-c++
    make
    cmake
    java-latest-openjdk
    vim
    neovim
)

echo "📦 Layering packages: ${LAYER_PKGS[*]}"
rpm-ostree install "${LAYER_PKGS[@]}"
echo ""

# Install GUI applications via Flatpak
echo "============================================"
echo "Installing GUI Applications"
echo "============================================"
echo ""

echo "💻 Installing Visual Studio Code..."
if command -v code >/dev/null 2>&1; then
    echo "✅ VS Code already installed; skipping."
else
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    rpm-ostree install code
fi
echo ""

echo "🌐 Installing Google Chrome..."
if command -v google-chrome >/dev/null 2>&1; then
    echo "✅ Google Chrome already installed; skipping."
else
    sudo rpm --import https://dl.google.com/linux/linux_signing_key.pub
    sudo sh -c 'echo -e "[google-chrome]\nname=google-chrome\nbaseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64\nenabled=1\ngpgcheck=1\ngpgkey=https://dl.google.com/linux/linux_signing_key.pub" > /etc/yum.repos.d/google-chrome.repo'
    rpm-ostree install google-chrome-stable
fi
echo ""

echo "📮 Installing Postman..."
flatpak install -y flathub com.getpostman.Postman

echo "🐙 Installing GitHub Desktop..."
flatpak install -y flathub io.github.shiftey.Desktop

echo "💬 Installing Discord..."
flatpak install -y flathub com.discordapp.Discord

echo "📝 Installing Obsidian..."
flatpak install -y flathub md.obsidian.Obsidian

echo "🎨 Installing GIMP..."
flatpak install -y flathub org.gimp.GIMP

echo ""
echo "============================================"
echo "Setup Complete!"
echo "============================================"
echo ""
echo "✅ Installed Applications:"
echo "  - Visual Studio Code"
echo "  - Google Chrome"
echo "  - Postman"
echo "  - GitHub Desktop"
echo "  - Discord"
echo "  - Obsidian"
echo "  - GIMP"
echo ""
echo "✅ Development Tools (layered):"
echo "  - Node.js & npm"
echo "  - GCC/G++ compiler"
echo "  - Make & CMake"
echo "  - Java (OpenJDK)"
echo "  - Vim & Neovim"
echo ""
echo "📝 Next Steps:"
echo "  1. Reboot your system to apply rpm-ostree changes:"
echo "     sudo systemctl reboot"
echo ""
echo "  2. After reboot, verify installations:"
echo "     node --version"
echo "     npm --version"
echo "     java -version"
echo ""
echo "  3. Launch Flatpak apps from your application menu or via:"
echo "     flatpak run <app-id>"
echo ""
echo "🎉 Setup completed successfully!"
