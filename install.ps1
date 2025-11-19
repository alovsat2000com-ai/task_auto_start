$Target = "C:\Scripts"

# Безопасный режим — НЕ выполнять чистку, создавать пустые BAT-файлы
$SafeMode = $true   

try {
    # Создаем директорию если нет
    if (!(Test-Path $Target)) {
        New-Item -ItemType Directory -Path $Target -Force | Out-Null
    }

    # Базовый URL для RAW файлов GitHub
    $baseUrl = "https://raw.githubusercontent.com/alovsat2000com-ai/task_auto_start/main/"

    # Список файлов, которые должны быть скачаны
    $files = @(
        "Cleaner_v6.bat",
        "RDP_Cleaner2.bat", 
        "Clear_time_startup_v2.xml",
        "RDP_Cleaner2.xml"
    )

    foreach ($file in $files) {
        $url = $baseUrl + $file
        $outPath = "$Target\$file"

        try {
            if ($SafeMode -and $file -like "*.bat") {
                Write-Host "SAFE MODE: Создаётся пустой BAT вместо $file"
                Set-Content -Path $outPath -Value "echo SAFE MODE — script disabled"
            }
            else {
                Write-Host "Скачивание: $file"
                Invoke-WebRequest $url -OutFile $outPath -ErrorAction Stop
            }
        }
        catch {
            Write-Warning "Ошибка скачивания $file : $($_.Exception.Message)"
            continue
        }
    }

    # Удаляем старые задачи
    $tasks = @("Cleare_time_startup", "RDP Cleaner")
    
    foreach ($task in $tasks) {
        schtasks /delete /tn $task /f 2>&1 | Out-Null
    }

    # Создаём новые задачи
    schtasks /create /xml "$Target\Clear_time_startup_v2.xml" /tn "Cleare_time_startup" /f
    schtasks /create /xml "$Target\RDP_Cleaner2.xml" /tn "RDP Cleaner" /f

    Add-Content "$Target\deploy_log.txt" "$(Get-Date) — SAFE MODE deployment completed successfully."
    Write-Host "Деплой завершён в SAFE MODE. Никакие данные НЕ удаляются."
}
catch {
    $errorMsg = "$(Get-Date) — Deployment failed: $($_.Exception.Message)"
    Add-Content "$Target\deploy_log.txt" $errorMsg
    Write-Error $errorMsg
}
