#NoEnv
#Persistent
#NoTrayIcon
#SingleInstance, force
SetWorkingDir %A_ScriptDir%

; FileInstall setup
#Include, include files.ahk
; FileInstall sequence script
FileInstall, Wallpaper Engine module\Move Wallpapers in [HardLinks] except [Workshop] to [Backups] and Import [Backups].ps1, Wallpaper Engine module\Move Wallpapers in [HardLinks] except [Workshop] to [Backups] and Import [Backups].ps1, %version_change%
FileInstall, Wallpaper Engine module\Move Wallpapers in [HardLinks] except [Workshop] to [Removed] and Update [HardLinks].ps1, Wallpaper Engine module\Move Wallpapers in [HardLinks] except [Workshop] to [Removed] and Update [HardLinks].ps1, %version_change%
If version_change {
    MsgBox, initial setup complete`n`nopen config.ini comferf if the paths are correct`n`nnext time this script is executed, it will be working in background
    Run, config.ini
    ExitApp
}

; load configs.ini
#Include, load configs.ahk
If (enable_tray_icon){
    Menu, Tray, Icon
}

; start monitoring wallppaper engine
cheak_wpe_ui_exist()
Return

cheak_wpe_ui_exist(){
    if WinExist("ahk_exe"wallpaper_engine_ui32_path) {
        SetTimer, after_wpe_ui_exit, Off
        FileGetTime, t1 , %wallpaper_backups%
        RunWaitPsScript("Wallpaper Engine module\Move Wallpapers in [HardLinks] except [Workshop] to [Backups] and Import [Backups].ps1", , Log_path)
        FileGetTime, t2 , %wallpaper_backups%
        if (enable_wallpaper_restored_msg and (t1-t2))
            SetTimer, msg_restored, -1
        WinWaitClose, ahk_exe %wallpaper_engine_ui32_path%
        SetTimer, after_wpe_ui_exit, % -exit_execution_delay
    }
    SetTimer, cheak_wpe_ui_exist , % -monitor_frequency
}

after_wpe_ui_exit(){
    SetTimer, cheak_wpe_ui_exist, Off
    FileGetTime, t1 , %trash%
    RunWaitPsScript("Wallpaper Engine module\Move Wallpapers in [HardLinks] except [Workshop] to [Removed] and Update [HardLinks].ps1", , Log_path)
    FileGetTime, t2 , %trash%
    if (enable_wallpaper_removed_msg and (t1 != t2))
        SetTimer, msg_removed, -1
    SetTimer, cheak_wpe_ui_exist , % -monitor_frequency
}

msg_restored(){
    MsgBox, , , % restored_msg wallpaper_backups, 60
}

msg_removed(){
    MsgBox, , , % removed_msg trash, 60
}
