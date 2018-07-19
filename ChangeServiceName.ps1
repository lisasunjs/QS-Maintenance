#Get a list of Qlik Sense Services

Get-Service "Ql*" | Format-List -Property Name

#Get the new service account details

$Credential=Get-Credential


#Create array based on the stopping order of Qlik Sense services

$svcs=@("QlikSenseEngineService","QlikSenseProxyService","QlikSensePrintingService","QlikSenseSchedulerService", 
"QlikSenseServiceDispatcher","QlikLoggingService","QlikSenseRepositoryService")

#Create the loop to stop/change service account for each Qlik Sense Service

$svcs | ForEach{ $svc_obj=Get-WMIObject Win32_Service -Filter "Name='$($_)'" 


$StopStatus=$svc_obj.StopService() 
IF ($StopStatus.ReturnValue -eq "0")
   {Write-host "The service '$svc_obj' Stopped successfully"}


$ChangeStatus=$svc_obj.change(
$null,$null,$null,$null,$null,$null, $Credential.UserName,$Credential.GetNetworkCredential().Password,$null,$null,$null)
IF ($ChangeStatus.ReturnValue -eq "0")
   {Write-host "The service '$svc_obj''s name/password has been changed successfully"}

}

#Create array based on the starting order of Qlik Sense services

$svcs_For_Start=@("QlikSenseRepositoryService","QlikSenseEngineService","QlikSenseProxyService","QlikSensePrintingService",
"QlikSenseServiceDispatcher","QlikSenseSchedulerService","QlikLoggingService")



$svcs_For_Start | ForEach{ $svc_obj=Get-WMIObject Win32_Service -Filter "Name='$($_)'" 

$StartStatus=$svc_obj.StartService()
IF ($StartStatus.ReturnValue -eq "0")
   {Write-host "The service '$svc_obj' has been started successfully" }

} 

