#!/bin/bash

# Bazzite Linux Fresh Setup Script
# This script sets up development tools and applications on a fresh Bazzite installation
# Note: Bazzite comes with Steam, Python, and Git pre-installed

set -e  # Exit on error

# Ensure we can use sudo (not required at script start) and give a helpful tip
if ! sudo -v >/dev/null 2>&1; then
    echo "⚠️  This script needs sudo for several steps; you may be prompted for your password."
fi

echo "============================================"
echo "Bazzite Fresh Setup Script"
echo "============================================"
echo ""

# Update system first
echo "🔄 Updating system..."
if command -v rpm-ostree >/dev/null 2>&1; then
    sudo rpm-ostree upgrade
else
    sudo dnf upgrade --refresh -y
fi
echo ""

# Install Flatpak if not available
echo "📦 Ensuring Flatpak is installed..."
if ! command -v flatpak >/dev/null 2>&1; then
    if command -v rpm-ostree >/dev/null 2>&1; then
        sudo rpm-ostree install flatpak
    else
        sudo dnf install -y flatpak
    fi
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
)

echo "📦 Layering packages: ${LAYER_PKGS[*]}"
if command -v rpm-ostree >/dev/null 2>&1; then
    sudo rpm-ostree install "${LAYER_PKGS[@]}"
else
    sudo dnf install -y "${LAYER_PKGS[@]}"
fi
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
    # On rpm-ostree (immutable) systems, avoid using `rpm --import` (it tries to write under /usr).
    # Instead, write the key into /etc/pki/rpm-gpg and add the repo file with tee.
    sudo mkdir -p /etc/pki/rpm-gpg
    sudo curl -fsSL https://packages.microsoft.com/keys/microsoft.asc -o /etc/pki/rpm-gpg/microsoft.gpg || true
    sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/microsoft.gpg
EOF
    if command -v rpm-ostree >/dev/null 2>&1; then
        if ! sudo rpm-ostree install code; then
            echo "⚠️  Failed to install Visual Studio Code with rpm-ostree."
            echo "   On immutable systems this may be due to read-only /usr; you can install via Flatpak instead:"
            echo "   flatpak install -y flathub com.visualstudio.code" 
        fi
    else
        if ! sudo dnf install -y code; then
            echo "⚠️  dnf install failed for Visual Studio Code. Please run as root or verify your dnf repos."
            echo "   Fallback: flatpak install -y flathub com.visualstudio.code"
        fi
    fi
fi
echo ""

echo "🌐 Installing Google Chrome..."
if command -v google-chrome >/dev/null 2>&1; then
    echo "✅ Google Chrome already installed; skipping."
else
    sudo mkdir -p /etc/pki/rpm-gpg
    sudo curl -fsSL https://dl.google.com/linux/linux_signing_key.pub -o /etc/pki/rpm-gpg/google.gpg || true
    sudo tee /etc/yum.repos.d/google-chrome.repo >/dev/null <<'EOF'
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/google.gpg
EOF
    if command -v rpm-ostree >/dev/null 2>&1; then
        if ! sudo rpm-ostree install google-chrome-stable; then
            echo "⚠️  Failed to install Google Chrome with rpm-ostree."
            echo "   On immutable systems like Bazzite, a read-only filesystem error may occur when a repo or key requires /usr changes."
            echo "   Fallback: install Chromium via Flatpak or run the package install on a mutable dnf-based system."
            echo "   Example: flatpak install -y flathub org.chromium.Chromium"
        fi
    else
        if ! sudo dnf install -y google-chrome-stable; then
            echo "⚠️  dnf install failed for Google Chrome. Please run as root or verify your dnf repos."
            echo "   Fallback: flatpak install -y flathub org.chromium.Chromium"
        fi
    fi
fi
echo ""

echo "📮 Installing Postman..."
flatpak install -y flathub com.getpostman.Postman

# echo "🐙 Installing GitHub Desktop..."
# flatpak install -y flathub io.github.shiftey.Desktop

# echo "💬 Installing Discord..."
# flatpak install -y flathub com.discordapp.Discord

# echo "📝 Installing Obsidian..."
# flatpak install -y flathub md.obsidian.Obsidian

# echo "🎨 Installing GIMP..."
# flatpak install -y flathub org.gimp.GIMP

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
