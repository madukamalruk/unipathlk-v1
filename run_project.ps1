# UniPath LK local launcher. Server settings are loaded only inside the server.
$ErrorActionPreference = 'Stop'
$env:PYTHONIOENCODING = 'utf-8'
Set-Location -LiteralPath $PSScriptRoot
$localJac = Join-Path $PSScriptRoot '.venv\Scripts\jac.exe'
if (-not (Test-Path -LiteralPath $localJac)) {
    if (-not (Get-Command uv -ErrorAction SilentlyContinue)) { throw 'Install uv, then follow README.md to create the pinned Python 3.12 environment.' }
    uv venv --python 3.12 .venv
    if ($LASTEXITCODE -ne 0) { throw 'Could not create the Python 3.12 environment.' }
    uv pip install --python .venv\Scripts\python.exe -r requirements.txt
    if ($LASTEXITCODE -ne 0) { throw 'Dependency installation failed.' }
}
& $localJac check main.jac --nowarn
if ($LASTEXITCODE -ne 0) { throw 'Jac check failed. Resolve diagnostics before starting.' }
Write-Host 'Open http://localhost:8000 after the server reports ready.'
& $localJac start main.jac --port 8000
