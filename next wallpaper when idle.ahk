#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

#Persistent
;next wallpaper when idle

check_idel()


check_idel(){
    static last_change_time := A_Now
    if (A_TimeIdlePhysical > idle_time_require) {
        now := A_Now
        delta_time := now
        EnvSub, delta_time, %last_change_time%
    
        last_change_time := now
        next_wallpaper()
    }
    else
        SetTimer, check_idel, % -idle_check_interval
}

next_wallpaper(){
    Run, % """" wallpaper_engine_exe_path """ -control nextWallpaper" , % wallpaper_engine_exe_dir
    SetTimer, check_idel, % -change_interval
}