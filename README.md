Install WinGet: https://github.com/asheroto/winget-install

Download https://raw.githubusercontent.com/asheroto/winget-install/refs/heads/master/winget-install.ps1

Open PowerShell as **Administrator** and type

```powershell
Install-Script winget-install -Force
winget-install
```

---

Install Windows Terminal

```powershell
winget install --id Microsoft.WindowsTerminal -e
```

---

Simulate CPU stress on Windows: `stress-cpu.ps1`

```
powershell -ExecutionPolicy Bypass -File stress-cpu.ps1
```
