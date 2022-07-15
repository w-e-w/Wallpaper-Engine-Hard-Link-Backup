IniRead, wallpaper_engine_import, config.ini, wallpaper_engine_install_path, wallpaper_engine_import
wallpaper_engine_import := PathResolveEnv(wallpaper_engine_import)
if (FileExist(wallpaper_engine_import . "\..") != "D"){
    FileSelectFolder, wallpaper_engine_project , , Options, Select Wallpaper Engine "projects" Folder`n\wallpaper_engine\projects
    if (Not ErrorLevel){
        IniWrite, "%wallpaper_engine_import%\backup", config.ini, wallpaper_engine_install_path, wallpaper_engine_import
    }
}

IniRead, workshop_content_431960, config.ini, wallpaper_engine_install_path, workshop_content_431960
workshop_content_431960 := PathResolveEnv(workshop_content_431960)
if (FileExist(workshop_content_431960) != "D"){
    FileSelectFolder, content_431960 , , Options, Select Wallpaper Engine's Steam Workshop Folder`nSteam\steamapps\workshop\content\431960
    if (Not ErrorLevel){
        workshop_content_431960 := content_431960
        IniWrite, "%workshop_content_431960%", config.ini, wallpaper_engine_install_path, workshop_content_431960
    }
}

IniRead, wallpaper_engine_ui32, config.ini, ahk_automation, wallpaper_engine_ui32_path
wallpaper_engine_ui32 := PathResolveEnv(wallpaper_engine_ui32)
if (Not FileExist(wallpaper_engine_ui32)){
    FileSelectFile, wallpaper_engine_ui32 , Options, , select wallpaper_engine\bin\ui32.exe, *.exe
    if (Not ErrorLevel){
        IniWrite, "%wallpaper_engine_ui32%", config.ini, ahk_automation, wallpaper_engine_ui32_path
    }
}

SplitPath, workshop_content_431960 , , , , , drive_workshop_content_431960
MsgBox, 260, , set custom backup path?`npath MUST be in %drive_workshop_content_431960%
IfMsgBox, Yes
{
    FileSelectFolder, backup_root , , 1, Select Wallpaper Engine "projects" Folder`n\wallpaper_engine\projects
    hardlink_sync := backup_root . "\HardLinks" 
    wallpaper_backups := backup_root . "\Backups"
    trash := backup_root . "\Removed"
    Log_path := backup_root . "\logs"

    IniWrite, "%hardlink_sync%", config.ini, wallpaper_backup_path, hardlink_sync
    IniWrite, "%wallpaper_backups%", config.ini, wallpaper_backup_path, wallpaper_backups
    IniWrite, "%trash%", config.ini, wallpaper_backup_path, trash
    IniWrite, "%Log_path%", config.ini, ahk_automation, Log_path
}

