

$DatabaseSource = "Sorcedatase"
$DatabaseDestination = ""


#Arbitation databse
get-mailbox -database $DatabaseSource  -Arbitration | New-MoveRequest -TargetDatabase $DatabaseDestination
#Discovery Mailbox
get-mailbox -Database “database01” -RecipientTypeDetails DiscoveryMailbox | New-MoveRequest -TargetDatabase database1
get-mailbox -Database “Mailbox_Database_4” -RecipientTypeDetails DiscoveryMailbox | New-MoveRequest -TargetDatabase database02

Get-Mailbox -Server OK-Exchange -RecipientTypeDetails SharedMailbox, RoomMailbox, EquipmentMailbox | New-MoveRequest -TargetDatabase database02  
get-mailbox -Database database01 -RecipientTypeDetails Shared, Roommailbox, EquipmentMailbox | New-MoveRequest -TargetDatabase database1 
get-mailbox -Database database02 -PublicFolder | New-MoveRequest -TargetDatabase 



get-mailbox -Database database01 -AuditLog | New-MoveRequest -TargetDatabase database1
