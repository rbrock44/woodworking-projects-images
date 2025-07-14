# WoodworkingProjectsImages

This repo's purpose is to hold all of my wood working images

Scripts have been created to automate various tasks

# Scripts

## compress-tinypng.ps1
  - Compresses all PNG and JPG images in a given folder using the TinyPNG API
    - Usually I have a new folder, not in this project that has the latest photos from my phone to upload
  - Must enter api-key (**Don't Commit to Github**)
  - EXAMPLE(S): 
    - .\compress-tinypng.ps1 -DirectoryPath "C:\Users\rbroc\Downloads\Wood"

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
  
The following should be done to all images uploaded to that repo: </br>
* compressed (I used [TinyPNG](https://tinypng.com/) previously).
* Aspect ratio of 4:3 (height:width)
  * User must install [ImageMagick](https://imagemagick.org/script/download.php#windows) before running scripts 
  * [find_not_3_by_4_aspect_ratio.ps1](https://github.com/rbrock44/woodworking-projects-images/blob/master/scripts/find_not_3_by_4_aspect_ratio.ps1) will create a not_3_by_4.txt file and output problem image paths
  * [fix_not_3_by_4.ps1](https://github.com/rbrock44/woodworking-projects-images/blob/master/scripts/fix_not_3_by_4.ps1) will read the not_3_by_4.txt file and pad black or white to make image 4:3 aspect ratio
  * Please delete not_3_by_4.txt file before pushing images to repo!




