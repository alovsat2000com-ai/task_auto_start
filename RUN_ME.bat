@echo off
setlocal ENABLEDELAYEDEXPANSION

:: Проверяем, есть ли админ-права
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Запрашиваю права администратора...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo -----------------------------------------
echo   AUTO-INSTALLER STARTED (Admin OK)
echo -----------------------------------------

:: Создаем папку для скриптов
set TARGET=C:\Scripts
if not exist "%TARGET%" (
    mkdir "%TARGET%"
    echo Папка %TARGET% создана.
)

:: Скачиваем install.ps1 с GitHub RAW
echo Загружаю install.ps1 из GitHub...
powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/alovsat2000com-ai/task_auto_start/main/install.ps1' -OutFile '%TARGET%\install.ps1' -ErrorAction Stop"

if not exist "%TARGET%\install.ps1" (
    echo !!! ОШИБКА: install.ps1 не был загружен.
    pause
    exit /b
)

echo Установка началась...
powershell -ExecutionPolicy Bypass -File "%TARGET%\install.ps1"

echo -----------------------------------------
echo     ГОТОВО. Скрипт отработал.
echo -----------------------------------------

pause
exit /b
