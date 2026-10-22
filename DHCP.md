Run this in **Windows PowerShell as Administrator** on the server that will provide DHCP:

```powershell
$ErrorActionPreference = 'Stop'

Install-WindowsFeature DHCP -IncludeManagementTools
Import-Module DhcpServer

Add-DhcpServerv4Scope `
    -Name '10.56.1.0 LAN' `
    -StartRange 10.56.1.100 `
    -EndRange 10.56.1.199 `
    -SubnetMask 255.255.255.0 `
    -State Active

# Replace with this DC's static IPv4 address
$dcIp = '10.56.1.254'

Set-DhcpServerv4OptionValue `
    -ScopeId 10.56.1.0 `
    -Router 10.56.1.254 `
    -DnsServer $dcIp `
    -DnsDomain '123456jd.internal'

Get-DhcpServerv4Scope -ScopeId 10.56.1.0
Get-DhcpServerv4OptionValue -ScopeId 10.56.1.0

# Authorize this DHCP server in Active Directory
Add-DhcpServerInDC
```

---

Install DHCP without scope:

```powershell
Install-WindowsFeature DHCP -IncludeManagementTools
Import-Module DhcpServer
Add-DhcpServerInDC
Get-DhcpServerInDC
```

