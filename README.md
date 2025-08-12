# Woodworking Projects Images

> This repo's purpose is to hold all of my wood working images. <br/>
> [LIVE - Woodworking Projects Website](https://woodworking-projects.ryan-brock.com/)

---

## 📚 Table of Contents

- [What's My Purpose?](#-whats-my-purpose)
- [How to Use](#-how-to-use)
  - [Environment Setup](#environment-setup)
  - [List of Scripts](#list-of-scripts)
    - [auto-process-images](#auto-process-imagesps1)
    - [compress-tinypng](#compress-tinypngps1)
    - [create-thumbnail](#create-thumbnailsps1)
    - [find_not_3_by_4_aspect_ratio](#find_not_3_by_4_aspect_ratiops1)
    - [fix_not_3_by_4](#fix_not_3_by_4ps1)
    - [generate-json](#generate-jsonps1)
    - [pre-process-images](#pre-process-imagesps1)
    - [process-images](#process-imagesps1)
    - [rename-pxl-images](#rename-pxl-filesps1)
  - [How to Add Photos](#how-to-add-photos)
- [Technologies](#-technologies)
- [Getting Started (Local Setup)](#-getting-started-local-setup)
  - [Run Locally](#run-locally)

---

## 🧠 What's My Purpose?

This repo's purpose is to hold all of my wood working images. Scripts have been created to automate various tasks. The corresponding [Woodworking Projects Website](https://woodworking-projects.ryan-brock.com/)/[Repo](https://github.com/rbrock44/woodworking-projects)

---

## 🚦 How to Use

---

### Environment Setup

1. **Copy the example env file**  
  Create your local `.env.local` file by copying the template:

   ```bash
   cp .env.example .env.local
   ```
2. Replace API Key
  Open .env.local in your editor and replace the placeholder with your actual TinyPng API Key

---

### How to Add Photos

***If only one project being added (or added to)***
  1. In a seperate folder outside this repo:
      - **[Environment Setup](#environment-setup) needed**
      - Run [auto process images](#pre-process-imagesps1)
        - .\auto-process-images.ps1 -DirectoryPath "C:\Users\rbroc\Downloads\Wood" -Name "lathe-estate-sale"

***If more than one project being added (or added to)***
  1. In a seperate folder outside this repo:
      - **[Environment Setup](#environment-setup) needed**
      - Run [pre-process images](#pre-process-imagesps1)
        - .\pre-process-images.ps1 -DirectoryPath "C:\Users\rbroc\Downloads\Wood"
  2. Move photos to correct repo subfolder (add new subfolder(s) if needed)
  3. Run [Process Images](#process-imagesps1)
      - .\process-images.ps1
  4. All done, push to repo
  5. **Optional:** Run [generate json](#generate-jsonps1) to assist in adding new project to [project-list.json](https://github.com/rbrock44/woodworking-projects/blob/master/public/project-list.json)

---

### List of Scripts

#### auto-process-images.ps1
  - Designed to fully automate image intake for one project (at a time)
    - Runs [pre-process images](#pre-process-imagesps1)
    - Moves images to RepoPath\Year\Name
    - Runs [Process Images](#process-imagesps1)
    - Asks to run [generate json](#generate-jsonps1)
  - EXAMPLE(S): 
    - .\auto-process-images.ps1 -DirectoryPath "C:\Users\rbroc\Downloads\Wood" -Name "lathe-estate-sale"
    - .\auto-process-images.ps1 -DirectoryPath "C:\Users\rbroc\Downloads\Wood" -Name "lathe" -Year 2025
    - .\auto-process-images.ps1 -DirectoryPath "C:\Users\rbroc\Downloads\Wood" -Name "lathe" -Repo "C:\workspace\woodworking-project-images"

#### compress-tinypng.ps1
  - Compresses all PNG and JPG images in a given folder using the TinyPNG API
    - Usually I have a new folder, not in this project that has the latest photos from my phone to upload
  - [Environment Setup](#environment-setup) needed
  - EXAMPLE(S): 
    - .\compress-tinypng.ps1 -DirectoryPath "C:\Users\rbroc\Downloads\Wood"

#### create-thumbnails.ps1
  - Creates 150x200 pixel thumbnails for .jpg images that don't already have corresponding thumbnails
    - Finds all .jpg files that don't have -150x200.jpg (20250430_1716.jpg -> 20250430_1716-150x200.jpg)
    - Creates -150x200.jpg for those files
  - EXAMPLE(S):
    - .\create-thumbnails.ps1
    - .\create-thumbnails.ps1 -DirectoryPath "C:\Users\rbroc\Downloads\Wood"

#### find_not_3_by_4_aspect_ratio.ps1
  - Finds the filenames of all images that are not 3 by 4 aspect ratio 
    - Saves filenames to new file (/scripts/not_3_by_4.txt)
    - Don't commit *not_3_by_4.txt* to Github 
  - EXAMPLE(S):
    - .\find_not_3_by_4_aspect_ratio.ps1

#### fix_not_3_by_4.ps1
- This reads *not_3_by_4.txt* then fixes aspect ratio of those files using magisk
  - Delete *not_3_by_4.txt* after all images successful
  - Don't commit *not_3_by_4.txt* to Github
- EXAMPLE(S):
  - .\fix_not_3_by_4.ps1

#### generate-json.ps1
- Creates a JSON file based on original images (not thumbnails) located in ../2025/lathe-estate-sale/ (../-Year/-Name/)
  - Accepts -Year and -Name parameters
  - Outputs it as {-Name parameter}.json in the script's folder
  - Used for generating and quickly adding new projects to the [project-list.json](https://github.com/rbrock44/woodworking-projects/blob/master/public/project-list.json)
- EXAMPLE(S):
  - .\generate-json.ps1 -Year 2025 -Name "lathe-estate-sale"

#### pre-process-images.ps1
- When gathering photos (before moving to this repo), this super script helps rename and compress photos
  - Runs [rename-pxl-images](#rename-pxl-filesps1)
  - Then runs [compress-tinypng](#compress-tinypngps1)
- EXAMPLE(S):
  - .\pre-process-images.ps1 -DirectoryPath "C:\Users\rbroc\Downloads\Wood" 

#### process-images.ps1
- When photos have been moved to this repo, this super script runs several scripts to get the images ready
  - Runs [find_not_3_by_4_aspect_ratio](#find_not_3_by_4_aspect_ratiops1)
  - If `not_3_by_4.txt` is found, runs [fix_not_3_by_4](#fix_not_3_by_4ps1)
  - Lastly runs [create-thumbnail](#create-thumbnailsps1)
- EXAMPLE(S):
  - .\process-images.ps1

#### rename-pxl-files.ps1
- When getting the photos off my andriod phone they are in the format *PXL_YYYYMMDD_HHMMSS###.jpg* || *PXL_YYYYMMDD_HHMMSS.MP###.jpg*
  - renames all matching formats to *YYYYMMDD_HHMM.jpg*, all images in this repo follow this format
- EXAMPLE(S):
  - .\rename-pxl-files.ps1 -DirectoryPath "C:\Users\rbroc\Downloads\Wood"

## 🛠 Technologies

- ImageMagick
- Powershell

---

## 🚀 Getting Started (Local Setup)

* Install [ImageMagick](https://imagemagick.org/script/download.php#windows) before running scripts
* Clone [repo](https://github.com/rbrock44/woodworking-projects-images)
* [Environment Setup](#environment-setup)

---

### Run Locally

Run a script in the appropiate terminal

---
