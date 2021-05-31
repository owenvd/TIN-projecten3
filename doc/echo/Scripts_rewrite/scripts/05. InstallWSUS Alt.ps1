 echo Installing WSUS
 pause
#Install WSUS
Install-WindowsFeature -Name UpdateServices-Services,UpdateServices-DB -IncludeManagementTools
.\wsusutil.exe postinstall SQL_INSTANCE_NAME="DC1\SQL2016" CONTENT_DIR=C:\WSUS
