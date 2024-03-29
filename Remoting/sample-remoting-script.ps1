# Sample Script for working on multiple machines

# Set location to save output file
$path = "\\FILESERVER01\BigDataShare"

# Retrieve Computer Info

if($env:COMPUTERNAME) {
    $name = $env:COMPUTERNAME
} else {
    $name = (Get-CimInstance -ClassName Win32_ComputerSystem).Name

}
$desktop = Get-CimInstance -ClassName Win32_Desktop

# Manufacterer details
$manufacterer = Get-CimInstance -ClassName Win32_ComputerSystem

# OS Details
$os = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property BuildNumber, BuildType, OSType, ServicePackMajorVersion, ServicePackMinorVersion

# Create machine specific report
$report = "$($path)\$($name)_Report.log"
New-Item $report -ItemType File -Value "Device Report"
Add-Content $report "************ DESKTOP DETAILS ************"
Add-Content $report $desktop
Add-Content $report "************ MANUFACTURER DETAILS ************"
Add-Content $report $manufacterer
Add-Content $report "************ OS DETAILS ************"
Add-Content $report $os
