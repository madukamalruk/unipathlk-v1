# UniPath LK Vercel local runner
$ErrorActionPreference = 'Stop'
$env:PYTHONIOENCODING = 'utf-8'
Set-Location -LiteralPath $PSScriptRoot
Write-Host 'Starting UniPath LK Vercel local runner on http://localhost:8000 ...' -ForegroundColor Cyan
& .venv\Scripts\python.exe api\index.py
