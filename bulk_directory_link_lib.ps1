# load Compare_File_Info_by_Handle
. "$PSScriptRoot\Compare_File_Info_by_Handle.ps1"

# get time stamp
$Script_Start_Time = Get-Date
$Timestamp = $Script_Start_Time.ToString($Timestamp_Format)

# for every file in $src make a hard link in $dest
# if alread exist a file at dest, move the exist to conflict_move_dir$move_sub_dir_suffix
function hard_link_copy {
    param (
        [string]$src,
        [string]$dst,
        [string]$conflict_move_dir,
        [string]$conflict_move_sub_dir_suffix
    )
    foreach ($file_path in (Get-ChildItem -LiteralPath $src -File -Recurse).FullName) {
        $hard_link_path = "$dst\$([System.IO.Path]::GetFileName($src))$($file_path.Substring($src.Length))"
        # if $hard_link_path exist same hardlink
        if (same_target $hard_link_path $file_path) { continue } # already created hard linked

        # if $hard_link_path has file, if so move to conflict_move_dir with $move_sub_dir_suffix
        if (path_exist $hard_link_path) {
            $conflict_move_path = "$conflict_move_dir\$([System.IO.Path]::GetFileName($src))$conflict_move_sub_dir_suffix$($file_path.Substring($src.Length))"
            [System.IO.Path]::GetDirectoryName($conflict_move_path)
            # move the file by createing it's hardlink
            $cmp = New-Item -Path $conflict_move_path -ItemType HardLink -Target $($hard_link_path -replace '(?=[\[\]])','`') -Force
            "Move ""$hard_link_path"" to ""$($cmp.FullName)"""
        }
        # make hardlink
        $($file_path -replace '(?=[\[\]])','`')
        $h = New-Item -Path $hard_link_path -ItemType HardLink -Target $($file_path -replace '(?=[\[\]])','`') -Force
        "Hardlink ""$file_path"" ""$($h.FullName))"""
    }
}

# for every directory in $src_dir, make a Junction in $dest
# will overwrit existing junctions
function junction_mirror {
    param (
        [string]$src_dir,
        [string]$dest
    )
    foreach ($sub_dir in Get-ChildItem -LiteralPath $src_dir -Directory) {
        $path = "$dest\$($sub_dir.Name) - $([System.IO.Path]::GetFileName($src_dir))"
        
        if (same_target $path $sub_dir.FullName) { continue }
        $j = New-Item -Path $path -Type Junction -Target $($sub_dir.FullName -replace '(?=[\[\]])','`') -Force
        "Junction at ""$($j.FullName)"" Target ""$($sub_dir.FullName)"""
    }
}

# remove invalid Junctions in $dir 
function clean_dir_invalid_junctions {
    param (
        $dir
    )
    foreach ($sub_dir in Get-ChildItem -LiteralPath $dir -Directory) {
        if (-Not (same_target $sub_dir.FullName $sub_dir.Target)) {
            Remove-Item -LiteralPath $sub_dir.FullName -Force 
            "Remove invalid junctions $($sub_dir.FullName)"
        }
    }    
}

# if files in $src_dir not found in $compare_dir, then move file $move_dir, preserving a file structure
function find_extra_files_move_location {
    param (
        [string]$src_dir,
        [string]$compare_dir,
        [string]$move_dir, 
        [string]$move_sub_dir_suffix
    )
    foreach ($dir in Get-ChildItem -LiteralPath $src_dir -Directory) {
        # for every mod folder
        foreach ($file in Get-ChildItem -LiteralPath $dir.FullName -File -Recurse) {
            # if same item then skip
            if (same_target $file.FullName "$compare_dir\$($dir.Name)$($file.FullName.Substring($dir.FullName.Length))") { continue }
            # elseMove item to $move_dir
            $m = New-Item -Path "$move_dir\$($dir.Name)$move_sub_dir_suffix$($file.FullName.Substring($dir.FullName.Length))" -ItemType HardLink -Target $($file.FullName -replace '(?=[\[\]])','`') -Force
            Remove-Item -LiteralPath $file.FullName
            "Move $($file.FullName) to $($m.FullName))"
        }
    }
}

#remove all sub directory with no files, (muilt layers of only directory)
function remove_dirs_with_nothing_but_sub_dirs_recurse {
    param (
        [string]$dir
    )
    foreach ($sub_dir in Get-ChildItem -LiteralPath $dir -Directory -Recurse | Sort-Object Length) {
        if ($sub_dir.GetFileSystemInfos().Count -eq 0) {
            Remove-Item -LiteralPath $sub_dir.FullName
        }
    }    
}
