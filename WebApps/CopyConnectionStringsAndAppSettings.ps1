$subscriptionId = "<subscriptionId>"
$resourceGroupSource = "<source resource group>"
$resourceGroupTarget = "<target resource group>"

$webAppsource = "<source web app name>"
$webAppTarget = "<target web app name>"

$slotSource = "<source slot>"
$slotTarget = "<target slot>"

Login-AzureRmAccount

Set-AzureRmContext -SubscriptionId $subscriptionId

# Load Existing Web App settings for source and target
$webAppSource = Get-AzureRmWebAppSlot -ResourceGroupName $resourceGroupSource -Name $webAppsource -Slot $slotSource

# Get reference to the source Connection Strings
$connectionStringsSource = $webAppSource.SiteConfig.ConnectionStrings

# Create Hash variable for Connection Strings
$connectionStringsTarget = @{}

# Copy over all Existing Connection Strings to the Hash
ForEach($connStringSource in $connectionStringsSource) {
    $connectionStringsTarget[$connStringSource.Name] = @{ Type = $connStringSource.Type.ToString(); Value = $connStringSource.ConnectionString }
}

# Save Connection Strings to Target
Set-AzureRmWebAppSlot -ResourceGroupName $resourceGroupTarget -Name $webAppTarget -Slot $slotTarget -ConnectionStrings $connectionStringsTarget

# Get reference to the source app settings
$appSettingsSource = $webAppSource.SiteConfig.AppSettings

# Create Hash variable for App Settings
$appSettingsTarget = @{}

# Copy over all Existing App Settings to the Hash
ForEach ($appSettingSource in $appSettingsSource) {
    $appSettingsTarget[$appSettingSource.Name] = $appSettingSource.Value
}

# Save Connection Strings to Target
Set-AzureRmWebAppSlot -ResourceGroupName $resourceGroupTarget -Name $webAppTarget -Slot $slotTarget -AppSettings $appSettingsTarget
