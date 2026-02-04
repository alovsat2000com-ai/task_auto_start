$Target = "C:\Scripts"

# Create folder
if (!(Test-Path $Target)) {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
}

# BASE URL
$baseUrl = "https://raw.githubusercontent.com/alovsat2000com-ai/task_auto_start/main/"

# Download files from GitHub
$files = @(
    "DISABLE.txt"
    "Cleaner_v6.bat",
    "RDP_Cleaner2.bat",
    "update.ps1"
)

foreach ($file in $files) {
    try {
        Invoke-WebRequest -Uri ($baseUrl + $file) -OutFile "$Target\$file" -ErrorAction Stop
        Write-Host "Downloaded $file"
    }
    catch {
        Write-Host "Error downloading: $file"
    }
}

# Create cleaner_v6.ps1 (runs Cleaner once per login)
$cleanerPS = @"
Start-Process -WindowStyle Hidden -FilePath 'C:\Scripts\Cleaner_v6.bat'
"@
Set-Content -Path "$Target\cleaner_v6.ps1" -Value $cleanerPS -Encoding UTF8

# Create rdp_loop.ps1 (runs RDP cleaner every 5 min + auto-update)
$rdpLoopPS = @"
\$ScriptPath = 'C:\Scripts\RDP_Cleaner2.bat'

while (\$true) {

    # Check for updates every 24 hours
    \$LastUpdate = 'C:\Scripts\last_update.txt'
    if (!(Test-Path \$LastUpdate) -or (Get-Date) - (Get-Item \$LastUpdate).LastWriteTime -gt (New-TimeSpan -Hours 24)) {
        powershell -ExecutionPolicy Bypass -File C:\Scripts\update.ps1
        Set-Content \$LastUpdate (Get-Date)
    }

    # Run RDP Cleaner
    if (Test-Path \$ScriptPath) {
        Start-Process -FilePath \$ScriptPath -WindowStyle Hidden -Wait
    }

    # Wait 5 minutes
    Start-Sleep -Seconds 300
}
"@
Set-Content -Path "$Target\rdp_loop.ps1" -Value $rdpLoopPS -Encoding UTF8

# AUTOSTART via Registry
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v Cleaner /t REG_SZ /d "powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File C:\Scripts\cleaner_v6.ps1" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v RDPLoop /t REG_SZ /d "powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File C:\Scripts\rdp_loop.ps1" /f

# Start RDP loop immediately
Start-Process -WindowStyle Hidden powershell -ArgumentList "-ExecutionPolicy Bypass -File C:\Scripts\rdp_loop.ps1"

Write-Host "Installation complete. Autostart added. RDP loop running."
