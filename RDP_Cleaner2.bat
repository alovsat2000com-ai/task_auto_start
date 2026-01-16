@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM =========================================================
REM RDP: Keep IP history + keep settings (fullscreen/audio/mic)
REM But ALWAYS remove saved username/password credentials
REM =========================================================

REM 1) Remove UsernameHint for all saved servers (keeps server keys/IP)
for /f "delims=" %%K in ('reg query "HKCU\Software\Microsoft\Terminal Server Client\Servers" 2^>nul ^| findstr /i "\\Servers\\"') do (
  reg delete "%%K" /v UsernameHint /f >nul 2>&1
)

REM 2) Remove saved RDP credentials from Windows Credential Manager
REM    Targets usually look like: TERMSRV/1.2.3.4 or TERMSRV/hostname
for /f "tokens=1,* delims=:" %%A in ('cmdkey /list ^| findstr /i "Target:" ^| findstr /i "TERMSRV/"') do (
  set "t=%%B"
  set "t=!t: =!"
  if not "!t!"=="" (
    cmdkey /delete:!t! >nul 2>&1
  )
)

REM 3) (Optional) also remove possible Domain:target=TERMSRV/... formats
for /f "tokens=1,* delims=:" %%A in ('cmdkey /list ^| findstr /i "Target:" ^| findstr /i "TERMSRV"') do (
  set "raw=%%B"
  set "raw=!raw: =!"
  echo !raw! | findstr /i "TERMSRV/" >nul
  if !errorlevel! EQU 0 (
    cmdkey /delete:!raw! >nul 2>&1
  )
)

exit /b 0
