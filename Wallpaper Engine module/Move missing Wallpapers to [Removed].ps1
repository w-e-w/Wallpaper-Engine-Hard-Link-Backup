#Wallpaper Engine module module
. "$PSScriptRoot\Load config.ps1"
. "$PSScriptRoot\Wallpaper Engine module.ps1"

# find wallpapers in $HardLink_Sync that are not in $Workshop_Content_431960 move them to $Trash
find_extra_wallpaper_move_location $HardLink_Sync $Workshop_Content_431960 $Trash $Timestamp
