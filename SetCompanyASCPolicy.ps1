﻿#Set Global ASC Decisions

$secemail = "security@customdomain.com,user@customdomain.com"
$secphone = "1112223333"
$secnotify = "true"
$ownernotify = "true"
$datacollect = "on"


#Download file and place in C:\Temp

New-Item -ItemType Directory -Path C:\Temp

cd C:\Temp


#Download the ASC PS Module and Functions
Invoke-WebRequest "https://raw.githubusercontent.com/Javanite/Azure-Security-Center/master/Azure-Security-Center/Azure-Security-Center.psm1" -OutFile C:\Temp\Azure-Security-Center.psm1

#Import the ASC module, store module file in C:\temp\
Import-Module "C:\temp\Azure-Security-Center.psm1"

#Prompt Azure Owner for credetials to login and select azure subscriptions
Get-ASCCredential

#Loop through sunbscriptions on same AAD tenant and apply ASC Policy settings defined in variables
(Get-AzureRmSubscription).subscriptionId | foreach {
        Set-Variable -Name asc_subscriptionId -Value $_ -Scope Global 
        Set-ASCPolicy -PolicyName default -JSON (Build-ASCJSON -Policy -AllOn -SecurityContactEmail $secemail -SecurityContactPhone $secphone -SecurityContactNotificationsOn $secnotify -SecurityContactSendToAdminOn $ownernotify -DataCollection $datacollect )
    }

#Launch ASC in portal.azure.com for confirmation of setting changes. 
$Browser=new-object -com internetexplorer.application

$Browser.navigate2("https://portal.azure.com/#blade/Microsoft_Azure_Security/SecurityMenuBlade/1")

$Browser.visible=$true