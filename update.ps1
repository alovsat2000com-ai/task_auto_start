$Repo = "https://raw.githubusercontent.com/alovsat2000com-ai/task_auto_start/main/"
$LocalPath = "C:\Scripts"

# =========================
# GLOBAL DISABLE SWITCH
# =========================
try {
    Invoke-WebRequest -Uri ($Repo + "DISABLE.txt") -UseBasicParsing -ErrorAction Stop

    # If DISABLE.txt exists → shutdown everything
    taskkill /F /IM powershell.exe > $null 2>&1

    reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v Cleaner /f > $null 2>&1
    reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v RDPLoop /f > $null 2>&1

    Remove-Item "C:\Scripts" -Recurse -Force -ErrorAction SilentlyContinue

    exit
}
catch {
    # DISABLE flag not found → continue normal update
}

# =========================
# NORMAL UPDATE
# =========================
$Files = @(
    "Cleaner_v6.bat",
    "RDP_Cleaner2.bat",
    "rdp_loop.ps1",
    "install.ps1"
)

foreach ($file in $Files) {
    try {
        Invoke-WebRequest -Uri ($Repo + $file) -OutFile (Join-Path $LocalPath $file) -UseBasicParsing -ErrorAction Stop
    }
    catch {}
}
