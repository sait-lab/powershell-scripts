### Sysprep Server Core

```
C:\Windows\System32\Sysprep\sysprep.exe /generalize /oobe /shutdown /mode:vm
```

---

### Update Server Core

Manage updates via PowerShell is using the **PSWindowsUpdate** module.

```
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name PSWindowsUpdate -Force
```

Check for available updates:

```
Get-WindowsUpdate
```

Download and install all available updates:

```
# Installs all updates, accepts all prompts, and auto-reboots if required:
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
```

Verify installation history:

```
Get-WUHistory -Last 10
```

---

### Windows Update Clean Up

#### 1\. Clean the WinSxS Component Store (DISM)

Windows retains older superseded versions of updated binaries inside `C:\Windows\WinSxS`. Use DISM to purge superseded update components:

```
# Analyze how much space can be reclaimed
dism.exe /Online /Cleanup-Image /AnalyzeComponentStore

# Purge superseded update versions
dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase

```

> **Warning:** `/ResetBase` makes all currently installed updates permanent, meaning you cannot uninstall previous cumulative updates or roll them back. This is ideal when preparing a template image.

**Verification:** Run the `/AnalyzeComponentStore` command again. Verify that `Component Store Cleanup Recommended` is reported as `No`.

#### 2\. Purge the SoftwareDistribution Download Cache

Windows Update stages downloaded `.cab` and `.msu` packages in `C:\Windows\SoftwareDistribution\Download`. Once updates are installed, these files are no longer needed:

```
# Stop update services
Stop-Service -Name wuauserv, bits -Force

# Delete downloaded update packages
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue

# Restart the update service
Start-Service -Name wuauserv

```

**Verification:** Run `Get-ChildItem -Path "C:\Windows\SoftwareDistribution\Download"` to confirm the folder is empty or contains negligible data.

#### 3\. Clear Windows Update Delivery Optimization Cache

```
# Clear delivery optimization cache files
Get-ChildItem -Path "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

```

#### 4\. (Optional) Run Headless Disk Cleanup (`cleanmgr.exe`)

While Server Core lacks the GUI interface for Disk Cleanup, `cleanmgr.exe` can run automated state tasks via the registry:

```
# Enable all cleanup handlers for StateFlags0001
$StateFlag = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
Get-ChildItem -Path $StateFlag | ForEach-Object {
    Set-ItemProperty -Path $_.PSPath -Name "StateFlags0001" -Value 2 -Type DWord
}

# Run automated disk cleanup
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait
```

#### Download this guide

```
Invoke-WebRequest -Uri 'https://caddy.dreamnet.ca/wincore' -OutFile 'file.txt' -UseBasicParsing
```