#Requires -Version 7.4
#Requires -Modules Az.Accounts
#Requires -Modules powershell-yaml

[CmdletBinding(SupportsShouldProcess=$true)]

param(
    [ValidateSet('all', 'bicep', 'tf')]
    [string]$Stage = 'all',

    [Parameter(Mandatory)][string]$TfStateResourceGroupName,
    [Parameter(Mandatory)][string]$TfStateStorageAccountName,

    [Parameter(Mandatory)][string]$DefaultName,
    [Parameter(Mandatory)][string]$ReleaseName,
    [hashtable]$DefaultTags = @{},
    
    [Parameter(Mandatory)][string]$MetadataLocation,
    [Parameter(Mandatory)][string]$ResourceLocation,
    [Parameter(Mandatory)][string]$RootCaCerts,

    [Parameter(Mandatory)][string]$HubSubscriptionId,

    [Parameter(Mandatory)][string]$DnsZoneName,
    [Parameter(Mandatory)][string]$InternalDnsZoneName,
    
    [Parameter(Mandatory)][string[]]$VnetDnsServers,
    [Parameter(Mandatory)][string]$VnetAddressPrefix,
    [Parameter(Mandatory)][string]$DefaultVnetSubnetAddressPrefix,
    [Parameter(Mandatory)][string]$PrivateVnetSubnetAddressPrefix,
    [Parameter(Mandatory)][string[]]$DnsVNetSubnetAddressPrefix,
    [Parameter(Mandatory)][string[]]$AciVNetSubnetAddressPrefix,

    [Parameter(Mandatory)][string]$HubVnetId,
    [Parameter(Mandatory)][string[]]$DnsResolverAddresses

)

$ErrorActionPreference = "Stop"

if ((Get-Command 'az').CommandType -ne 'Application') {
    throw 'Missing az command.'
}

$SubscriptionId = $(az account show --query id --output tsv)
if (!$SubscriptionId) {
        throw 'Missing current Azure subscription.'
}

if ($Stage -eq 'all' -or $Stage -eq 'bicep') {
    # create tfstate resource group
    az group create -l $MetadataLocation -n $TfStateResourceGroupName `
    ; if ($LASTEXITCODE -ne 0) { throw $LASTEXITCODE }

    # use bicep for initial tfstate deployment
    az deployment group create `
        --resource-group $TfStateResourceGroupName `
        --template-file tfstate.bicep `
        --parameters resourceLocation="$ResourceLocation" `
        --parameters storageAccountName="$TfStateStorageAccountName" `
        ; if ($LASTEXITCODE -ne 0) { throw $LASTEXITCODE }
}

if ($Stage -eq 'all' -or $Stage -eq 'tf') {
    if ((Get-Command 'terraform').CommandType -ne 'Application') {
        throw 'Missing terraform command.'
    }

    New-Item -ItemType Directory .tmp -Force | Out-Null

    @{
        subscription_id = $SubscriptionId
        default_name = $DefaultName
        release_name = $ReleaseName
        default_tags = $DefaultTags
        metadata_location = $MetadataLocation
        resource_location = $ResourceLocation
        root_ca_certs = $RootCaCerts
        hub_subscription_id = $HubSubscriptionId
        dns_zone_name = $DnsZoneName
        internal_dns_zone_name = $InternalDnsZoneName
        vnet_dns_servers = $VnetDnsServers
        vnet_address_prefixes = @( $VnetAddressPrefix )
        default_vnet_subnet_address_prefixes = @( $DefaultVnetSubnetAddressPrefix )
        private_vnet_subnet_address_prefixes = @( $PrivateVnetSubnetAddressPrefix )
        dns_vnet_subnet_address_prefixes = @( $DnsVNetSubnetAddressPrefix )
        aci_vnet_subnet_address_prefixes = @( $AciVNetSubnetAddressPrefix )
        hub_vnet_id = $HubVnetId
        dns_resolver_addresses = $DnsResolverAddresses
    } | ConvertTo-Json | Out-File .tmp/${DefaultName}.tfvars.json

    Push-Location .\terraform

    try {
        # configure terraform against target environment
        terraform init -reconfigure `
            -backend-config "subscription_id=${SubscriptionId}" `
            -backend-config "resource_group_name=${TfStateResourceGroupName}" `
            -backend-config "storage_account_name=${TfStateStorageAccountName}" `
            -backend-config "container_name=tfstate" `
            -backend-config "key=${DefaultName}.tfstate" `
            ; if ($LASTEXITCODE -ne 0) { throw $LASTEXITCODE }

        # apply terraform against target environment
        terraform apply `
            -parallelism=1 `
            -var-file="../.tmp/${DefaultName}.tfvars.json" `
            -auto-approve `
            ; if ($LASTEXITCODE -ne 0) { throw $LASTEXITCODE }

    } finally {
        Pop-Location
    }
}
