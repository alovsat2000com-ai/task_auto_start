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
        $remoteFile = Invoke-WebRequest -Uri ($Repo + $file) -ErrorAction Stop
        $localFile = Join-Path $LocalPath $file
        
        # Хеш-функция (через bytes)
        $remoteBytes = $remoteFile.Content
        $remoteHash = (Get-FileHash -InputStream ([System.IO.MemoryStream]::new($remoteBytes))).Hash
        
        if (!(Test-Path $localFile)) {
            Write-Host "Downloading new file: $file"
            [System.IO.File]::WriteAllBytes($localFile, $remoteBytes)
            continue
        }

        $localHash = (Get-FileHash $localFile).Hash

        if ($localHash -ne $remoteHash) {
            Write-Host "Updating $file..."
            [System.IO.File]::WriteAllBytes($localFile, $remoteBytes)
        }
    }
    catch {
        Write-Host "Update failed for: $file"
        continue
    }
}

Add-Content "$LocalPath\update.log" "$(Get-Date) - Update completed"
