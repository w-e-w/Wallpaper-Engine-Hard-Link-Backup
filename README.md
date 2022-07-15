# Wallpaper-Engine-Hard-Link-Backup
Preventing Steam from deleting Wallpaper Engine's workshop wallpapers by using hard links as backup

Solution to Steam deleting wallpapers without warning.

[English](README.md), [繁體中文](README.zh-TW.md), [简体中文](README.zh-CN.md)

the issue is describe on the help page
https://help.wallpaperengine.io/en/steam/backup.html
> When wallpapers are deleted from Steam for any reason, Steam will also delete them from your PC. Wallpaper Engine cannot prevent that, but if this is a concern for you, you can make a backup of your wallpapers.

The offical soution is to make a backup of your Wallpapaers,
but doing so will double your storage usage.

Whiles you could unsubscribe from a wallpaper after makeing a backup to save space, this it's tedious and also you won't be able to receive any further updates for that wallpaper.

---
## This goal of this project is to
 1. Preventing Steam from deleting Wallpaper
 2. Without using extra storage
- This a achived by the use of Hard Links

---
## What are Hard Links (simplified)
The `file object` in a file system that most people think of as a `file` is **NOT** the `file data`.

Insted the `file object` is a peace of information that points to where the `file data` is stored on the storage device.

This `file object` is called a `hard link`.

A `file data` will have least have **1** `hard link`, it can have multiple of hard links.

A `file data` is deleted when there it all if it's `hard links` is removed.

Note:
1. multiple `hard links` will not increase your storage usage,
but due to how windows calclate file size, it would seems like the `hard links` are takeing up space, if check the disk usage, you will see it dose not increase
2. if `file A` and `file B` are hard links of the same `file data`, modifying (editing) `file A` will also modify `file B` because they are the same `file data`
3. technically all `file object` are `hard links` but generally aren't referring to as such if there's only a single `hard link` corresponding to the `file data`.

### for more detailed and accurate information about Hard Links, please find other the sources

---

## How does this work and
By creating a second hard link for the wallpaper files, when Steam deletes the original files, the files will not be truly removed from your computer

---
## Function of the script
- making a `Hard Link copy` of your `Steam Workshop downloads`
- comparing `Hard Link copy` with `Steam Workshop downloads` to check if any wallpapers are missing
- if a missing wallpaper if found, the `Hard Link copy` of that wallpaper will be moved to a `folder`
  - the script tries to determine if it's you or Steam Who deleteds the wallpaper by when the wallpaper is deleted
    1. if a wallpaper is removed `within 1 minute` Wallpaper Engine UI of closing, then it's likely that `you removed` the wallpaper
    2. else if the wallpaper is before you UI is opend, then it's likely that `Steam removed` the wallpaper
    3. based on the above condition, destination `folder` will change
    - this method of detection is not perfect, the flaws are
      1. if unsubscribe from a wallpaper form a web browser whele UI is closed, it will think that steam removes it
      2. or if a wallpaper is deleted by steam when the UI is open, it will think the the user unsubscribe from a wallpaper
      - a improved method would be to
        1. access Steam Workshop through internet
        2. check if the wallaper exist then determine action
        - this method would be more accurate but also with complications, may be implemented in the future
  - if it determine Steam removed the wallpaper, it will then move the wallpaper into the `Backups` folder, it will also import the wallpaper back into Wallpaper Engine
  - if it thinks you unsubscribed it will move the wallpaper into a folder named `Removed`
    - think of `Removed` folder as "Recycling bin", delete the contents when you're sure you don't want them
    - since there is a chance of accidental wallpaper removal, you have to manually confirm the contents
  - If a Wallapaer has be accidentally move to `Removed` folder, you can move it manually to the `Backups` folder to restore the wallpaper, and vice versa.
---
## Script Routine
1. the script executes it will run in background
2. periodically check if Wallpaper Engine UI is running. (default onec every 5 second)
3. if it found tha Wallpaper Engine UI is running
   1. compare `Hard links` with `Steam Workshop Downloads` see if any wallpaper is missing,
      1. if a missing wallpaper is found, the wallpaper is move fo `Backups` folder
      2. Wallpapers in `Backups` folder will be imported into wallpaper engiene
   2. after when Wallpaper Engine UI closes, a `Countdown Timer` is started. (default 1 minunt)
      1. the `Countdown Timer` can be interrupted by the user opening Wallpaper Engine UI again, if so back to the previous step
      2. when the `Countdown Timer` is up
         1. compare `Hard links` with `Steam Workshop Downloads` see if any wallpaper is missing,
            1. if a missing wallpaper is found, the wallaper will be moved to `Removed` folder
         2. make a `Hard Link copy` of every Wallaper in `Steam Workshop Downloads` to `Hard links` folder
4. cycle repeats

The reason that there is a `Countdown Timer` is to give steam some time to remove the "recently unsubscribe" wallpapers, as users often subscribe then unsubscribe wallpaper if they don't like it

If the `Hard Link copy` script is executed immediately after the UI closes, all wallpapers including the one you unsubscribed will be backed up

---


## Usage
### Normal mode
1. download the exe in the release page
2. place the exe in a folder and executed once, some files will be extractd.
   1. a `config.ini` will be created, this file is used for configuration in additional settings.
   2. if wallpaper engine is not install in the default location, you will be prompted to select the correct locations
      1. you may still need to edit `config.ini` if your Wallpaper Enging and or Steam is not installed in the default location
   3. you will be ask where you want to backup your wallpapers, or use the default location
      - ( User\USER_NAME\Steam Workshop Backup\Wallpaper Engine\ )
      - **Must be in the same Volume as Wallpaper Engine Steam Workshop downloads**
3. You will be asked if you wish the script to run on Startup
   - this can be enabled manually later
4. after confirming these configurations are correct, execute the exe again
5. the script should now be working in the background, see `Script Routine` for details

### Advance mode
Download
1. clone this repository
2. install AutoHotkey if you wish to automate it
   
Automated mode
- with Autohotkey run `Wallpaper Engine - Hard Links Backup.ahk`
  - it will directly run in the background without setting / checking if the it configs are correct
    - if you only intend to use it like this without modification, I recommend to just use the released exe

Manual Execution
- in `Wallpaper Engine module` you will have access to some pre-built Powershell Sequences
- use them as you see fit

it's all up to you

---
## Steam Workshop and Wallpaper Engine behaviors observations
1. Steam can download workshop files an any time
2. Steam only deletes or update workshop files when Wallpaper UI is not running
3. When user Subscribed to Wallpapers using Wallpaper Enging UI, the wallpaper will be downloaded immediately
4. When user Unsubscribed to Wallpapers using Wallpaper Enging UI, the Unsubscribed wallpapers will only be removed by Steam after the Wallpaper Enging UI closes
---

## Warnings
- This tool is only designed to run on Windows using NTFS file system
  - which should be most computer running Wallpaper Engine
- Even though I use the term **Backup**, This is not truly a Backup Tool
  - it will not protect against data loss
  - you still only have one copy of the actual files
  
- Steam could changed the method of deleting files
  - there are methods of deleting files that can delete files with multiple Hard Links
  - if Steam decides to implement these methods, then this tool is effectively useless

- this tool is not designed for you to keep multiple versions of wallpaper
  - even though under some conditions it will do so
