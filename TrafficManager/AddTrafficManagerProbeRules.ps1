#Verify latest Probe IP Addresses at https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-faqs

$subscriptionId = "YourSubscriptionId"
$resourceGroupEast = "EastCoastResourceGroup"
$resourceGroupWest = "WestCostResourceGroup"
$nsgEast = "EastCoastNSG"
$nsgWest = "WestCoastNSG"
$probePort = 80 
$rulePriorityStart = 150
$rulePriority = $rulePriorityStart

$trafficManagerProbeIPs = @("40.68.30.66",`
                             "40.68.31.178", `
                             "137.135.80.149", `
                             "137.135.82.249", `
                             "23.96.236.252", `
                             "65.52.217.19", `
                             "40.87.147.10", `
                             "40.87.151.34", `
                             "13.75.124.254", `
                             "13.75.127.63", `
                             "52.172.155.168", `
                             "52.172.158.37", `
                             "104.215.91.84", `
                             "13.75.153.124", `
                             "13.84.222.37", `
                             "23.101.191.199", `
                             "23.96.213.12", `
                             "137.135.46.163", `
                             "137.135.47.215", `
                             "191.232.208.52", `
                             "191.232.214.62", `
                             "13.75.152.253", `
                             "104.41.187.209",`
                             "104.41.190.203")

Login-AzureRmAccount

Set-AzureRmContext -SubscriptionId $subscriptionId

$groupEast = Get-AzureRMNetworkSecurityGroup -ResourceGroupName $resourceGroupEast `
     -Name $nsgEast
$groupWest = Get-AzureRMNetworkSecurityGroup -ResourceGroupName $resourceGroupWest `
     -Name $nsgWest


For($i=0; $i -lt $trafficManagerProbeIPs.Length; $i++) {
    $ruleName = "Inbound-TMProbe" + $i.ToString() + "-Https-Allow"

    $rulePriority = $rulePriorityStart + $i

    $groupEast | Add-AzureRmNetworkSecurityRuleConfig -Name $ruleName `
        -Description "Allow Traffic Manager Probe HTTPS" `
        -Access Allow -Protocol Tcp -Direction Inbound -Priority $rulePriority `
        -SourceAddressPrefix $trafficManagerProbeIPs[$i] -SourcePortRange * `
        -DestinationAddressPrefix * -DestinationPortRange $probePort

    $groupWest | Add-AzureRmNetworkSecurityRuleConfig -Name $ruleName `
        -Description "Allow Traffic Manager Probe HTTPS" `
        -Access Allow -Protocol Tcp -Direction Inbound -Priority $rulePriority `
        -SourceAddressPrefix $trafficManagerProbeIPs[$i] -SourcePortRange * `
        -DestinationAddressPrefix * -DestinationPortRange $probePort
}
$groupEast | Set-AzureRmNetworkSecurityGroup
$groupWest | Set-AzureRmNetworkSecurityGroup
