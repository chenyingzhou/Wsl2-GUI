Set ws = CreateObject("Wscript.Shell")
Set wmiService = GetObject("winmgmts:\\.\root\cimv2")
Set fs = CreateObject("Scripting.FileSystemObject")

' 当前脚本所在目录
currentPath = fs.GetFile(Wscript.ScriptFullName).ParentFolder.Path

' 获取待执行命令
Set oArgs = WScript.Arguments
cmd = ""
For Each s In oArgs
   cmd = cmd & " " & s
Next

' 执行子系统命令
wslDirPart0 = "/mnt/" & Lcase(Left(currentPath, 1))
wslDirPart1 = Replace(Mid(currentPath, 4), "\", "/")
wslScript = wslDirPart0 & "/" & wslDirPart1 & "/wsl2-run-app.sh"
ws.run "cmd /c wsl -u root " & wslScript & " " & cmd, vbhide
