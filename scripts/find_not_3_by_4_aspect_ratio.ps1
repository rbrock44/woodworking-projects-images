# Move up one directory from /scripts/
$startPath = Get-Location
Set-Location ..

# Define output file in /scripts/ folder
$outputFile = "$startPath\not_3_by_4.txt"

# Recursively find all JPG images
$images = Get-ChildItem -Path . -Filter *.jpg -Recurse

# Initialize an empty list
$nonMatchingImages = @()

# Loop through images and check aspect ratio
foreach ($img in $images) {
    $dimensions = magick identify -format "%w %h" $img.FullName
    $width, $height = $dimensions -split " "

    # Calculate aspect ratio
    $aspectRatio = [math]::Round(($width / $height), 2)

    # Check if it's not 3:4 (0.75)
    if ($aspectRatio -ne 0.75) {
        $nonMatchingImages += $img.FullName
        Write-Host "$($img.FullName) - $width x $height"
    }
}

# Write results to file (one per line)
$nonMatchingImages | Set-Content -Path $outputFile

Write-Host "Scan complete! All above images are NOT 3:4"
Write-Host "Results saved to: $outputFile"
