#Wallpaper Engine module module
. "$PSScriptRoot\Load config.ps1"
. "$PSScriptRoot\Wallpaper Engine module.ps1"

#backup wallpapes
wallpaper_hard_link_copy $Workshop_Content_431960 $HardLink_Sync $Trash $Timestamp

# import backed up wallpapes
clean_dir_invalid_junctions $Wallpaper_Engine_Import
junction_mirror $HardLink_Sync $Wallpaper_Engine_Import
