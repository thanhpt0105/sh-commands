#!/bin/bash

# Script to set up a fresh Mac with essential applications
# Run with: bash setup_mac.sh

set -e  # Exit on error

echo "============================================"
echo "Mac Setup Script"
echo "============================================"
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null
then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew already installed"
fi

echo ""
echo "📦 Updating Homebrew..."
brew update

echo ""
echo "============================================"
echo "Installing Applications"
echo "============================================"
echo ""

# Install Google Chrome
echo "🌐 Installing Google Chrome..."
brew install --cask google-chrome

# Install p7zip (7-Zip for macOS)
echo "📦 Installing p7zip (7-Zip)..."
brew install p7zip

# Install Python (latest version)
echo "🐍 Installing Python (latest)..."
brew install python

# Install Node.js (latest version)
echo "📗 Installing Node.js (latest)..."
brew install node

# Install Visual Studio Code
echo "💻 Installing Visual Studio Code..."
brew install --cask visual-studio-code

# Install GitHub Desktop
echo "🐙 Installing GitHub Desktop..."
brew install --cask github

# Install Postman
echo "📮 Installing Postman..."
brew install --cask postman

# Install Docker & Docker Desktop
echo "🐳 Installing Docker Desktop..."
brew install --cask docker

# Install Rectangle (window management app)
echo "🪟 Installing Rectangle..."
brew install --cask rectangle

# Install OpenKey (Vietnamese keyboard)
echo "⌨️  Installing OpenKey..."
brew install --cask openkey

# Install Microsoft Office
echo "📊 Installing Microsoft Office..."
brew install --cask microsoft-office

echo ""
echo "============================================"
echo "Installation Complete!"
echo "============================================"v
echo ""
echo "Installed versions:"
echo "-------------------"
python3 --version
node --version
npm --version
echo ""
echo "📝 Notes:"
echo "- Docker Desktop needs to be opened manually for the first time"
echo "- Rectangle will appear in your menu bar after launch"
echo "- OpenKey can be configured in System Preferences"
echo "- Microsoft Office apps will be available in your Applications folder"
echo "- VS Code command 'code' should be available in terminal"
echo "- GitHub Desktop and Postman are ready to use from Applications"
echo "- Use '7z' command for 7-Zip archive operations"
echo ""
echo "🎉 Setup completed successfully!"
