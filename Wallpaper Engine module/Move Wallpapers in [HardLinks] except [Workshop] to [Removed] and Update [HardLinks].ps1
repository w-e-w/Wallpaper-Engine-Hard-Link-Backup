#Wallpaper Engine module module
. "$PSScriptRoot\Load config.ps1"
. "$PSScriptRoot\Wallpaper Engine module.ps1"

# find wallpapers in $HardLink_Sync that are not in $Workshop_Content_431960 move them to $Trash
wallpapers_src_dir_except_comp_dir_move $HardLink_Sync $Workshop_Content_431960 $Trash $Timestamp

# backup wallpapes
wallpaper_hard_link_copy $Workshop_Content_431960 $HardLink_Sync $Trash "$Timestamp Conflict"

