$Target = "C:\Scripts"

# Создаем директорию если нет
if (!(Test-Path $Target)) {
    New-Item -ItemType Directory -Path $Target | Out-Null
}

# Скачивание BAT-файлов из GitHub RAW
Invoke-WebRequest "https://raw.githubusercontent.com/USER/REPO/main/Cleaner_v6.bat" -OutFile "$Target\Cleaner_v6.bat"
Invoke-WebRequest "https://raw.githubusercontent.com/USER/REPO/main/RDP_Cleaner2.bat" -OutFile "$Target\RDP_Cleaner2.bat"

# Скачивание XML расписаний
Invoke-WebRequest "https://raw.githubusercontent.com/USER/REPO/main/Clear_time_startup_v2.xml" -OutFile "$Target\Clear_time_startup_v2.xml"
Invoke-WebRequest "https://raw.githubusercontent.com/USER/REPO/main/RDP_Cleaner2.xml" -OutFile "$Target\RDP_Cleaner2.xml"

# Удаляем старые задания
schtasks /delete /tn "Cleare_time_startup" /f > $null 2>&1
schtasks /delete /tn "RDP Cleaner" /f > $null 2>&1

# Создаем новые задания по XML
schtasks /create /xml "$Target\Clear_time_startup_v2.xml" /tn "Cleare_time_startup" /f
schtasks /create /xml "$Target\RDP_Cleaner2.xml" /tn "RDP Cleaner" /f

Add-Content "$Target\deploy_log.txt" "$(Get-Date) — Deployment completed."
