; load configs.ini

global wallpaper_engine_ui32_path
IniRead, wallpaper_engine_ui32_path, config.ini, ahk_automation, wallpaper_engine_ui32_path
wallpaper_engine_ui32_path := PathResolveEnv(wallpaper_engine_ui32_path)
global exit_execution_delay
IniRead, exit_execution_delay, config.ini, ahk_automation, exit_execution_delay
global Log_path
IniRead, Log_path, config.ini, ahk_automation, Log_path

global wallpaper_backups
IniRead, wallpaper_backups, config.ini, wallpaper_backup_path, wallpaper_backups
wallpaper_backups := PathResolveEnv(wallpaper_backups)

global trash
IniRead, trash, config.ini, wallpaper_backup_path, trash
trash := PathResolveEnv(trash)

global enable_wallpaper_restored_msg
IniRead, enable_wallpaper_restored_msg, config.ini, ahk_automation, enable_wallpaper_restored_msg
global restored_msg
IniRead, restored_msg, config.ini, ahk_automation, restored_msg
restored_msg := RegExReplace(restored_msg, "(?<!(``))``n" , "`n")

global enable_wallpaper_removed_msg
IniRead, enable_wallpaper_removed_msg, config.ini, ahk_automation, enable_wallpaper_removed_msg
global removed_msg
IniRead, removed_msg, config.ini, ahk_automation, removed_msg
removed_msg := RegExReplace(removed_msg, "(?<!(``))``n" , "`n")

global enable_tray_icon
IniRead, enable_tray_icon, config.ini, ahk_automation, enable_tray_icon

; next wallpaper
global enable_next_wallpaper
IniRead, enable_next_wallpaper, config.ini, ahk_automation, enable_next_wallpaper

global wallpaper_engine_exe_dir
IniRead, wallpaper_engine_exe_dir, config.ini, ahk_automation, wallpaper_engine_exe_dir
wallpaper_engine_exe_dir := PathResolveEnv(wallpaper_engine_exe_dir)

global wallpaper64
IniRead, wallpaper64, config.ini, ahk_automation, wallpaper64
global wallpaper_engine_exe_path
if wallpaper64
    wallpaper_engine_exe_path := wallpaper_engine_exe_dir "/wallpaper64.exe"
else
    wallpaper_engine_exe_path := wallpaper_engine_exe_dir "/wallpaper.exe"

global idle_time_require
IniRead, idle_time_require, config.ini, ahk_automation, idle_time_require
idle_time_require := PathResolveEnv(idle_time_require)

global idle_check_interval
IniRead, idle_check_interval, config.ini, ahk_automation, idle_check_interval
idle_check_interval := PathResolveEnv(idle_check_interval)

global change_interval
IniRead, change_interval, config.ini, ahk_automation, change_interval
change_interval := PathResolveEnv(change_interval)
