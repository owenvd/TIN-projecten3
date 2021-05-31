New-Item -Path "C:\DeploymentShare" -ItemType directory
New-SmbShare -Name "DeploymentShare$" -Path "C:\DeploymentShare" -FullAccess Administrators
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
new-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root "C:\DeploymentShare" -Description "MDT Deployment Share" -NetworkPath "\\ECHO1\DeploymentShare$" -Verbose | add-MDTPersistentDrive -Verbose
#AANMAKEN SHARE