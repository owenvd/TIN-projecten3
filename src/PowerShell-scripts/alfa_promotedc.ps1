# Active Directory installeren
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Stel de parameters in voor het forest
$Password=ConvertTo-SecureString 'Admin1' -AsPlainText -Force
$Params = @{
    CreateDnsDelegation = $false
    DatabasePath = 'C:\Windows\NTDS'
    DomainMode = 'WinThreshold'
    DomainName = 'CORONA2020.local'
    DomainNetbiosName = 'CORONA2020'
    ForestMode = 'WinThreshold'
    InstallDns = $false
    LogPath = 'C:\Windows\NTDS'
    SafeModeAdministratorPassword = $Password
    SkipPreChecks = $true
    SysvolPath = 'C:\Windows\SYSVOL'
    Force = $true
}
# Installeer het forest en promoveer de server tot DC. De server wordt automatisch opnieuw opgestart
Install-ADDSForest @Params
