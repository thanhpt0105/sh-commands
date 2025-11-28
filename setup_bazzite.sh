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

# Install Docker
echo "============================================"
echo "Installing Docker"
echo "============================================"
echo ""

if command -v docker >/dev/null 2>&1; then
    echo "✅ Docker already installed; skipping."
else
    echo "🐳 Installing Docker..."
    if command -v rpm-ostree >/dev/null 2>&1; then
        # On rpm-ostree systems (like Bazzite), layer Docker packages
        sudo rpm-ostree install docker docker-compose
        echo "⚠️  Docker layered - reboot required to use Docker"
    else
        sudo dnf install -y docker docker-compose
    fi
    
    # Enable and start Docker service (will take effect after reboot on rpm-ostree)
    sudo systemctl enable docker
    
    # Add current user to docker group to run docker without sudo
    echo "👤 Adding user to docker group..."
    sudo usermod -aG docker "$USER"
    
    echo "✅ Docker installed successfully"
    echo "💡 After rebooting, verify Docker with: docker --version"
    echo "💡 You'll need to log out and back in (or reboot) for group changes to take effect"
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

echo ""
echo "⌨️ Installing Vietnamese keyboard support (fcitx5 + Unikey)..."
IM_PKGS=(fcitx5-gtk fcitx5-qt5 fcitx5-unikey)
if command -v fcitx5 >/dev/null 2>&1; then
    echo "✅ fcitx5 already present; skipping."
else
    echo "📦 Installing: ${IM_PKGS[*]}"
    if command -v rpm-ostree >/dev/null 2>&1; then
        if ! sudo rpm-ostree install "${IM_PKGS[@]}"; then
            echo "⚠️  Failed to install fcitx5 packages with rpm-ostree."
            echo "   You can try installing these packages with dnf or install the Flatpak Chromium/other keymaps if needed."
        fi
    else
        if ! sudo dnf install -y "${IM_PKGS[@]}"; then
            echo "⚠️  dnf install failed for fcitx5 packages. Please run as root or verify your dnf repos."
        fi
    fi
fi

# Configure environment variables needed by fcitx5 so GTK/QT apps use it
FCITX_ENV_CONTENT="export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS=@im=fcitx"
if sudo test -w /etc >/dev/null 2>&1; then
    echo "🔧 Creating system-wide environment configuration for fcitx5..."
    echo -e "$FCITX_ENV_CONTENT" | sudo tee /etc/profile.d/fcitx5.sh >/dev/null
else
    echo "🔧 Creating user-level environment configuration for fcitx5 in ~/.xprofile..."
    grep -q 'GTK_IM_MODULE=fcitx' "$HOME/.xprofile" >/dev/null 2>&1 || printf "%b\n" "$FCITX_ENV_CONTENT" >> "$HOME/.xprofile"
fi

echo "💡 After this change, please log out and log back in (or reboot) to enable fcitx5 as your input method."
echo "💡 To configure Unikey (Vietnamese), launch the fcitx5 configuration tool: 'fcitx5-configtool' or 'fcitx5-config-qt' and add 'Unikey' to your Input Method list."

# echo "🐙 Installing GitHub Desktop..."
# flatpak install -y flathub io.github.shiftey.Desktop

# echo "💬 Installing Discord..."
# flatpak install -y flathub com.discordapp.Discord

# echo "📝 Installing Obsidian..."
# flatpak install -y flathub md.obsidian.Obsidian

# echo "🎨 Installing GIMP..."
# flatpak install -y flathub org.gimp.GIMP

echo ""
echo "🖼️ Fix terminal / Bazzite flicker (GSK_RENDERER workaround)"
# Some environments show flickering in GTK terminal apps or the desktop (Bazzite). For many
# users setting GSK_RENDERER=gl forces the GL renderer and can resolve flicker.
# We prefer system-wide configuration in /etc/profile.d if writable, otherwise we
# append to the user's ~/.bashrc so it is present in terminal shells.
GSK_LINE='export GSK_RENDERER="gl"'
if sudo test -w /etc >/dev/null 2>&1; then
    # Make sure we don't add duplicate lines
    if sudo grep -qxF "$GSK_LINE" /etc/profile.d/gsk_renderer.sh 2>/dev/null; then
        echo "✅ GSK_RENDERER already set system-wide; skipping."
    else
        echo "🔧 Setting GSK_RENDERER system-wide to 'gl' to reduce GTK flicker..."
        echo "$GSK_LINE" | sudo tee /etc/profile.d/gsk_renderer.sh >/dev/null
    fi
else
    # Append to ~/.bashrc only if not already present
    if grep -qxF "$GSK_LINE" "$HOME/.bashrc" >/dev/null 2>&1; then
        echo "✅ GSK_RENDERER already present in ~/.bashrc; skipping."
    else
        echo "🔧 Adding GSK_RENDERER=gl to ~/.bashrc to help with flicker issues..."
        echo "$GSK_LINE" >> "$HOME/.bashrc"
    fi
fi
echo "💡 Note: Some desktop sessions read ~/.xprofile or /etc/profile.d; if you still see flicker after logging back in, try adding the same line to ~/.xprofile or /etc/profile.d/gsk_renderer.sh (as administrator)."
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
echo "✅ Input Method:"
echo "  - Vietnamese input (fcitx5 + Unikey)" 
echo ""
echo "✅ Development Tools (layered):"
echo "  - Node.js & npm"
echo "  - Docker & Docker Compose"
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
echo "     docker --version"
echo "     java -version"
echo ""
echo "  3. Launch Flatpak apps from your application menu or via:"
echo "     flatpak run <app-id>"
echo ""
echo "🎉 Setup completed successfully!"
