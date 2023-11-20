#
# Moving all sorcecontent from a databse t an other database
#
#
#


$DatabaseSource = "Sorcedatase"
$DatabaseDestination = "Destinationdatabase"


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

get-moverequest
