#Wallpaper Engine module module
. "$PSScriptRoot\Load config.ps1"
. "$PSScriptRoot\Wallpaper Engine module.ps1"

# import backed up wallpapes
clean_dir_invalid_junctions $Wallpaper_Engine_Import
junction_mirror $Wallpaper_Backups $Wallpaper_Engine_Import
