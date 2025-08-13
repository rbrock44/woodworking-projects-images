<#
.SYNOPSIS
    Renames image files with names in the format "PXL_YYYYMMDD_HHMMSS###.jpg"
    to a shorter format "YYYYMMDD_HHMM.jpg".

.DESCRIPTION
    This script:
    - Accepts an optional directory path as a parameter.
    - Uses the current script location if no path is provided.
    - Scans for files named like "PXL_20250430_171615331.jpg".
    - Renames them to "20250430_1716.jpg".
    - Ensures no overwrites by incrementing the minute until a unique name is found.

.PARAMETER DirectoryPath
    Optional. The path to the directory containing the files.
    If not provided, the script uses its current directory.

.EXAMPLE
    .\rename-pxl-files.ps1
    Runs in the directory where the script is located.

.EXAMPLE
    .\rename-pxl-files.ps1 -DirectoryPath "C:\Photos"
    .\rename-pxl-files.ps1 -DirectoryPath "C:\Users\rbroc\Downloads\Wood"
    Runs in the specified directory.

.NOTES
    Only processes files that match the pattern and have a .jpg extension.
#>

param (
    [string]$DirectoryPath = $PSScriptRoot
)

# Ensure the path exists
if (-not (Test-Path $DirectoryPath)) {
    Write-Error "Directory does not exist: $DirectoryPath"
    exit 1
}

# Get files matching pattern
$files = Get-ChildItem -Path $DirectoryPath -File -Filter "PXL_*.jpg"

foreach ($file in $files) {
    # Match pattern PXL_YYYYMMDD_HHMMSS###
    if ($file.BaseName -match '^PXL_(\d{8})_(\d{9})(?:\.MP)?(?:\.\w+)?$') {
        $date = $matches[1]
        $time = $matches[2]
        $shortTime = $time.Substring(0, 4)
        
        $baseName = "$date" + "_" + "$time"
        $newName = "$baseName.jpg"
        $counter = 0

        while (Test-Path (Join-Path $DirectoryPath $newName)) {
            # Increment minute
            $datetime = [datetime]::ParseExact("$date$shortTime", "yyyyMMddHHmm", $null)
            $datetime = $datetime.AddMinutes(1)
            $date = $datetime.ToString("yyyyMMdd")
            $shortTime = $datetime.ToString("HHmm")
            $baseName = "$date" + "_" + "$shortTime"
            $newName = "$baseName.jpg"
            $counter++
            if ($counter -gt 1000) {
                Write-Warning "Too many duplicates for $($file.Name), skipping."
                break
            }
        }

        Rename-Item -Path $file.FullName -NewName $newName
        Write-Host "Renamed '$($file.Name)' to '$newName'"
    } else {
        Write-Host "Skipping '$($file.Name)' - does not match pattern."
    }
}
