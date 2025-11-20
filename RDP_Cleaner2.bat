@echo off

:: FULL CLEAN MODE
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default" /va /f
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers" /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers" >nul 2>&1

attrib -s -h "%userprofile%\documents\Default.rdp" >nul 2>&1
del "%userprofile%\documents\Default.rdp" >nul 2>&1

del /f /s /q /a "%AppData%\Microsoft\Windows\Recent\AutomaticDestinations\*" >nul 2>&1

del /q /s %systemdrive%\$Recycle.bin\* >nul 2>&1
for /d %%x in (%systemdrive%\$Recycle.bin\*) do @rd /s /q "%%x"

:: --- RESTORE MICROPHONE SETTINGS ---
REG ADD "HKCU\Software\Microsoft\Terminal Server Client\Default" /v RedirectAudioCapture /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\Microsoft\Terminal Server Client" /v RedirectAudioCapture /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\Microsoft\Terminal Server Client\Servers" /v AudioCapture /t REG_DWORD /d 1 /f

exit /b 0