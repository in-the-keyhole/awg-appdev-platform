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
    -DefaultName "awg-appdev" `
    -ReleaseName "1.0.0" `
    -DefaultTags @{} `
    -MetadataLocation "westus" `
    -ResourceLocation "eastus" `
    -DnsZoneName "appdev.az.awginc.com" `
    -InternalDnsZoneName "appdev.az.int.awginc.com" `
    -VnetHubId "/subscriptions/37298c31-cb0d-47bf-bff6-9211d5aae925/resourceGroups/rg-awg-appdevhub/providers/Microsoft.Network/virtualNetworks/awg-appdevhub" `
    -VnetAddressPrefix "10.224.0.0/16" `
    -DefaultVnetSubnetAddressPrefix "10.224.0.0/24" `
    -PrivateVnetSubnetAddressPrefix "10.224.1.0/24" `
    -AksVnetSubnetAddressPrefix "10.224.2.0/24"
