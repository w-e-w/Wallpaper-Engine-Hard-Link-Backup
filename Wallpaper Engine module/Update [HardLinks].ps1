#Wallpaper Engine module module
. "$PSScriptRoot\Load config.ps1"
. ("$PSScriptRoot\Wallpaper Engine module.ps1")

#backup wallpapes
wallpaper_hard_link_copy $Workshop_Content_431960 $HardLink_Sync $Trash "$Timestamp Conflict"
