; check if need update
if A_IsCompiled {
    if FileExist("config.ini") {
        current_version := "1.0"
        IniRead, ini_version, config.ini, ahk_automation, version
        if (current_version != ini_version){
            ; using a different version
            FileMove, config.ini, config %ini_version%.ini, Overwrite
            MsgBox, new version`nconfig.ini created`nold config.ini renamed to config %ini_version%.ini`nother internal files will be overwritten
            version_change := True
        }
    }
    Else {
        version_change := True
    }

    ; FileInstall
    ; config
    FileInstall, config.ini, config.ini, %version_change%
    
    ;libs
    FileCreateDir, bulk-directory-link-lib
    FileInstall, bulk-directory-link-lib\bulk_directory_link_lib.ps1, bulk-directory-link-lib\bulk_directory_link_lib.ps1, %version_change%
    FileInstall, bulk-directory-link-lib\Compare_File_Info_by_Handle.cs, bulk-directory-link-lib\Compare_File_Info_by_Handle.cs, %version_change%
    FileInstall, bulk-directory-link-lib\Compare_File_Info_by_Handle.ps1, bulk-directory-link-lib\Compare_File_Info_by_Handle.ps1, %version_change%

    FileCreateDir, Wallpaper Engine module
    FileInstall, Wallpaper Engine module\Load config.ps1, Wallpaper Engine module\Load config.ps1, %version_change%
    FileInstall, Wallpaper Engine module\Wallpaper Engine module.ps1, Wallpaper Engine module\Wallpaper Engine module.ps1, %version_change%
    
    ;Path setup
    if version_change {
        #Include, path setup.ahk
    }

    ; start up shortcut
    SplitPath, A_ScriptName , , , , ScriptNameNoExt
    shortcut_name := ScriptNameNoExt . " - shortcut.lnk"
    If Not FileExist(shortcut_name) {
        FileCreateShortcut, %A_ScriptFullPath%, %shortcut_name% , %A_ScriptDir%
        MsgBox, 4,, Would you like %ScriptNameNoExt% to run on boot? (press Yes or No)
        IfMsgBox, Yes
        {
            FileCopy, %shortcut_name%, %A_AppData%\Microsoft\Windows\Start Menu\Programs\Startup\%shortcut_name%, overwrite
            MsgBox, This script will run on Startup`n`nTo disable run on startup, delete the shortcut in Startup folder`n`n%A_AppData%\Microsoft\Windows\Start Menu\Programs\Startup\%shortcut_name%
        }
        Else {
            MsgBox, To Enable run on startup manually, Copy:`n`nshortcut - %shortcut_name%`nTo`n`n%A_AppData%\Microsoft\Windows\Start Menu\Programs\Startup
        }
    }
}
