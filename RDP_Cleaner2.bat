@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM =========================================================
REM БЕЗОПАСНЫЙ RDP Cleaner - гарантированно сохраняет IP историю
REM =========================================================

REM 1) ОЧЕНЬ БЕЗОПАСНО: не используем reg delete, а очищаем значение через reg add
for /f "delims=" %%K in ('reg query "HKCU\Software\Microsoft\Terminal Server Client\Servers" 2^>nul') do (
  echo Обрабатываю: %%K
  reg add "%%K" /v UsernameHint /t REG_SZ /d "" /f >nul 2>&1
)

REM 2) Удаляем пароли из Credential Manager
cmdkey /list | findstr /i "TERMSRV" > "%TEMP%\rdp_creds.txt"
for /f "tokens=2 delims=:" %%G in ('type "%TEMP%\rdp_creds.txt"') do (
  set "cred=%%G"
  set "cred=!cred:~1!"
  if not "!cred!"=="" (
    echo Удаляю креденшиалы для: !cred!
    cmdkey /delete:"!cred!" >nul 2>&1
  )
)
del "%TEMP%\rdp_creds.txt" >nul 2>&1

echo.
echo [УСПЕХ] История серверов сохранена, креденшиалы удалены.
pause