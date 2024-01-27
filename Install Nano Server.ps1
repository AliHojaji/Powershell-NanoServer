#--- Author : Ali Hojaji ---#

#--*-----------------------*--#
#---> Install Nano Server <---#
#--*-----------------------*--#

#--> import nano server ps bits into session
Import-Module D:\NanoServer\NanoServerImageGenerator -Verbose


#---> NANO1-Test <---#

#--> create a basic nano server vhdx
New-NanoServerImage -MediaPath D: -BasePath .\Base -TargetPath .\NANO1-NUG.vhdx -DeploymentType Guest -Edition Datacenter -ComputerName NANO1-NUG -AdministratorPassword (ConvertTo-SecureString -String 'Pa$$w0rd' -AsPlainText -Force)

#--> create and start vm
New-VM -Name NANO1-NUG -VHDPath .\NANO1-Test.vhdx -MemoryStartupBytes 1GB -Generation 2 | start-VM

#--> begin a remote session using powershell direct
Enter-PSSession -VMName NANO1-Test

#--> view processes, services, event logs
Get-Process
Get-Service
Get-WinEvent

#--> end session
Exit-PSSession

#---> NANO2-Test <---#

#--> create a nano server web server
New-NanoServerImage -MediaPath D: -BasePath .\Base -TargetPath .\NANO2-Test.vhdx -DeploymentType Guest -Edition Datacenter -ComputerName NANO2-Test
                    -InterfaceName0rIndex Ethernet -Ipv4Address 192.168.10.80 -Ipv4SubnetMask 255.255.255.0 -Ipv4Gateway 192.168.10.1 -Ipv4Dns ("192.168.10.180","8.8.8.8") 
                    -Package Microsoft-NanoServer-IIS-Package -AdministratorPassword (ConvertTo-SecureString -String 'Pa$$w0rd' -AsPlainText -Force)

#--> view available packages
Get-NanoServerPackage -MediaPath D:

#--> create and start vm
New-VM -Name NANO2-NUG -VHDPath .\NANO2-NUG.vhdx -MemoryStartupBytes 1GB -SwitchName vSwitch -Generation 2| start-VM

#--> begin a remote session using powershell direct
Enter-PSSession -VMName NANO2-NUG

#--> view iis service, logs, files
Get-Service W3SVC
Get-WinEvent -ListLog Microsoft-IIs
Get-ChildItem -Path c:\inetpub

#--> view installed packages
Get-windowsPackage -Online

#--> disable firewall
Set-NatFirewallProfile -Name Public,Private,Domain -Enable Fales

#--> exit remote session
Exit-PSSession