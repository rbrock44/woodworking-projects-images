<#
.SYNOPSIS
    Compresses all PNG and JPG images in a given folder using the TinyPNG API.

.DESCRIPTION
    - Accepts an optional directory path (defaults to the current script location).
    - Creates a "-tiny" version of the directory to store compressed images.
    - Uses TinyPNG's API to compress each image.
    - Skips files that are not .jpg/.jpeg/.png.

.PARAMETER DirectoryPath
    Optional. The path to the directory containing image files.

.EXAMPLE
    .\compress-tinypng.ps1
    Compresses files in the script's location.

.EXAMPLE
    .\compress-tinypng.ps1 -DirectoryPath "C:\Users\rbroc\Downloads\Wood2"
    Creates "Wood2-tiny" and compresses images into it.

.NOTES
    Requires a valid TinyPNG API key.
#>

param (
    [string]$DirectoryPath = $PSScriptRoot
)

# Your TinyPNG API Key
$apiKey = "YOUR_API_KEY_HERE"

# Validate API key
if ($apiKey -eq "YOUR_API_KEY_HERE") {
    Write-Error "Please set your TinyPNG API key in the script."
    exit 1
}

# Make sure the path exists
if (-not (Test-Path $DirectoryPath)) {
    Write-Error "Directory does not exist: $DirectoryPath"
    exit 1
}

# Create target output folder
$parent = Split-Path $DirectoryPath -Parent
$folderName = Split-Path $DirectoryPath -Leaf
$outputDir = Join-Path $parent "$folderName-tiny"

if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Get .jpg and .png files
$files = Get-ChildItem -Path $DirectoryPath -File | Where-Object {
    $_.Extension -match '\.(jpg|jpeg|png)$'
}

# Encode API key for Basic Auth
$base64Auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$apiKey"))

foreach ($file in $files) {
    Write-Host "Compressing $($file.Name)..."

    $imageBytes = [System.IO.File]::ReadAllBytes($file.FullName)

    try {
        # Upload image to TinyPNG
        $uploadResponse = Invoke-RestMethod -Uri "https://api.tinify.com/shrink" `
                                            -Method Post `
                                            -Headers @{ Authorization = "Basic $base64Auth" } `
                                            -Body $imageBytes `
                                            -ContentType "application/octet-stream"

        # Download compressed image
        $compressedUrl = $uploadResponse.output.url
        $outputPath = Join-Path $outputDir $file.Name

        Invoke-WebRequest -Uri $compressedUrl -OutFile $outputPath

        Write-Host "Saved to: $outputPath"
    }
    catch {
        Write-Warning "Failed to compress $($file.Name): $_"
    }
}
