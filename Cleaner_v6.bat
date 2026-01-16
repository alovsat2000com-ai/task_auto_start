@echo off
setlocal

REM ==============================
REM SAFE OFFICE CLEANER (v6-safe)
REM - NO Documents/Desktop/Downloads wipe
REM - NO RDP settings touch
REM ==============================

REM Temp folders
del /f /s /q "%TEMP%\*.*" >nul 2>&1
del /f /s /q "%TMP%\*.*"  >nul 2>&1
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1

REM Recent items (optional, safe-ish)
del /f /q "%APPDATA%\Microsoft\Windows\Recent\*.*" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*.*" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*.*" >nul 2>&1

REM Recycle Bin (all drives)
for /d %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
  if exist "%%D:\$Recycle.Bin" (
    rd /s /q "%%D:\$Recycle.Bin" >nul 2>&1
  )
)

exit /b 0
