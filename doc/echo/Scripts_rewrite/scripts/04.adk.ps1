echo Installing ADK...
 pause
#install adk components
cmd /c C:\Sources\ADK8.1\adksetup.exe /quiet /installpath 'C:\Program Files (x86)\Windows Kits\8.1' /features OptionId.DeploymentTools OptionId.WindowsPreinstallationEnvironment OptionId.UserStateMigrationTool
