# a simple ini reader that dose NOT comply with standard ini Format
function simple_read_ini {
    param (
        [string]$ini_path
    )
    $ini = @{}
    foreach ($line in Get-Content -LiteralPath $ini_path) {
        if ($line -match '^[^\s#;]+=.+') {
            $key = $line -replace '^([^=]+)=.*', '$1'
            $value = $line -replace '^[^=]+=(.+)', '$1'
            $ini.Add($key, $value)
        }
    }
    return $ini
}

# read .\..\config.ini
$ini = simple_read_ini "$PSScriptRoot\..\config.ini"

#load vars form ini
$HardLink_Sync = Invoke-Expression $ini.hardlink_sync
$Wallpaper_Backups = Invoke-Expression $ini.wallpaper_backups
$Trash = Invoke-Expression $ini.trash
$Timestamp_Format = Invoke-Expression $ini.timestamp_format
$Workshop_Content_431960 = Invoke-Expression $ini.workshop_content_431960
$Wallpaper_Engine_Import = Invoke-Expression $ini.wallpaper_engine_import
# test if Wallpaper Engine workshop content path is exist
if (-Not (Test-Path -Path $workshop_content_431960 -Type Container)) {
    Write-Error "Wallpaper Engine workshop content directory not found at:`n$workshop_content_431960"
    exit
}

# create directories
if ($null -eq (New-Item -Path $HardLink_Sync -ItemType Directory -Force)){
    Write-Error "Unable to create directory:`n$HardLink_Sync"
    exit
}
if ($null -eq (New-Item -Path $Wallpaper_Backups -ItemType Directory -Force)){
    Write-Error "Unable to create directory:`n$Wallpaper_Backups"
    exit
}
if ($null -eq (New-Item -Path $Wallpaper_Engine_Import -ItemType Directory -Force)){
    Write-Error "Unable to create directory:`n$Wallpaper_Engine_Import"
    exit
}
<# created on usage
if ($null -eq (New-Item -Path $Trash -ItemType Directory -Force)){
    Write-Error "Unable to create directory:`n$Trash"
    exit
}#>

# get time stamp
$Script_Start_Time = Get-Date
$Timestamp = $Script_Start_Time.ToString($Timestamp_Format)
