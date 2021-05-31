Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "C:\DeploymentShare"
import-mdtoperatingsystem -path "DS001:\Operating Systems" -SourcePath "C:\WIN10" -DestinationFolder "Windows 10 Pro x64" -Verbose
#IMPORT OS