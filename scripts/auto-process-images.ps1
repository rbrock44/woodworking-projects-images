param(
    [int]$Year = (Get-Date).Year,
    [Parameter(Mandatory=$true)]
    [string]$Name,
    [Parameter(Mandatory=$true)]
    [string]$DirectoryPath,
    [string]$RepoPath = "C:\workspace\woodworking-projest-images"
)

$scriptDir = $PSScriptRoot

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

# Helper function to run a child script with parameters
function Run-ScriptWithParams($name, $params) {
    $scriptPath = Join-Path $scriptDir $name
    Write-Host ""
    Write-Host "Running $name with parameters: $params"
    & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath @params
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Script failed: $name"
        exit $LASTEXITCODE
    }
}

Write-Host "Starting processing with parameters:"
Write-Host "Year: $Year"
Write-Host "Name: $Name"
Write-Host "DirectoryPath: $DirectoryPath"
Write-Host "RepoPath: $RepoPath"

# Step 1: Run pre-process-images.ps1 with DirectoryPath parameter
Run-ScriptWithParams "pre-process-images.ps1" @{DirectoryPath = $DirectoryPath}

# Step 2: Move contents from DirectoryPath to RepoPath-tiny/Year/Name
$destinationPath = Join-Path "$RepoPath-tiny" "$Year\$Name"
Write-Host ""
Write-Host "Moving contents from '$DirectoryPath' to '$destinationPath'..."

# Create destination directory if it doesn't exist
if (-not (Test-Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath -Force | Out-Null
    Write-Host "Created destination directory: $destinationPath"
}

# Move all contents from source to destination
try {
    Get-ChildItem -Path $DirectoryPath -Force | Move-Item -Destination $destinationPath -Force
    Write-Host "Successfully moved contents to destination directory"
} catch {
    Write-Error "Failed to move contents: $_"
    exit 1
}

# Step 3: Run process-images.ps1
Run-Script "process-images.ps1"

# Step 4: Prompt user for JSON generation
Write-Host ""
$response = Read-Host "Generate JSON for the project? (y/yes or n/no)"

if ($response -eq "y" -or $response -eq "yes") {
    Write-Host "Generating JSON..."
    Run-ScriptWithParams "generate-json.ps1" @{Year = $Year; Name = $Name}
} else {
    Write-Host "Skipping JSON generation."
}

Write-Host ""
Write-Host "Processing completed successfully!"