@echo off

Forfiles -p "C:\Users\%UserName%\Downloads" -s -m * -c "cmd /c del /q /f @path"
Forfiles -p "C:\Users\%UserName%\Downloads" -s -m * -c "cmd /c rmdir /s /q @path"
Forfiles -p "C:\Users\%UserName%\Desktop" -s -m * -c "cmd /c del /q /f @path"
Forfiles -p "C:\Users\%UserName%\Desktop" -s -m * -c "cmd /c rmdir /s /q @path"
Forfiles -p "C:\Users\%UserName%\Documents" -s -m * -c "cmd /c del /q @path"
Forfiles -p "C:\Users\%UserName%\Documents" -s -m * -c "cmd /c rmdir /s /q @path"
Forfiles -p "C:\Users\%UserName%\Pictures" -s -m * -c "cmd /c del /q @path"
Forfiles -p "C:\Users\%UserName%\Pictures" -s -m * -c "cmd /c rmdir /s /q @path"

reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default" /va /f
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers" /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers"
attrib -s -h %userprofile%\documents\Default.rdp
del %userprofile%\documents\Default.rdp
del /f /s /q /a %AppData%\Microsoft\Windows\Recent\AutomaticDestinations

del /q /s %systemdrive%\$Recycle.bin\*
for /d %%x in (%systemdrive%\$Recycle.bin\*) do @rd /s /q "%%x
del /f /s /q %temp%\*.*
del /f /s /q %tmp%\*.*

del /F /Q %APPDATA%\Microsoft\Windows\Recent\*
del /F /Q %APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*
del /F /Q %APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*

