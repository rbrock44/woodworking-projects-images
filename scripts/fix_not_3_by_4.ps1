# Read the file containing non-3:4 images
$inputFile = "not_3_by_4.txt"
if (!(Test-Path $inputFile)) {
    Write-Host "Error: File $inputFile not found!"
    exit
}

# Get all image paths
$images = Get-Content $inputFile

foreach ($imgPath in $images) {
    if (!(Test-Path $imgPath)) {
        Write-Host "Skipping: File not found - $imgPath"
        continue
    }

    # Get image dimensions
    $dimensions = magick identify -format "%w %h" "$imgPath" 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Cannot process $imgPath"
        continue
    }

    $width, $height = $dimensions -split " "

    # Ensure dimensions are numeric
    if (-not ($width -match '^\d+$') -or -not ($height -match '^\d+$')) {
        Write-Host "Skipping: Could not read dimensions - $imgPath"
        continue
    }

    # Calculate correct height for 3:4 aspect ratio
    $correctHeight = [math]::Round(($width / 3) * 4)

    if ($height -ne $correctHeight) {
        # Decide padding color dynamically based on image brightness
        # harcoded to black for now 2025/03/01 - $paddingColor = "white"
        $paddingColor = "black"
        $brightnessCheck = magick convert "jpg:$imgPath" -colorspace Gray -format "%[fx:mean]" info:
        if ($brightnessCheck -lt 0.5) {
            $paddingColor = "black"
        }

        # Overwrite the image with adjusted version
        cmd /c "magick ""jpg:$imgPath"" -gravity center -background $paddingColor -extent ""$width""x""$correctHeight"" ""jpg:$imgPath"""

        Write-Host "Fixed: $imgPath ($width x $height → $width x $correctHeight) with $paddingColor padding"
    } else {
        Write-Host "Already 3:4: $imgPath"
    }
}

Write-Host "Processing complete! All images have been updated."