<#
.SYNOPSIS
    Creates 150x200 pixel thumbnails for .jpg images that don't already have corresponding thumbnails.

.DESCRIPTION
    This script:
    - Accepts an optional directory path as a parameter.
    - Uses one directory back from the current script location if no path is provided.
    - Recursively scans for .jpg files in all directories and subdirectories.
    - For each .jpg file, checks if a corresponding thumbnail (e.g., "20250430_1716-150x200.jpg") exists.
    - If no thumbnail exists, creates a 150x200 pixel copy with the appropriate naming convention.
    - Uses .NET System.Drawing to resize images.

.PARAMETER DirectoryPath
    Optional. The path to the directory to scan for images.
    If not provided, the script uses one directory back from its current location.

.EXAMPLE
    .\create-thumbnails.ps1
    Runs in the parent directory of where the script is located.

.EXAMPLE
    .\create-thumbnails.ps1 -DirectoryPath "C:\Photos"
    Runs in the specified directory and all subdirectories.

.NOTES
    Requires .NET Framework with System.Drawing support.
    Only processes files with .jpg extension.
    Creates thumbnails with "-150x200" suffix before the file extension.
#>

param (
    [string]$DirectoryPath = (Split-Path $PSScriptRoot -Parent)
)

# Load required assemblies for image processing
Add-Type -AssemblyName System.Drawing

# Ensure the path exists
if (-not (Test-Path $DirectoryPath)) {
    Write-Error "Directory does not exist: $DirectoryPath"
    exit 1
}

# Function to create thumbnail
function Create-Thumbnail {
    param (
        [string]$SourcePath,
        [string]$DestinationPath,
        [int]$Width = 200,
        [int]$Height = 150
    )

    try {
        # Load the original image
        $originalImage = [System.Drawing.Image]::FromFile($SourcePath)

        # Create a new bitmap with the desired dimensions
        $thumbnail = New-Object System.Drawing.Bitmap($Width, $Height)

        # Create graphics object for drawing
        $graphics = [System.Drawing.Graphics]::FromImage($thumbnail)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

        # Draw the resized image
        $graphics.DrawImage($originalImage, 0, 0, $Width, $Height)

        # Save the thumbnail
        $thumbnail.Save($DestinationPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)

        # Clean up resources
        $graphics.Dispose()
        $thumbnail.Dispose()
        $originalImage.Dispose()

        return $true
    }
    catch {
        Write-Warning "Failed to create thumbnail for $SourcePath`: $($_.Exception.Message)"
        return $false
    }
}

# Get all .jpg files recursively
Write-Host "Scanning for .jpg files in: $DirectoryPath"
$files = Get-ChildItem -Path $DirectoryPath -File -Filter "*.jpg" -Recurse

$processedCount = 0
$skippedCount = 0
$errorCount = 0

foreach ($file in $files) {
    # Skip files that are already thumbnails (contain "-150x200")
    if ($file.BaseName -match '-150x200$') {
        continue
    }

    # Create the expected thumbnail name
    $thumbnailName = "$($file.BaseName)-150x200$($file.Extension)"
    $thumbnailPath = Join-Path $file.DirectoryName $thumbnailName

    # Check if thumbnail already exists
    if (Test-Path $thumbnailPath) {
        Write-Host "Thumbnail already exists for '$($file.Name)' - skipping"
        $skippedCount++
        continue
    }

    # Create the thumbnail
    Write-Host "Creating thumbnail for '$($file.Name)'..."
    if (Create-Thumbnail -SourcePath $file.FullName -DestinationPath $thumbnailPath) {
        Write-Host "  Created: $thumbnailName"
        $processedCount++
    } else {
        $errorCount++
    }
}

# Summary
Write-Host "`n--- Summary ---"
Write-Host "Files processed: $processedCount"
Write-Host "Files skipped (thumbnail exists): $skippedCount"
Write-Host "Errors: $errorCount"
Write-Host "Total .jpg files found: $($files.Count)"
