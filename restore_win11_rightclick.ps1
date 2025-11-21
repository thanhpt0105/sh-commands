# PowerShell Script to restore Windows 11 right-click context menu
# Run with: powershell -ExecutionPolicy Bypass -File restore_win11_rightclick.ps1
# Or run as Administrator: Set-ExecutionPolicy Bypass -Scope Process -Force; .\restore_win11_rightclick.ps1

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Restore Windows 11 Right-Click Menu" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Check if running on Windows 11
$osVersion = [System.Environment]::OSVersion.Version
if ($osVersion.Build -lt 22000) {
    Write-Host "This script is for Windows 11 only." -ForegroundColor Yellow
    Write-Host "   Your system appears to be Windows 10 or earlier." -ForegroundColor Yellow
    Write-Host ""
    exit
}

Write-Host "🖱️  Restoring Windows 11 right-click context menu..." -ForegroundColor Green
Write-Host ""

# Delete registry key to restore Windows 11 context menu
try {
    reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
    Write-Host "Registry key removed successfully!" -ForegroundColor Green
} catch {
    Write-Host "Failed to remove registry key." -ForegroundColor Red
    Write-Host "   Error: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔄 Restarting Windows Explorer to apply changes..." -ForegroundColor Green

try {
    Stop-Process -Name explorer -Force
    Start-Sleep -Seconds 2
    Write-Host "Windows Explorer restarted successfully!" -ForegroundColor Green
} catch {
    Write-Host "Please restart Windows Explorer manually or restart your computer." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "The Windows 11 right-click menu has been restored." -ForegroundColor Green
Write-Host ""
Write-Host "💡 To switch back to Windows 10 menu, run:" -ForegroundColor Yellow
Write-Host "   .\restore_win10_rightclick.ps1" -ForegroundColor White
Write-Host ""
