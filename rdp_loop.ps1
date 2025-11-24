$ScriptPath = "C:\Scripts\RDP_Cleaner2.bat"

while ($true) {

    # Обновление каждые 5 минут
    try {
        powershell -ExecutionPolicy Bypass -File "C:\Scripts\update.ps1"
    }
    catch {
        # просто игнорируем, если обновление упало
    }

    # Запуск RDP Cleaner
    if (Test-Path $ScriptPath) {
        Start-Process -FilePath $ScriptPath -WindowStyle Hidden -Wait
    }

    # Ожидание 5 минут
    Start-Sleep -Seconds 300
}
