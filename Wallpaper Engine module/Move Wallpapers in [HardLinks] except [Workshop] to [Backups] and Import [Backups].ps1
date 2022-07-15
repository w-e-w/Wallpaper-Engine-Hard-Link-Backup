#Wallpaper Engine module module
. "$PSScriptRoot\Load config.ps1"
. "$PSScriptRoot\Wallpaper Engine module.ps1"

# find wallpapers in $HardLink_Sync that are not in $Workshop_Content_431960 move them to $Wallpaper_Engine_Import
wallpapers_src_dir_except_comp_dir_move $HardLink_Sync $Workshop_Content_431960 $Wallpaper_Backups $Timestamp

# import backed up wallpapes
clean_dir_invalid_junctions $Wallpaper_Engine_Import
junction_mirror $Wallpaper_Backups $Wallpaper_Engine_Import
