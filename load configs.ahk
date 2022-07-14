; load configs.ini

global wallpaper_engine_ui32_path
IniRead, wallpaper_engine_ui32_path, config.ini, ahk_automation, wallpaper_engine_ui32_path
wallpaper_engine_ui32_path := PathResolveEnv(wallpaper_engine_ui32_path)
global exit_execution_delay
IniRead, exit_execution_delay, config.ini, ahk_automation, exit_execution_delay
global monitor_frequency
IniRead, monitor_frequency, config.ini, ahk_automation, monitor_frequency
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
