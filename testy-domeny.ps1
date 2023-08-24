$domainController = "nazwa_kontrolera_domenu"
$pingResult = Test-Connection -ComputerName $domainController -Count 1 -ErrorAction SilentlyContinue

if ($pingResult) {
    Write-Host "Kontroler domeny $domainController jest dostępny."
} else {
    Write-Host "Nie można nawiązać połączenia z kontrolerem domeny $domainController."
}
#################################################################
$domainController = "nazwa_kontrolera_domenu"
$username = "nazwa_użytkownika"

$adUser = Get-ADUser -Filter {SamAccountName -eq $username} -Server $domainController -ErrorAction SilentlyContinue

if ($adUser) {
    Write-Host "Użytkownik $username istnieje w Active Directory."
} else {
    Write-Host "Użytkownik $username nie istnieje w Active Directory."
}
#################################################################
$domainController = "nazwa_kontrolera_domenu"
$username = "nazwa_użytkownika"
$newPassword = ConvertTo-SecureString "NoweHaslo123" -AsPlainText -Force

Set-ADAccountPassword -Identity $username -NewPassword $newPassword -Reset -Server $domainController
Write-Host "Hasło użytkownika $username zostało zmienione."
#################################################################
$domainController = "nazwa_kontrolera_domenu"
$username = "nowy_użytkownik"
$groupName = "nazwa_grupy"

Add-ADGroupMember -Identity $groupName -Members $username -Server $domainController
Write-Host "Użytkownik $username został dodany do grupy $groupName."
#################################################################
$domainController = "nazwa_kontrolera_domenu"
$username = "nazwa_użytkownika"

Set-ADAccountControl -Identity $username -Enabled $true -Server $domainController
Write-Host "Użytkownik $username został odblokowany."
#################################################################
$domainController = "nazwa_kontrolera_domenu"

$groups = Get-ADGroup -Filter * -Server $domainController
foreach ($group in $groups) {
    Write-Host "Grupa: $($group.Name)"
}
#################################################################
$domainController = "nazwa_kontrolera_domenu"

$domainInfo = Get-ADDomain -Server $domainController
Write-Host "Nazwa domeny: $($domainInfo.DistinguishedName)"
Write-Host "FQDN: $($domainInfo.DNSRoot)"
Write-Host "Kontroler domeny: $($domainInfo.PdcRoleOwner)"
#################################################################
$domainController = "nazwa_kontrolera_domenu"
$username = "nazwa_użytkownika"
$groupName = "nazwa_grupy"

Remove-ADGroupMember -Identity $groupName -Members $username -Server $domainController
Write-Host "Użytkownik $username został usunięty z grupy $groupName."
#################################################################
$domainController = "nazwa_kontrolera_domenu"
$username = "nazwa_użytkownika"
$attributeName = "Title"
$newAttributeValue = "Manager"

Set-ADUser -Identity $username -Replace @{$attributeName = $newAttributeValue} -Server $domainController
Write-Host "Atrybut $attributeName użytkownika $username został zaktualizowany."
#################################################################
$domainController = "nazwa_kontrolera_domenu"
$inactiveDays = 90

$inactiveUsers = Search-ADAccount -AccountInactive -TimeSpan ("$inactiveDays.00:00:00") -Server $domainController
foreach ($user in $inactiveUsers) {
    Write-Host "Użytkownik: $($user.Name) jest nieaktywny."
}