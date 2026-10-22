A curated collection of PowerShell automation scripts designed to streamline Windows Server administration, monitoring, and maintenance.

Install WinGet: https://github.com/asheroto/winget-install

Download https://raw.githubusercontent.com/asheroto/winget-install/refs/heads/master/winget-install.ps1

Open PowerShell as **Administrator** and type

```powershell
Install-Script winget-install -Force
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
winget-install
```

---

Install Windows Terminal

```powershell
winget install --id Microsoft.WindowsTerminal -e
```

Install 7-zip

```powershell
winget install --id 7zip.7zip -e
```

Install Notepad++

```powershell
winget install -e --id Notepad++.Notepad++
```

