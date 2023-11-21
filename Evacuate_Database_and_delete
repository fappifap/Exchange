#
# Moving all sorcecontent from a databse t an other database
#
#
#


$DatabaseSource = "MailDB02"
$DatabaseDestination = "MailDB01"

write-Host "Es wird von: " $DatabaseSource "zu:" $DatabaseDestination "kopiert!" -BackgroundColor Green -ForegroundColor Black
write-Host "Warte 10 Sekunden" -BackgroundColor Green -ForegroundColor Black
start-sleep -Seconds 10
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


write-host "Lösche Mailboximport Requests" -ForegroundColor Yellow 
Get-MailboxImportRequest -Status Completed | Remove-MailboxImportRequest -force
Get-MailboxImportRequest -Status Failed | Remove-MailboxImportRequest  -force
Get-MailboxImportRequest -Status CompletedWithWarning | Remove-MailboxImportRequest -force


$Moverequest = Get-MoveRequest

while ((Get-Moverequest | where-object {$PSItem.Status -ne "Completed" })){
    write-host "Moverequests in action ... Wait" -ForegroundColor Yellow
    start-sleep -Seconds 60
}


get-moverequest | Remove-MoveRequest -Force
write-host "Lösche Quelldatenbank ab"
start-sleep -Seconds 30
Get-MailboxDatabase -Identity $DatabaseSource | Remove-MailboxDatabase 
