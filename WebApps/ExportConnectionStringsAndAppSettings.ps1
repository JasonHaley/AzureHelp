$subscriptionId = "<subscriptionId>"
$resourceGroupSource = "<source resource group>"
$webAppsource = "<source web app name>"
$slotSource = "<source slot>"

$appSettingsFileName = "appSettings.csv"
$connectionStringsFileName = "connectionStrings.csv"

Login-AzureRmAccount

Set-AzureRmContext -SubscriptionId $subscriptionId

# Load Existing Web App settings for source and target
$webAppSource = Get-AzureRmWebAppSlot -ResourceGroupName $resourceGroupSource -Name $webAppsource -Slot $slotSource

# Create csv files if file names are set
If ($appSettingsFileName -ne "") {
    $webAppsource.SiteConfig.AppSettings | Select-Object -Property Name, Value | Export-Csv -Path $appSettingsFileName -NoTypeInformation
}

If ($connectionStringsFileName -ne "") {
    $webAppsource.SiteConfig.ConnectionStrings | Select-Object -Property Name, Type, ConnectionString | Export-Csv -Path $connectionStringsFileName -NoTypeInformation
}