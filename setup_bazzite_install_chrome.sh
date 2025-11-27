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