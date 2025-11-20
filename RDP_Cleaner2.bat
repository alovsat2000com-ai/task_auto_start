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

:: ------------------------------------
:: RESTORE MICROPHONE & AUDIO SETTINGS
:: ------------------------------------

:: Enable microphone redirection
REG ADD "HKCU\Software\Microsoft\Terminal Server Client" /v RedirectAudioCapture /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\Microsoft\Terminal Server Client\Default" /v RedirectAudioCapture /t REG_DWORD /d 1 /f

:: RDP audio input ON
REG ADD "HKCU\Software\Microsoft\Terminal Server Client\Default" /v AudioCapturingMode /t REG_DWORD /d 1 /f

:: Audio redirection mode:
:: 0 = bring to this computer
:: 1 = leave at remote computer
REG ADD "HKCU\Software\Microsoft\Terminal Server Client\Default" /v AudioMode /t REG_DWORD /d 0 /f

:: Compatibility key for default.rdp recreation
REG ADD "HKCU\Software\Microsoft\Terminal Server Client\Servers" /v AudioCapture /t REG_DWORD /d 1 /f

:: Force creation of a basic Default.rdp so Windows doesn't revert settings
echo screen mode id:i:1>a "%userprofile%\Documents\Default.rdp"
echo redirectprinters:i:1>>"%userprofile%\Documents\Default.rdp"
echo audiocapturemode:i:1>>"%userprofile%\Documents\Default.rdp"
echo audiomode:i:0>>"%userprofile%\Documents\Default.rdp"

exit /b 0