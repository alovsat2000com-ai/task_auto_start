$Target = "C:\Scripts"

try {
    # Создаем директорию если нет
    if (!(Test-Path $Target)) {
        New-Item -ItemType Directory -Path $Target -Force | Out-Null
    }

    # Базовый URL для RAW файлов GitHub (исправлен)
    $baseUrl = "https://raw.githubusercontent.com/alovsat2000-com-ai/task_auto_start/main/"

    # Скачивание BAT-файлов из GitHub RAW
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
            Write-Host "Скачивание: $file"
            Invoke-WebRequest $url -OutFile $outPath -ErrorAction Stop
        }
        catch {
            Write-Warning "Ошибка скачивания $file : $($_.Exception.Message)"
            continue
        }
    }

    # Удаляем старые задания
    $tasks = @("Cleare_time_startup", "RDP Cleaner")
    
    foreach ($task in $tasks) {
        try {
            schtasks /delete /tn $task /f 2>&1 | Out-Null
            Write-Host "Задача удалена: $task"
        }
        catch {
            Write-Host "Задача не найдена или ошибка удаления: $task"
        }
    }

    # Создаем новые задания по XML
    try {
        schtasks /create /xml "$Target\Clear_time_startup_v2.xml" /tn "Cleare_time_startup" /f
        Write-Host "Задача создана: Cleare_time_startup"
    }
    catch {
        Write-Warning "Ошибка создания задачи Cleare_time_startup"
    }

    try {
        schtasks /create /xml "$Target\RDP_Cleaner2.xml" /tn "RDP Cleaner" /f
        Write-Host "Задача создана: RDP Cleaner"
    }
    catch {
        Write-Warning "Ошибка создания задачи RDP Cleaner"
    }

    Add-Content "$Target\deploy_log.txt" "$(Get-Date) — Deployment completed successfully."
    Write-Host "Деплой завершен успешно!"
}
catch {
    $errorMsg = "$(Get-Date) — Deployment failed: $($_.Exception.Message)"
    Add-Content "$Target\deploy_log.txt" $errorMsg
    Write-Error $errorMsg
}