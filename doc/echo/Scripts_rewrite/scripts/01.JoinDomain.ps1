 echo Doesnt need reboot
 pause
$domain = "CORONA2020.local"
$password = "P@ssw0rd" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\Administrator"
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential
