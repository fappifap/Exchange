<#
    .SYNOPSIS
    Evacuate_Database_and_delete
    Johannes Schüler
    https://github.com/DiggaTS/Exchange/blob/61555176b562d0b6b906d36a4c9576bd23cd36a0/Evacuate_Database_and_delete
    
    .DESCRIPTION
	evacuate a databse and delete the database in exchange

    Revision History 
    -------------------------------------------------------------------------------- 
    1.0     Initial release 

    .PARAMETER DatabaseSource
    The Database to delete

    .PARAMETER DatabaseDestination
    The Target Database

    .EXAMPLE
    Evacuate_Database_and_delete database1 database2

    .\Purge-LogFiles -DaysToKeep 7 -Auto
#>

param(
    [string]$DatabaseSource=(Read-Host "Bitte Quelldataenbank eingeben"),
    [string]$DatabaseDestination=(Read-Host "Bitte Zieldatenbank eingeben")
)

write-Host "Es wird von: " $DatabaseSource "zu:" $DatabaseDestination "kopiert!" -BackgroundColor Green -ForegroundColor Black
$Antwort = Read-Host -Prompt "Möchtest du fortfahren? (Ja/Nein)"

if ($Antwort -eq "Ja" -or $antwort -eq "ja") {
	#Arbitation databse
	get-mailbox -database $DatabaseSource  -Arbitration | New-MoveRequest -TargetDatabase $DatabaseDestination
	#Discovery Mailbox
	get-mailbox -Database $DatabaseSource -RecipientTypeDetails DiscoveryMailbox | New-MoveRequest -TargetDatabase $DatabaseDestination
	#User tool mailboxes
	Get-Mailbox -database $DatabaseSource -RecipientTypeDetails SharedMailbox, RoomMailbox, EquipmentMailbox | New-MoveRequest -TargetDatabase $DatabaseDestination
	#User mailboxes
	Get-Mailbox -database $DatabaseSource | New-MoveRequest -TargetDatabase $DatabaseDestination
	#Public Folder
	get-mailbox -Database $DatabaseSource -PublicFolder | New-MoveRequest -TargetDatabase $DatabaseDestination 
	#Audit log
	get-mailbox -Database $DatabaseSource -AuditLog | New-MoveRequest -TargetDatabase $DatabaseDestination
	}
elseif ($antwort -eq "Nein" -or $antwort -eq "nein" -or $antwort -eq "N" -or $antwort -eq "n" -or [string]::IsNullOrEmpty($antwort)) {

    	Write-Host "Du hast 'Nein' gewählt oder nichts eingegeben. Abbruch des Skripts."
	exit
}
else {
    Write-Host "Ungültige Eingabe. Bitte 'Ja' oder 'Nein' eingeben."
}


write-Host "Achtung es werden die ImportRequests gelöscht" -BackgroundColor Green -ForegroundColor Black
$Antwort = Read-Host -Prompt "Möchtest du fortfahren? (Ja/Nein)"

if ($Antwort -eq "Ja" -or $antwort -eq "ja") {
	Get-MailboxImportRequest -Status Completed | Remove-MailboxImportRequest -force
	Get-MailboxImportRequest -Status Failed | Remove-MailboxImportRequest  -force
	Get-MailboxImportRequest -Status CompletedWithWarning | Remove-MailboxImportRequest -force
	}
elseif ($antwort -eq "Nein" -or $antwort -eq "nein" -or $antwort -eq "N" -or $antwort -eq "n" -or [string]::IsNullOrEmpty($antwort)) {

    	Write-Host "Du hast 'Nein' gewählt oder nichts eingegeben. Abbruch des Skripts."
	exit
}
else {
    Write-Host "Ungültige Eingabe. Bitte 'Ja' oder 'Nein' eingeben."
}



$Moverequest = Get-MoveRequest

while ((Get-Moverequest | where-object {$PSItem.Status -ne "Completed" })){
    write-host "Moverequests in action ... Wait" -ForegroundColor Yellow
    start-sleep -Seconds 60
}

get-moverequest | Remove-MoveRequest -Force
write-host "Lösche Quelldatenbank ab"
start-sleep -Seconds 30

write-Host "Achtung es wird die Datenbank gelöscht" -BackgroundColor Green -ForegroundColor Black
$Antwort = Read-Host -Prompt "Möchtest du fortfahren? (Ja/Nein)"

if ($Antwort -eq "Ja" -or $antwort -eq "ja") {
	Get-MailboxDatabase -Identity $DatabaseSource | Remove-MailboxDatabase 
	}
elseif ($antwort -eq "Nein" -or $antwort -eq "nein" -or $antwort -eq "N" -or $antwort -eq "n" -or [string]::IsNullOrEmpty($antwort)) {

    	Write-Host "Du hast 'Nein' gewählt oder nichts eingegeben. Abbruch des Skripts."
	exit
}
else {
    Write-Host "Ungültige Eingabe. Bitte 'Ja' oder 'Nein' eingeben."
}

write-Host "Bitte .EDB der Datenbank löschen" -BackgroundColor Green -ForegroundColor Black

