check_idel(){
    if (A_TimeIdlePhysical > idle_time_require)
        next_wallpaper()
    else
        SetTimer, check_idel, % -idle_check_interval
}

next_wallpaper(){
    Run, % """" wallpaper_engine_exe_path """ -control nextWallpaper" , % wallpaper_engine_exe_dir
    SetTimer, check_idel, % -change_interval
}