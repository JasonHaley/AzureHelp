$subscriptionId = "<subscriptionId>"
$resourceGroupSource = "<source resource group>"
$webAppsource = "<source web app name>"
$slotSource = "<source slot>"

$appSettingsFilePath = "<drive path to settings.config>"
$connectionStringsFilePath = "<drive path to connections.config>"

Login-AzureRmAccount

Set-AzureRmContext -SubscriptionId $subscriptionId

# Load Existing Web App settings for source and target
$webAppSource = Get-AzureRmWebAppSlot -ResourceGroupName $resourceGroupSource `
   -Name $webAppsource -Slot $slotSource

# Create config files if file paths are set
If ($appSettingsFileName -ne "") {
    $settings = $webAppsource.SiteConfig.AppSettings | Select-Object `
        -Property Name, Value

    [xml]$settingsDoc = New-Object System.Xml.XmlDocument
    	
    $sroot = $settingsDoc.CreateNode("element","appSettings",$null)

    foreach ($setting in $settings) {
        $c = $settingsDoc.CreateNode("element","add",$null)
        $c.SetAttribute("key",$setting.Name)
        $c.SetAttribute("value", $setting.Value)
        $sroot.AppendChild($c)
    }
    $settingsDoc.AppendChild($sroot) | Out-Null
    $settingsDoc.Save($appSettingsFilePath)
}

If ($connectionstringsfilename -ne "") {
    $connections = $webappsource.siteconfig.connectionstrings | Select-Object `
         -property Name, Type, ConnectionString

    [xml]$connectionsDoc = New-Object System.Xml.XmlDocument
    	
    $croot = $connectionsDoc.CreateNode("element","connectionStrings",$null)

    foreach ($connection in $connections) {
        $c = $connectionsDoc.CreateNode("element","add",$null)
        $c.SetAttribute("name",$connection.Name)
        $c.SetAttribute("connectionString", $connection.ConnectionString)
               
        If($connection.Type -eq "SQLAzure") {
            $c.SetAttribute("providerName", "System.Data.SqlClient")
        }
        $croot.AppendChild($c)
    }
    $connectionsDoc.AppendChild($croot) | Out-Null
    $connectionsDoc.Save($connectionStringsFilePath)
}
