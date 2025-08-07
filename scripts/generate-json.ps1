<#
.SYNOPSIS
    Generates a JSON metadata blob for original (non-thumbnail) images in a given year/name directory.

.DESCRIPTION
    This script:
    - Accepts a 4-digit year and a dash-separated name as parameters (e.g., "lathe-estate-sale").
    - Automatically determines the base project directory as one level above the script's location.
    - Scans the corresponding image directory (basePath/year/name) for .jpg files.
    - Filters out thumbnail images (those ending in "-150x200.jpg").
    - Creates a JSON object with:
        - A title-cased name (e.g., "Lathe Estate Sale")
        - A placeholder description
        - A list of image entries, each with:
            - A simplified name (filename without extension)
            - An empty description
            - A raw GitHub URL to the image
    - Saves the resulting JSON to the same folder as the script, using the format "name.json".

.PARAMETER Year
    Required. A 4-digit string representing the year of the project (e.g., "2025").

.PARAMETER Name
    Required. A dash-separated name for the project directory (e.g., "lathe-estate-sale").
    Used both for the file path and as the display name in the JSON (converted to "Lathe Estate Sale").

.EXAMPLE
    .\generate-json.ps1 -Year 2025 -Name "lathe-estate-sale"
    Creates a JSON file based on original images (not thumbnails) located in ../2025/lathe-estate-sale/
    and outputs it as lathe-estate-sale.json in the script's folder.

.NOTES
    Assumes .jpg images are located under a structure like:
    [repo-root]/YEAR/NAME/*.jpg

    Filters out thumbnail images that end in "-150x200.jpg".

    URLs in the JSON will be formatted as:
    https://raw.githubusercontent.com/rbrock44/woodworking-projects-images/master/YEAR/NAME/filename.jpg

    Only non-thumbnail .jpg files are included. Description fields are left blank intentionally.
#>

param (
    [Parameter(Mandatory=$true)][string]$Year,
    [Parameter(Mandatory=$true)][string]$Name
)

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path -Parent $scriptPath
$basePath = Split-Path -Parent $scriptDir  # One level up from /script/

$imagePath = Join-Path -Path $basePath -ChildPath "$Year\$Name"

$outputFile = Join-Path -Path $scriptDir -ChildPath "$Name.json"

$displayName = ($Name -split '-').ForEach({ $_.Substring(0,1).ToUpper() + $_.Substring(1) }) -join ' '

# Get all .jpg files that are NOT thumbnails (exclude -150x200)
$images = Get-ChildItem -Path $imagePath -Filter *.jpg -Recurse |
    Where-Object { $_.Name -notmatch '-150x200\.jpg$' } |
    Sort-Object Name

$imageObjects = @()
foreach ($img in $images) {
    $baseFileName = [System.IO.Path]::GetFileNameWithoutExtension($img.Name)

    $imageObjects += [ordered]@{
        name = $baseFileName
        url = "https://raw.githubusercontent.com/rbrock44/woodworking-projects-images/master/$Year/$Name/$($img.Name)"
        desc = ""
    }
}

$projectObject = [ordered]@{
    name = $displayName
    desc = ""
    images = $imageObjects
}

$json = $projectObject | ConvertTo-Json -Depth 4

$json | Set-Content -Path $outputFile -Encoding UTF8

Write-Host "JSON saved to: $outputFile"
