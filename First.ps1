Write-Host "Hello,World!"
$nameRegex = "Q*"
#Get-WmiObject -List -Namespace root
#Get-WmiObject -Class Win32_OperatingSystem 
#Get-WmiObject Win32_OperatingSystem | Get-Member -MemberType Property
#Get-WmiObject Win32_Service -filter "name='$service'"

#Get-WmiObject Win32_Service -filter "name -like '$nameRegex'"
#gwmi win32_service | where {$_.StartMode -ne “Disabled”} | select-object Name | select-string -pattern 'A' | out-file C:\lisatest\pwoershell-\services.txt
Get-WMIObject Win32_Service -Filter "Name LIKE 'A%'" | Select -ExpandProperty Name
