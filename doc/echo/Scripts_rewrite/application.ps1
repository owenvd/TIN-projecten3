Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "C:\DeploymentShare"
import-MDTApplication -path "DS001:\Applications" -enable "True" -Name "Install - Adobe Reader" -ShortName "Install - Adobe Reader" -Version "" -Publisher "" -Language "" -CommandLine "msiexec /i AcroRead.msi /q" -WorkingDirectory ".\Applications\Install - Adobe Reader" -ApplicationSourcePath "C:\setup\adobe\install" -DestinationFolder "Install - Adobe Reader" -Verbose
#ADOBE APPLICATION