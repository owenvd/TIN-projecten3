# Maak nieuwe afdelingen aan
New-ADOrganizationalUnit -Name "IT-Administratie" -Path "DC=CORONA2020,DC=local"
New-ADOrganizationalUnit -Name "Verkoop" -Path "DC=CORONA2020,DC=local"
New-ADOrganizationalUnit -Name "Administratie" -Path "DC=CORONA2020,DC=local"
New-ADOrganizationalUnit -Name "Ontwikkeling" -Path "DC=CORONA2020,DC=local"
New-ADOrganizationalUnit -Name "Directie" -Path "DC=CORONA2020,DC=local"

# Maak werkstations aan
New-ADComputer -Name "ITADMIN-werkstation" -Path "OU=IT-Administratie,DC=CORONA2020,DC=local"
New-ADComputer -Name "VERKOOP-werkstation" -Path "OU=Verkoop,DC=CORONA2020,DC=local"
New-ADComputer -Name "ADMIN-werkstation" -Path "OU=Administratie,DC=CORONA2020,DC=local"
New-ADComputer -Name "ONTWIK-werkstation" -Path "OU=Ontwikkeling,DC=CORONA2020,DC=local"
New-ADComputer -Name "DIREC-werkstation" -Path "OU=Directie,DC=CORONA2020,DC=local"

# Maak gebruikers aan met behulp van een csv-bestand
Import-Csv "\\VBOXSVR\src\ADUsers.csv" | ForEach-Object {
$upn = $_.SamAccountName + “@corona2020.com” 
$password=ConvertTo-SecureString 'Pa$$w0rd' –asplaintext –force
New-ADUser -Name $_.Name `
 -GivenName $_."GivenName" `
 -Surname $_."Surname" `
 -SamAccountName  $_."samAccountName" `
 -UserPrincipalName  $upn `
 -Path $_."Path" `
 -AccountPassword $password `
 -ChangePasswordAtLogon $true `
 -Enabled $true
}

# Maak een nieuwe group policy
New-GPO -Name "NoControlPanel" 
# Verbied de toegang tot het control panel voor de group policy
Set-GPRegistryValue -Name "NoControlPanel" -key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -ValueName NoControlPanel -Type DWORD -value 01
# Voeg de group policy toe aan de juiste afdelingen
New-GPLink -Name "NoControlPanel" -Target "OU=Verkoop,DC=CORONA2020,DC=local"
New-GPLink -Name "NoControlPanel" -Target "OU=Administratie,DC=CORONA2020,DC=local"
New-GPLink -Name "NoControlPanel" -Target "OU=Ontwikkeling,DC=CORONA2020,DC=local"
New-GPLink -Name "NoControlPanel" -Target "OU=Directie,DC=CORONA2020,DC=local"

# Maak een nieuwe group policy 
New-GPO -Name "NoGamesLinkMenu"
# Verwijder het games link menu uit het startmenu voor de group policy
Set-GPRegistryValue -Name "NoGamesLinkMenu" -key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -ValueName NoStartMenuMyGames -Type DWORD -value 01
# Voeg de group policy toe aan alle afdelingen in het domein
New-GPLink -Name "NoGamesLinkMenu" -Target "DC=CORONA2020,DC=local"

# Maak een nieuwe group policy 
New-GPO -Name "NoNetworkAdapterProperties"
# Verbied toegang tot eigenschappen van netwerkadapters voor de group policy
Set-GPRegistryValue -Name "NoNetworkAdapterProperties" -key "HKCU\Software\Policies\Microsoft\Windows\Network Connections" -ValueName NC_LanProperties -Type DWORD -value 0
# Voeg de group policy toe aan de juiste afdelingen
New-GPLink -Name "NoNetworkAdapterProperties" -Target "OU=Verkoop,DC=CORONA2020,DC=local"
New-GPLink -Name "NoNetworkAdapterProperties" -Target "OU=Administratie,DC=CORONA2020,DC=local"

# Installeer DFS en de bijhorende management tools
Install-WindowsFeature -Name FS-DFS-Namespace –IncludeManagementTools 
# Maak mappen aan die je als shared folders wil gebruiken
$folders = (‘C:\dfsroots\files’,’C:\shares\IT-Administratie’,’C:\shares\Verkoop’,’C:\shares\Administratie’,’C:\shares\Ontwikkeling’,’C:\shares\Directie’) 
mkdir -path $folders
# Stel deze mappen in als shared folders
$folders | ForEach-Object {$sharename = (Get-Item $_).name; New-SMBShare -Name $shareName -Path $_ -FullAccess "Administrators" -ChangeAccess "Users"}
# Maak een DFS namespace aan in het domein en koppel deze aan de shared folder
New-DfsnRoot -Path \\CORONA2020.local\files -TargetPath \\alfa\files -Type DomainV2
# Creëer voor elke afdeling een DFS folder
$folders | Where-Object {$_ -like "*shares*"} | ForEach-Object {$name = (Get-Item $_).name; $DfsPath = (‘\\CORONA2020.local\files\’ + $name); $targetPath = (‘\\alfa\’ + $name);New-DfsnFolderTarget -Path $dfsPath -TargetPath $targetPath}

