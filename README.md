# Woodworking Projects Images

> This repo's purpose is to hold all of my wood working images. <br/>
> [LIVE - Woodworking Projects Website](https://woodworking-projects.ryan-brock.com/)

---

## 📚 Table of Contents

- [What's My Purpose?](#-whats-my-purpose)
- [How to Use](#-how-to-use)
  - [Environment Setup](#environment-setup)
  - [List of Scripts](#list-of-scripts)
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
  1. In a seperate folder outside this repo:
      - Run [Rename files scripts](#rename-pxl-filesps1)
        - Manually fix any files the script didn't, matching this format *YYYYMMDD_HHMM.jpg*  
      - Run [Compress script](#compress-tinypngps1) - [Environment Setup](#environment-setup) needed
  2. Move photos to correct repo subfolder (add new subfolder(s) if needed)
  3. Run [Process Images](#process-imagesps1)
  4. All done, push to repo

---

### List of Scripts

#### compress-tinypng.ps1
  - Compresses all PNG and JPG images in a given folder using the TinyPNG API
    - Usually I have a new folder, not in this project that has the latest photos from my phone to upload
  - Must enter api-key (**Don't Commit to Github**)
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

#### process-images.ps1
- When photos have been moved to this repo, this super script runs several scripts to get the images ready
- EXAMPLE(S):
  - .\process-images.ps1

#### rename-pxl-files.ps1
- When getting the photos off my andriod phone they are in the format *PXL_YYYYMMDD_HHMMSS###.jpg*
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
