. "$PSScriptRoot\..\bulk-directory-link-lib\bulk_directory_link_lib.ps1"

# only do hard_link_copy if directory is valid wallpaper
function wallpaper_hard_link_copy {
    param (
        [string]$workshop_dir,
        [string]$hard_link_dir,
        [string]$conflict_move_dir,
        [string]$conflict_move_sub_dir_suffix
    )
    foreach ($wallpaper_path in Get-ChildItem -LiteralPath $workshop_dir -Directory) {
        # if directory is valid wallpaper then project.json exist
        if ((path_exist ($wallpaper_path.FullName + "\project.json"))) {
            hard_link_copy $wallpaper_path.FullName $hard_link_dir $conflict_move_dir $conflict_move_sub_dir_suffix
        }
    }
}
# for every wallpapers in $src_dir, if it's missing from $compare_dir, then move it to $move_dir/wallper$move_sub_dir_suffix
function wallpapers_src_dir_except_comp_dir_move {
    param (
        [string]$src_dir,
        [string]$compare_dir,
        [string]$move_dir, 
        [string]$move_sub_dir_suffix
    )
    foreach ($wallpaper_path in Get-ChildItem -LiteralPath $src_dir -Directory) {
        # if project.json is the same, then assume to be wallpaper to be the same
        if (same_target "$($wallpaper_path.FullName)\project.json" "$compare_dir\$($wallpaper_path.Name)\project.json") { continue }
        New-Item -Path "$move_dir" -ItemType Directory -Force | Out-Null
        Move-Item -LiteralPath $wallpaper_path.FullName -Destination "$move_dir\$($wallpaper_path.Name)$move_sub_dir_suffix" -Force
        "Move ""$($wallpaper_path.FullName)"" to ""$move_dir\$($wallpaper_path.Name)$move_sub_dir_suffix"""
    }
}
