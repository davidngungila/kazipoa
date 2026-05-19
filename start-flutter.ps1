# Flutter development PowerShell script
Write-Host "Starting Flutter development..." -ForegroundColor Green

# Set Node.js path
$env:PATH = "C:\Program Files\nodejs;" + $env:PATH

# Change to Flutter directory
Set-Location "kazipoa_fixed"

# Start Flutter development
npm run dev

Write-Host "Flutter development started!" -ForegroundColor Cyan
