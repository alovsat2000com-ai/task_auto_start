$Target = "C:\Scripts"

# Safe mode: BAT files won't run real cleaners
$SafeMode = $true

try {
    # Create directory if not exists
    if (!(Test-Path $Target)) {
        New-Item -ItemType Directory -Path $Target -Force | Out-Null
    }

    # Base RAW URL
    $baseUrl = "https://raw.githubusercontent.com/alovsat2000com-ai/task_auto_start/main/"

    # Files list
    $files = @(
        "Cleaner_v6.bat",
        "RDP_Cleaner2.bat",
        "Cleare_time_startup_v2.1.xml",
        "RDP Cleaner2.1.xml"
    )

    foreach ($file in $files) {
        $url = $baseUrl + $file
        $outPath = "$Target\$file"

        try {
            if ($SafeMode -and $file -like "*.bat") {
                Write-Host "SAFE MODE: creating empty BAT for $file"
                Set-Content -Path $outPath -Value "echo SAFE MODE - script disabled"
            }
            else {
                Write-Host "Downloading: $file"
                Invoke-WebRequest -Uri $url -OutFile $outPath -ErrorAction Stop
            }
        }
        catch {
            Write-Warning "Download failed for $file : $($_.Exception.Message)"
        }
    }

    # Remove old tasks
    $tasks = @("Cleare_time_startup", "RDP Cleaner")

    foreach ($task in $tasks) {
        try { schtasks /delete /tn $task /f 2>&1 | Out-Null }
        catch { }
    }

    # Create new tasks
    schtasks /create /xml "$Target\Clear_time_startup_v2.xml" /tn "Cleare_time_startup" /f
    schtasks /create /xml "$Target\RDP_Cleaner2.xml" /tn "RDP Cleaner" /f

    Add-Content "$Target\deploy_log.txt" "$(Get-Date) SAFE MODE deployment completed"
    Write-Host "Deployment finished in SAFE MODE."
}
catch {
    $msg = "$(Get-Date) Deployment failed: $($_.Exception.Message)"
    Add-Content "$Target\deploy_log.txt" $msg
    Write-Error $msg
}
