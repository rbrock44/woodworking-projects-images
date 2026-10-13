<#
.SYNOPSIS
    Creates 900x1200 pixel .webp copies of .jpg images that don't already have them.

.DESCRIPTION
    This script:
    - Accepts an optional directory path as a parameter.
    - Uses one directory back from the current script location if no path is provided.
    - Recursively scans for .jpg files in all directories and subdirectories, skipping thumbnails.
    - For each .jpg file, checks if a corresponding mid-size image (e.g., "20250430_1716-900x1200.webp") exists.
    - If none exists, creates a 900x1200 .webp copy with the appropriate naming convention.
    - Uses ImageMagick to resize and convert images.

    The website shows the mid-size image in its single image view, so a page loads ~200KB
    instead of the ~1-2MB original. The original is still used for the full screen view.

.PARAMETER DirectoryPath
    Optional. The path to the directory to scan for images.
    If not provided, the script uses one directory back from its current location.

.EXAMPLE
    .\create-midsize-images.ps1
    Runs in the parent directory of where the script is located.

.EXAMPLE
    .\create-midsize-images.ps1 -DirectoryPath "C:\Photos"
    Runs in the specified directory and all subdirectories.

.NOTES
    Requires ImageMagick (magick) with WebP support.
    Only processes files with .jpg extension.
    Creates images with "-900x1200" suffix and a .webp extension.
#>

param (
    [string]$DirectoryPath = (Split-Path $PSScriptRoot -Parent)
)

# Ensure the path exists
if (-not (Test-Path $DirectoryPath)) {
    Write-Error "Directory does not exist: $DirectoryPath"
    exit 1
}

# Ensure ImageMagick is installed
if (-not (Get-Command magick -ErrorAction SilentlyContinue)) {
    Write-Error "ImageMagick (magick) is not installed or not on PATH"
    exit 1
}

# Function to create mid-size image
function Create-MidsizeImage {
    param (
        [string]$SourcePath,
        [string]$DestinationPath,
        [int]$Width = 900,
        [int]$Height = 1200
    )

    & magick $SourcePath -auto-orient -resize "$($Width)x$($Height)" -strip -quality 80 $DestinationPath
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Failed to create mid-size image for $SourcePath"
        return $false
    }

    return $true
}

# Get all .jpg files recursively
Write-Host "Scanning for .jpg files in: $DirectoryPath"
$files = Get-ChildItem -Path $DirectoryPath -File -Filter "*.jpg" -Recurse

$processedCount = 0
$skippedCount = 0
$errorCount = 0

foreach ($file in $files) {
    # Skip thumbnails (contain "-150x200")
    if ($file.BaseName -match '-150x200$') {
        continue
    }

    # Create the expected mid-size name
    $midsizeName = "$($file.BaseName)-900x1200.webp"
    $midsizePath = Join-Path $file.DirectoryName $midsizeName

    # Check if mid-size image already exists
    if (Test-Path $midsizePath) {
        $skippedCount++
        continue
    }

    # Create the mid-size image
    Write-Host "Creating mid-size image for '$($file.Name)'..."
    if (Create-MidsizeImage -SourcePath $file.FullName -DestinationPath $midsizePath) {
        Write-Host "  Created: $midsizeName"
        $processedCount++
    } else {
        $errorCount++
    }
}

# Summary
Write-Host "`n--- Summary ---"
Write-Host "Files processed: $processedCount"
Write-Host "Files skipped (mid-size image exists): $skippedCount"
Write-Host "Errors: $errorCount"

if ($errorCount -gt 0) {
    exit 1
}
