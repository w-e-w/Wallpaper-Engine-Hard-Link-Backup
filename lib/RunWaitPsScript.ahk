; RunWait a powershell script file, with option to output log
RunWaitPsScript(PS_Script, WorkingDir:="", Logs_Path:=""){
    WorkingDir := WorkingDir ? WorkingDir : A_ScriptDir
    If (Logs_Path)
        RunWait, Powershell -Command "$log = """"%Logs_Path%\$((Get-Date).ToString('yyyy-MM-dd HH-mm-ss')) $((Get-Item -LiteralPath '%PS_Script%').BaseName).log"""" `; New-Item -Path $log -Force | Out-Null `; & '.\%PS_Script%' | Out-File -LiteralPath $log `; Get-Item -LiteralPath $log | Where-Object {$_.Length -eq 0} | Remove-Item ", %WorkingDir%, Hide
    Else
        RunWait, Powershell -Command "& '.\%PS_Script%' | Out-Null", %WorkingDir%, Hide
}
