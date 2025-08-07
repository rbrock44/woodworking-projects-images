param (
    [Parameter(Mandatory=$true)]
    [string]$DirectoryPath
)

$scriptDir = $PSScriptRoot

function Run-Script($name) {
    $scriptPath = Join-Path $scriptDir $name
    Write-Host ""
    Write-Host "Running $name..."
    & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -DirectoryPath $DirectoryPath
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Script failed: $name"
        exit $LASTEXITCODE
    }
}

# Step 1: Rename PXL files
Run-Script "rename-pxl-files.ps1"

# Step 2: Compress with TinyPNG
Run-Script "compress-tinypng.ps1"

Write-Host ""
Write-Host "All steps completed successfully."
