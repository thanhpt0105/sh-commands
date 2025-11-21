# Shell Scripts

A collection of useful shell scripts for setting up development environments.

## Scripts

- `setup_mac.sh` - Automated setup script for macOS development environment
- `setup_windows.ps1` - Automated setup script for Windows development environment
- `restore_win10_rightclick.ps1` - Restore Windows 10 right-click menu on Windows 11
- `restore_win11_rightclick.ps1` - Restore Windows 11 right-click menu (revert to default)

## Usage

### macOS

Make script executable before running:

```bash
chmod +x setup_mac.sh
./setup_mac.sh
```

### Windows

Run in PowerShell as Administrator:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\setup_windows.ps1
```

## Description

This repository contains shell scripts to automate the installation and configuration of development tools, applications, and system settings across different environments.
