Set ws = CreateObject("Wscript.Shell")
Set wmiService = GetObject("winmgmts:\\.\root\cimv2")
Set fs = CreateObject("Scripting.FileSystemObject")

' 当前脚本所在目录
currentPath = fs.GetFile(Wscript.ScriptFullName).ParentFolder.Path

' 开启端口转发
Set wmiObjects = wmiService.ExecQuery("SELECT * FROM Win32_process where name='nginx.exe'")
If wmiObjects.count = 0 Then
  nginxDir = currentPath & "\Nginx"
  ws.run "cmd /c cd " & nginxDir & " && start nginx", vbhide
End If

' 启动X Server
Set wmiService = GetObject("winmgmts:\\.\root\cimv2")
Set wmiObjects = wmiService.ExecQuery("SELECT * FROM Win32_process where name='vcxsrv.exe'")
If wmiObjects.count = 0 Then
  Set fs = CreateObject("Scripting.FileSystemObject")
  scriptPath = fs.GetFile(Wscript.ScriptFullName).ParentFolder.Path
  vcxsrvPath = scriptPath & "\VcXsrv\vcxsrv.exe"
  ws.run vcxsrvPath & " -multiwindow -noprimary -wgl -ac", vbhide
End If

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
