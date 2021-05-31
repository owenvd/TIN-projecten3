Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "C:\DeploymentShare"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "WIN10 PRO" -Template "Client.xml" -Comments "" -ID "WIN10" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 10 Pro in Windows 10 Pro x64 install.wim" -FullName "KELVIN" -OrgName "KELVIN" -HomePage "www.google.be" -Verbose
#TASK-SEQUENCE