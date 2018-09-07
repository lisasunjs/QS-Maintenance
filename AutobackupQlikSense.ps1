#################################################################################################
#This script is used to auto backup Qlik Sense site                                             #
#                                                                                               #
#This script only needs to be run on central node in multi nodes envrionments                   #
#                                                                                               #
#Please note, always double check the services' running status after restarted                  #
#################################################################################################

$Today = Get-Date -UFormat "%Y%m%d_%H%M"

$StartTime = Get-Date -UFormat "%Y%m%d_%H%M"
 

$PostGreSQLLocation = "C:\Program Files\Qlik\Sense\Repository\PostgreSQL\9.6\bin"

$PostGresBackupTarget = "C:\SU_Backup"



# Shared Persistance Folder

 
$SenseProgramData = "\\SU-APAC\Share"
 

$Today = Get-Date -UFormat "%Y%m%d_%H%M"

$StartTime = Get-Date -UFormat "%Y%m%d_%H%M"

new-item "$PostGresBackupTarget\$StartTime" -itemtype directory


# Firstly stop all Qik Services except QRD 

write-host "Stopping Qlik Services ...."

 

stop-service QlikSenseProxyService -WarningAction SilentlyContinue

stop-service QlikSenseEngineService -WarningAction SilentlyContinue

stop-service QlikSenseSchedulerService -WarningAction SilentlyContinue

stop-service QlikSensePrintingService -WarningAction SilentlyContinue

stop-service QlikSenseServiceDispatcher -WarningAction SilentlyContinue

stop-service QlikLoggingService -WarningAction SilentlyContinue

stop-service QlikSenseRepositoryService -WarningAction SilentlyContinue

 

write-host "Backing up PostgreSQL Repository Database ...."

#Check pgpass.conf

<#
if (Test-Path $env:userprofile\AppData\Roaming\postgresql\pgpass.conf) {

} else {

    "localhost:4432:$([char]42):postgres:Password123!" | set-content pgpass.conf -Encoding Ascii

}
#>
 

cd $PostGreSQLLocation

.\pg_dump.exe -h localhost -p 4432 -U postgres -b -F t -f "$PostGresBackupTarget\$StartTime\QSR_backup_$Today.tar" QSR


write-host "PostgreSQL backup Completed"

 

write-host "Backing up Shared Persistance Data from $SenseProgramData ...."

 

Copy-Item  $SenseProgramData\ArchivedLogs -Destination $PostGresBackupTarget\$StartTime\Share\ArchivedLogs -Recurse

Copy-Item  $SenseProgramData\Apps -Destination $PostGresBackupTarget\$StartTime\Share\Apps -Recurse

Copy-Item  $SenseProgramData\StaticContent -Destination $PostGresBackupTarget\$StartTime\Share\StaticContent -Recurse

Copy-Item  $SenseProgramData\CustomData -Destination $PostGresBackupTarget\$StartTime\Share\CustomData -Recurse

Copy-Item  $SenseProgramData\OriginalQVF -Destination $PostGresBackupTarget\$StartTime\Share\OriginalQVF -Recurse


write-host "File Backup Completed"

 
<#
write-host "Restarting Qlik Services ...."

 

start-service QlikSenseRepositoryService -WarningAction SilentlyContinue

start-service QlikSenseEngineService -WarningAction SilentlyContinue

start-service QlikSenseSchedulerService -WarningAction SilentlyContinue

start-service QlikSensePrintingService -WarningAction SilentlyContinue

start-service QlikSenseServiceDispatcher -WarningAction SilentlyContinue

start-service QlikSenseProxyService -WarningAction SilentlyContinue

#>

$EndTime = Get-Date -UFormat "%Y%m%d_%H%M%S"

 

write-host "This backup process started at " $StartTime " and ended at " $EndTime