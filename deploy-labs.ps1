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
    -TfStateResourceGroupName "rg-awg-appdev-labs-tfstate" `
    -TfStateStorageAccountName "awgappdevlabstfstate" `
    -DefaultName "awg-appdev-labs" `
    -ReleaseName "1.0.0" `
    -DefaultTags @{} `
    -MetadataLocation "northcentralus" `
    -ResourceLocation "southcentralus" `
    -HubSubscriptionId "6190d2d3-f65d-4f7a-939e-ad9829c27fd5" `
    -DnsZoneName "labs.appdev.az.awginc.com" `
    -InternalDnsZoneName "labs.appdev.az.int.awginc.com" `
    -DnsResolverAddresses @( "10.224.254.4", "10.224.254.5" ) `
    -VnetDnsServers @( "10.223.254.4", "10.223.254.5" ) `
    -VnetAddressPrefix "10.224.0.0/16" `
    -DefaultVnetSubnetAddressPrefix "10.224.0.0/24" `
    -PrivateVnetSubnetAddressPrefix "10.224.1.0/24" `
    -DnsVNetSubnetAddressPrefix "10.224.254.0/29" `
    -AciVNetSubnetAddressPrefix "10.224.2.0/24" `
    -StepCaToken "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJodHRwczovL2dhdGV3YXkuc21hbGxzdGVwLmNvbSIsImV4cCI6MjA2MDcwMzQyNCwiaWF0IjoxNzQ1MzQzNDI0LCJpc3MiOiJodHRwczovL2dhdGV3YXkuc21hbGxzdGVwLmNvbSIsImp0aSI6IjhiMGMzY2Y4LTY5YTMtNGE4MS04MWUyLTY3MDA2OGY2ZjUxNSIsIm5iZiI6MTc0NTM0MzQyNCwic3ViIjoiZjU0NjJjMDctYWVmMC00YmFiLWExYjYtOTQwMzI2NjI1NzZlIn0.kZz4RUdDybdW73jhrKscFG7nBu6Pudu27kTfFWmHZtMAp9XGR82fWuGNoI7bFCjqlvDsmHck8dplpEgd3B2wBQ" `
    -StepCaUuid "e84eb580-d423-4716-a6a3-876109e24c2c" `
    -StepCaProvisionerName "awg-appdev-labs" `
    -StepCaProvisionerPassword "8mTJA8QIqmgcNfay6X0yL9JK2ti9t81j" `
    -HubVNetId "/subscriptions/6190d2d3-f65d-4f7a-939e-ad9829c27fd5/resourceGroups/rg-awg-hub/providers/Microsoft.Network/virtualNetworks/awg-hub" `
    -PrivateLinkZoneResourceGroupId "/subscriptions/6190d2d3-f65d-4f7a-939e-ad9829c27fd5/resourceGroups/rg-awg-hub" `
