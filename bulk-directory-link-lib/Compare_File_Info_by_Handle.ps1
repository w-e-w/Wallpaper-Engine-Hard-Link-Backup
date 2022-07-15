#   original source
#   https://superuser.com/questions/881547/how-to-determine-if-two-directory-pathnames-resolve-to-the-same-target
#   with modification and additions
function Global:Load_Compare_File_Info_by_Handle() {
    if (($null -eq ([System.Management.Automation.PSTypeName]'System.Win32').Type) -or ($null -eq [system.win32].getmethod('MY_AreParhEqual'))) {
        Add-Type -Name Win32 -MemberDefinition (Get-Content "$PSScriptRoot\Compare_File_Info_by_Handle.cs" -Raw) `
            -NameSpace System -UsingNamespace System.Text, Microsoft.Win32.SafeHandles, System.ComponentModel
    }
}
# loads the C# code
Load_Compare_File_Info_by_Handle

# this can determine if two path resolve to the same target
# ie HardlLink-HardlLink Junction-Junction Junction-Directory 
function same_target {
    param (
        [string]$path_1,
        [string]$path_2
    )
    [System.Win32]::MY_AreParhEqual($path_1, $path_2)
}

# used to determine if a path exists
# similar to Test-Path but faster
function path_exist {
    param (
        [string]$path
    )
    [System.Win32]::MY_Exist($path)
}

# get path file info, return null if path not exist
function path_info {
    param (
        [string]$path
    )
    [System.Win32]::MY_GetFileInfoFromPath($path)
}