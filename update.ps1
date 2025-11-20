$Repo = "https://raw.githubusercontent.com/alovsat2000com-ai/task_auto_start/main/"
$LocalPath = "C:\Scripts"
$Files = @(
    "Cleaner_v6.bat",
    "RDP_Cleaner2.bat",
    "rdp_loop.ps1",
    "install.ps1"
)

foreach ($file in $Files) {
    try {
        $remote = Invoke-WebRequest -Uri ($Repo + $file) -UseBasicParsing -ErrorAction Stop
        $localFile = Join-Path $LocalPath $file

        if (!(Test-Path $localFile) -or ((Get-FileHash $localFile).Hash -ne (Get-FileHash -InputStream $remote.ContentStream).Hash)) {
            Write-Host "Updating $file from GitHub..."
            $remote.Content | Set-Content -Path $localFile -Force
        }
    }
    catch {
        Write-Host "Update failed for $file"
        continue
    }
}

Add-Content "$LocalPath\update.log" "$(Get-Date) — Update check completed."
