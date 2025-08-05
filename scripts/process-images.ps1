# All operations happen inside /script
$scriptDir = $PSScriptRoot
$not43File = Join-Path $scriptDir "not_3_by_4.txt"

# Helper function to run a child script and stream its output
function Run-Script($name) {
    $scriptPath = Join-Path $scriptDir $name
    Write-Host ""
    Write-Host "Running $name..."
    & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Script failed: $name"
        exit $LASTEXITCODE
    }
}

# Step 1: Find not 4:3 images
Run-Script "find_not_3_by_4_aspect_ratio.ps1"

# Step 2: If not_3_by_4.txt exists, fix and delete
if (Test-Path $not43File) {
    Run-Script "fix_not_3_by_4.ps1"
    try {
        Remove-Item $not43File -Force
        Write-Host "Deleted $not43File"
    } catch {
        Write-Error "Failed to delete $not43File"
        exit 1
    }
} else {
    Write-Host "No images need fixing - not_3_by_4.txt not found."
}

# Step 3: Create thumbnails
Run-Script "create-thumbnails.ps1"

Write-Host ""
Write-Host "All steps completed successfully."