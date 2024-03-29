# Create and manage PSSessions

## Methods for creating PSCredential

```powershell

# Basic
$cred = Get-Credential
$cred = Get-Credential -Credential "domain\user"

# Using Secure String
# Create a secure string and pass to PSCredential object
# Create the full PSCredential Object
$user = "domain\user"
$pwd = ConvertTo-SecureString "P455w0rd123" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($user,$pwd)

# Same as above just expanded out
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user,$pwd

```

## Implementing Trusted Hosts

Trusted hosts are machines which under normal circumstances would not be able to remotely manage machines in a domain.

- Workgroup machine being able to remotely manage a domain joined machine
- Remote machine is not part of a domain or part of an untrusted domain
- Workstation which requires different credentials - Local instead of domain

### Trusted Host Entries

These can include

- IP Version 4 Address
- IP Version 6 Address
- FQDN or Domain Name
- Wildcard

If accessing a domain joined machine from a workgroup (non-domain) machine you would:

- Add trusted host entry on the domain joined machine with IP Address of client
- Add trusted host entry on the client machine with IP Address of domain joined machine

```powershell
# Create using the command prompt
winrm set winrm/config/client @{TrustedHosts = "192.168.1.36"}

# Create using PowerShell
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "192.168.1.36" -Force

# Adding additional Trusted Hosts on machine which already has trusted hosts
$hosts = (Get-Item -Path WSMan:\localhost\Client\TrustedHosts).Value
Set-Item -Path WSMan:\localhost\Client\TrustedHosts "$hosts, 192.168.1.36" -Force

```

### Create, Reuse and Remove PSSessions

```powershell

# Execute a command on a Remote Computer
Invoke-Command -ComputerName "10.0.0.5" -ScriptBlock { Get-ComputerInfo }

# Execute a Script on a Remote Computer
Invoke-Command -ComputerName "10.0.0.5" -FilePath "C:\Scripts\AScript.ps1"

# Use a persistent session
$sess = New-PSSession -ComputerName "10.0.0.5"
Invoke-Command -Session $ps { Get-ComputerInfo }

# Using an Interactive Session
# Enter-PSSession to a PowerShell Session on the specified computer
Enter-PSSession -ComputerName "10.0.0.5"

# Create a New PowerShell Session but not connect to it
New-PSSession -ComputerName "10.0.0.5"
Get-PSSession

# Create a persistent PowerShell session in a variable
$sess = New-PSSession -ComputerName "10.0.0.5"

# Connect to a PowerShell session on the specified computer, using port and credential
$cred = Get-Credential
Enter-PSSession -ComputerName "10.0.0.5" -Port 99 -Credential $cred

# Remove PowerShell Sessions
# Remove all Sessions
Get-PSSession | Remove-PSSession

# Same as above
$ps = Get-PSSession # Could supply -Id if you know the session Id to get specific session
Remove-PSSession -Session $ps

```

### Modifying Session Properties

Use the New-PSSessionOption command to modify session properties to configure properties such as:

- Compression
- Access Properties
- Certificate Settings
- Encryption
- Language
- Application Arguments
- Timeouts

```powershell

# Create Default Session Options
New-PSSessionOption

# Define the Session options
$options = New-PSSessionOption
$options.OpenTimeout = (New-Timespan -Minutes 4)
$options.NoEncryption = $true
$options.UICulture = (Get-UICulture)

New-PSSession -ComputerName "10.0.0.5" -SessionOption $options

```
