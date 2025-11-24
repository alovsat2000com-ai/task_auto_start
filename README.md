Task Auto Start – RDP Cleaner + System Cleaner + Auto-Update

This project provides a fully automated system for:
* Cleaning RDP traces
* Running a system cleanup tool
* Keeping scripts auto-updated from GitHub
* Running continuously without Task Scheduler
* Starting automatically on system boot

Everything runs silently in the background.
---
🚀 **Features

✔ RDP cleanup every 5 minutes
✔ System cleanup on each login
✔ Automatic GitHub updates (every 5 minutes)
✔ No Task Scheduler required
✔ Works under SYSTEM
✔ One-click installation
✔ Fully silent background operation
---
📂 **Repository Contents

| File                 | Description                                            |
| -------------------- | ------------------------------------------------------ |
| **RUN_ME.bat**       | Starts installation with admin privileges              |
| **install.ps1**      | Creates C:\Scripts, downloads files, sets autostart    |
| **rdp_loop.ps1**     | Infinite loop: cleans RDP + checks GitHub updates      |
| **update.ps1**       | Compares local files with GitHub and updates if needed |
| **Cleaner_v6.bat**   | System cleanup tool (temp, caches, logs, junk)         |
| **RDP_Cleaner2.bat** | RDP history cleaner (servers, MRU, Default.rdp, cache) |
---

🛠 Installation
1. Download this repository (ZIP).
2. Run **RUN_ME.bat**.
3. The script will:
   * Create `C:\Scripts`
   * Download all required files
   * Add two autostart registry entries
   * Launch the RDP cleaning loop
4. No further configuration is required.
---

🔄 Auto-Update Behavior

Every 5 minutes:
1. `rdp_loop.ps1` calls `update.ps1`
2. `update.ps1` checks GitHub for new versions
3. If a file has changed — it is downloaded and replaced

This allows seamless updates without touching the remote machine.
---

🧹 Cleanup Details

RDP_Cleaner2.bat cleans:
* Default.rdp
* Server list
* Recent RDP connections
* MRU keys
* Cache files
* Clipboard traces
* Recycle bin

Cleaner_v6.bat cleans:
* Temporary files
* Browser caches
* Explorer cache
* Windows logs
* System junk
---

🔐 Requirements
* Windows 10 / Windows 11
* PowerShell 5+
* Admin rights only during installation
* Internet connection for updates
---
🛑 Uninstall / Disable

To stop the system entirely:

Delete these registry keys:

```
HKLM\Software\Microsoft\Windows\CurrentVersion\Run\Cleaner
HKLM\Software\Microsoft\Windows\CurrentVersion\Run\RDPLoop
```

Then delete:

```
C:\Scripts
```

Reboot for clean removal.

------

Хочешь я ещё дам тебе **идеальный .gitignore** для PowerShell/Windows?
