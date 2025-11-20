@echo off
setlocal ENABLEDELAYEDEXPANSION

:: Check admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Запрашиваю права администратора...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ==========================================
echo        AUTO INSTALLER STARTED
echo ==========================================

set TARGET=C:\Scripts
if not exist "%TARGET%" mkdir "%TARGET%"

echo Downloading latest install.ps1...
powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/alovsat2000com-ai/task_auto_start/main/install.ps1' -OutFile '%TARGET%\install.ps1'"

if not exist "%TARGET%\install.ps1" (
    echo FAILED TO DOWNLOAD INSTALLER
    pause
    exit /b
)

echo Running installation...
powershell -ExecutionPolicy Bypass -File "%TARGET%\install.ps1"

echo ==========================================
echo              DONE
echo ==========================================

pause
exit /b
