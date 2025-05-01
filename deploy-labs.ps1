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
    -RootCaCerts "-----BEGIN CERTIFICATE-----
MIIBbzCCARWgAwIBAgIQFhTlZWo+1Xt03/Yt7Z5vFTAKBggqhkjOPQQDAjAWMRQw
EgYDVQQDEwtBV0cgUm9vdCBDQTAeFw0yNTA1MDExNDI5MzNaFw0yNjA1MDEyMDI5
MzNaMBYxFDASBgNVBAMTC0FXRyBSb290IENBMFkwEwYHKoZIzj0CAQYIKoZIzj0D
AQcDQgAEkRC6p/SLzGj3EuMl1snPiFzXRIvokvmYyhEo6QU4ttziq+k7oN0ZgCkb
5X/3ucghkRa6eWkkIAjzMeDRUvHLuKNFMEMwDgYDVR0PAQH/BAQDAgEGMBIGA1Ud
EwEB/wQIMAYBAf8CAQgwHQYDVR0OBBYEFGgntOkALmE1hw7fzsSwK2nyF8LBMAoG
CCqGSM49BAMCA0gAMEUCIQDm+PvSpXXG2DzM7aDj4xj5QcVMfxjUjwnXmbIf7SEl
TAIgChzptgGUi7vBOmwPo8g8hZXX9GmWLIz8BgXR2Y0re4c=
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIBmDCCAT6gAwIBAgIQY3gBBnDS9vtFXZB9w+crNjAKBggqhkjOPQQDAjAWMRQw
EgYDVQQDEwtBV0cgUm9vdCBDQTAeFw0yNTA1MDExNDMwMDhaFw0yNjA1MDEyMDMw
MDVaMB4xHDAaBgNVBAMTE0FXRyBJbnRlcm1lZGlhdGUgQ0EwWTATBgcqhkjOPQIB
BggqhkjOPQMBBwNCAASgRnNo/RlTVeO3MHIO8doZqTUVsbo2DLfE7qdiT9FXGqo6
NH2PtQeoDaOWUG1ayyvjzj44vaqnz+QsA7EAJsCgo2YwZDAOBgNVHQ8BAf8EBAMC
AQYwEgYDVR0TAQH/BAgwBgEB/wIBCDAdBgNVHQ4EFgQUaT/TgAtvXs7pRleoPU/g
YS3SEIEwHwYDVR0jBBgwFoAUaCe06QAuYTWHDt/OxLArafIXwsEwCgYIKoZIzj0E
AwIDSAAwRQIgee7rakn2bIXmwSQatPea/OFoZA+b9JlcPBLKh7N0mPMCIQDM/TW8
BEIEn44KTQTn/jysfsJ6frKWMr/IQBddPLhI6Q==
-----END CERTIFICATE-----
" `
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
    -HubVNetId "/subscriptions/6190d2d3-f65d-4f7a-939e-ad9829c27fd5/resourceGroups/rg-awg-hub/providers/Microsoft.Network/virtualNetworks/awg-hub"
