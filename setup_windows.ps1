# PowerShell Script to set up a fresh Windows PC with essential applications
# Run with: powershell -ExecutionPolicy Bypass -File setup_windows.ps1
# Or run as Administrator: Set-ExecutionPolicy Bypass -Scope Process -Force; .\setup_windows.ps1

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Windows Setup Script" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "⚠️  Warning: Not running as Administrator. Some installations may fail." -ForegroundColor Yellow
    Write-Host "   Please run PowerShell as Administrator for best results." -ForegroundColor Yellow
    Write-Host ""
}

# Check if Chocolatey is installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Installing Chocolatey..." -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
} else {
    Write-Host "✅ Chocolatey already installed" -ForegroundColor Green
}

Write-Host ""
Write-Host "📦 Updating Chocolatey..." -ForegroundColor Green
choco upgrade chocolatey -y

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Installing Applications" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Restore Windows 10 right-click context menu
Write-Host "🖱️  Restoring Windows 10 right-click menu..." -ForegroundColor Green
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
Write-Host "✅ Windows 10 right-click menu enabled (requires Explorer restart)" -ForegroundColor Green

Write-Host ""

# Install Git
Write-Host "🔧 Installing Git..." -ForegroundColor Green
choco install git -y

# Install Google Chrome
Write-Host "🌐 Installing Google Chrome..." -ForegroundColor Green
choco install googlechrome -y

# Install 7-Zip
Write-Host "📦 Installing 7-Zip..." -ForegroundColor Green
choco install 7zip -y

# Install Notepad++
Write-Host "📝 Installing Notepad++..." -ForegroundColor Green
choco install notepadplusplus -y

# Install Python (latest version)
Write-Host "🐍 Installing Python (latest)..." -ForegroundColor Green
choco install python -y

# Install Node.js (latest version)
Write-Host "📗 Installing Node.js (latest)..." -ForegroundColor Green
choco install nodejs -y

# Install Visual Studio Code
Write-Host "💻 Installing Visual Studio Code..." -ForegroundColor Green
choco install vscode -y

# Install GitHub Desktop
Write-Host "🐙 Installing GitHub Desktop..." -ForegroundColor Green
choco install github-desktop -y

# Install Postman
Write-Host "📮 Installing Postman..." -ForegroundColor Green
choco install postman -y

# Install Docker Desktop
Write-Host "🐳 Installing Docker Desktop..." -ForegroundColor Green
choco install docker-desktop -y

# Install PowerToys (window management and utilities)
Write-Host "🔧 Installing PowerToys..." -ForegroundColor Green
choco install powertoys -y

# Install Unikey (Vietnamese keyboard)
Write-Host "⌨️  Installing Unikey..." -ForegroundColor Green
choco install unikey -y

# Install Discord
Write-Host "💬 Installing Discord..." -ForegroundColor Green
choco install discord -y

# Install Steam
Write-Host "🎮 Installing Steam..." -ForegroundColor Green
choco install steam -y

# Install Microsoft Office (requires license)
Write-Host "📊 Installing Microsoft Office 365..." -ForegroundColor Green
choco install microsoft-office-deployment -y

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Finalizing Setup" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Restart Windows Explorer to apply right-click menu changes
Write-Host "🔄 Restarting Windows Explorer to apply changes..." -ForegroundColor Green
Stop-Process -Name explorer -Force
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Installation Complete!" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Refresh environment to get new PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "Installed versions:" -ForegroundColor Yellow
Write-Host "-------------------" -ForegroundColor Yellow
if (Get-Command git -ErrorAction SilentlyContinue) { git --version }
if (Get-Command python -ErrorAction SilentlyContinue) { python --version }
if (Get-Command node -ErrorAction SilentlyContinue) { node --version }
if (Get-Command npm -ErrorAction SilentlyContinue) { npm --version }

Write-Host ""
Write-Host "📝 Notes:" -ForegroundColor Yellow
Write-Host "- Windows 10 right-click menu has been restored" -ForegroundColor White
Write-Host "- Docker Desktop needs to be opened manually for the first time" -ForegroundColor White
Write-Host "- PowerToys can be configured from the Start menu" -ForegroundColor White
Write-Host "- Unikey can be configured from the system tray" -ForegroundColor White
Write-Host "- Microsoft Office apps will be available in your Start menu" -ForegroundColor White
Write-Host "- VS Code command 'code' should be available in terminal (restart terminal if needed)" -ForegroundColor White
Write-Host "- GitHub Desktop and other GUI apps are ready to use from the Start menu" -ForegroundColor White
Write-Host "- Steam will need to log in on first launch" -ForegroundColor White
Write-Host "- You may need to restart your computer for all changes to take effect" -ForegroundColor White
Write-Host ""
Write-Host "🎉 Setup completed successfully!" -ForegroundColor Green
