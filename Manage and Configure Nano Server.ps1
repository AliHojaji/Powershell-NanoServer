#--- Author : Ali Hojaji ---#

#--*-------------------------------------*--#
#---> Domain join and remote management <---#
#--*-------------------------------------*--#

#--> On nano-test for trusted hosts of local machine for winrm
set-Item WSMan:\localhost\Client\TrustedHosts "192.168.10.180"

#--> create a new session to Nano-Test
$nano = New-PSSession -ComputerName 192.168.10.180 -Credential (Get-Credential)

#--> use the djoin command-line utility to perform an offline domain join
djoin.exe /provision /domain test.local /machine NANO-Test /savefile ./test.blob

#--> copy blob to nano-test
copy-File -Path .\test.blob -DestinationPath c:\ -ToSession $nano

#--> enter the existing remote session
Enter-PSSession -Session $nano

#--> perform the offline domain join
djoin /requestodj /loadfile c:\test.blob C:\Windowspath C:\Windows /localos

#--> restart to complete the process
Restart-Computer


#--*----------------------*--#
#---> Package management <---#
#--*----------------------*--#

#--> enter a new remote session to nano-test
Enter-PSHostProcess -ComputerName NANO-Test

#--> install the nano server package provider
Install-PackageProvider NanoServerPackage

#--> import the nano server package Provider
Import-PackageProvider NanoServerPackage

#--> list all Packages
Find-Package -ProviderName NanoServerpackage

Get-Package -providerName NanoServerPackage

#--> install a package
Install-Package -Name Microsoft-NanoServer-Containers-Package