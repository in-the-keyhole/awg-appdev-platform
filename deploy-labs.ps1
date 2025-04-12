#Requires -Version 7.4
#Requires -Modules Az.Accounts
#Requires -Modules powershell-yaml

[CmdletBinding(SupportsShouldProcess=$true)]

param(
    [ValidateSet('all', 'bicep', 'tf')]
    [string]$Stage = 'all'
)

.\deploy.ps1 `
    -Stage $Stage `
    -TfStateResourceGroupName "rg-appdev-tfstate" `
    -TfStateStorageAccountName "appdevtfstate" `
    -DefaultName "awg-appdev-labs" `
    -ReleaseName "1.0.0" `
    -DefaultTags @{} `
    -MetadataLocation "northcentralus" `
    -ResourceLocation "southcentralus" `
    -DnsZoneName "labs.appdev.az.awginc.com" `
    -InternalDnsZoneName "labs.appdev.az.int.awginc.com" `
    -VnetHubId "/subscriptions/6190d2d3-f65d-4f7a-939e-ad9829c27fd5/resourceGroups/rg-awg-hub/providers/Microsoft.Network/virtualNetworks/awg-hub" `
    -VnetDnsServers @( "10.223.254.4" ) `
    -VnetAddressPrefix "10.224.0.0/16" `
    -DefaultVnetSubnetAddressPrefix "10.224.0.0/24" `
    -PrivateVnetSubnetAddressPrefix "10.224.1.0/24" `
    -PrivateLinkZoneResourceGroupId "/subscriptions/6190d2d3-f65d-4f7a-939e-ad9829c27fd5/resourceGroups/rg-awg-hub"
