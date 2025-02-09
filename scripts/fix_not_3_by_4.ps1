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
    $dimensions = magick identify -format "%w %h" $imgPath
    $width, $height = $dimensions -split " "

    # Calculate correct height for 3:4 aspect ratio
    $correctHeight = [math]::Round(($width / 3) * 4)

    if ($height -ne $correctHeight) {
        $topBottomPadding = [math]::Round(($correctHeight - $height) / 2)

        # Decide padding color dynamically
        $paddingColor = "white"
        if ($width -ge 800) {  # Example condition, adjust as needed
            $paddingColor = "black"
        }

        # Overwrite the image with adjusted version
        magick convert $imgPath -gravity center -background $paddingColor -extent "$width"x"$correctHeight" $imgPath
        
        Write-Host "Fixed: $imgPath ($width x $height → $width x $correctHeight) with $paddingColor padding"
    } else {
        Write-Host "Already 3:4: $imgPath"
    }
}

Write-Host "Processing complete! All images have been updated."