# WoodworkingProjectsImages

This repo's purpose is to hold all of my wood working images. Scripts have been created to automate various tasks

User must install [ImageMagick](https://imagemagick.org/script/download.php#windows) before running scripts

The following should be done to all images uploaded to this repo:
* Compress (I used [TinyPNG](https://tinypng.com/) previously)
  * [Compress script](#compress-tinypngps1)
* Aspect ratio of 4:3 (height:width)
  * [Find not 4:3 aspect ratio script](#find_not_3_by_4_aspect_ratiops1)
  * [Fix not 4:3 script](#fix_not_3_by_4ps1)
  * Please delete not_3_by_4.txt file before pushing images to repo!

# Scripts

## compress-tinypng.ps1
  - Compresses all PNG and JPG images in a given folder using the TinyPNG API
    - Usually I have a new folder, not in this project that has the latest photos from my phone to upload
  - Must enter api-key (**Don't Commit to Github**)
  - EXAMPLE(S): 
    - .\compress-tinypng.ps1 -DirectoryPath "C:\Users\rbroc\Downloads\Wood"

## create-thumbnails.ps1
  - Creates 200x150 pixel thumbnails for .jpg images that don't already have corresponding thumbnails
    - Finds all .jpg files that don't have -200x250.jpg (20250430_1716.jpg -> 20250430_1716-200x150.jpg)
    - Creates -200x250.jpg for those files
  - EXAMPLE(S):
    - .\create-thumbnails.ps1
    - .\create-thumbnails.ps1 -DirectoryPath "C:\Users\rbroc\Downloads\Wood"

## find_not_3_by_4_aspect_ratio.ps1
  - Finds the filenames of all images that are not 3 by 4 aspect ratio 
    - Saves filenames to new file (/scripts/not_3_by_4.txt)
    - Don't commit *not_3_by_4.txt* to Github 
  - EXAMPLE(S):
    - .\find_not_3_by_4_aspect_ratio.ps1

## fix_not_3_by_4.ps1
- This reads *not_3_by_4.txt* then fixes aspect ratio of those files using magisk
  - Delete *not_3_by_4.txt* after all images successful
  - Don't commit *not_3_by_4.txt* to Github
- EXAMPLE(S):
  - .\fix_not_3_by_4.ps1

## rename-pxl-files.ps1
- When getting the photos off my andriod phone they are in the format *PXL_YYYYMMDD_HHMMSS###.jpg*
  - renames all matching formats to *YYYYMMDD_HHMM.jpg*, all images in this repo follow this format
- EXAMPLE(S):
  - .\rename-pxl-files.ps1 -DirectoryPath "C:\Users\rbroc\Downloads\Wood"

