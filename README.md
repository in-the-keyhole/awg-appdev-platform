# AWG Application Development Platform

The AWG AppDev Platform is a reusable deployment artifact that is to be used as the base of a category of AppDev environments. Within one Platform, multiple Environments can be created.

One common pattern where this might make sense is in combining pre-prod environments:

+ AppDevPlat #1 (Labs)
    + AppDevEnv #1 (dev1)
    + AppDevEnv #2 (sit1)
    + AppDevEnv #3 (uat1)
+ AppDevPlat #2 (Prod)
    + AppDevEnv #4 (prod)

In an example like the above two Azure subscriptions are used, with one AppDev Platform instance per, to segment pre-production from production. Multiple AppDev environments are deployed into the Labs platform.


+ AppDevPlat #1 (dev)
    + AppDevEnv #1 (dev1)
    + AppDevEnv #2 (dev2)
+ AppDevPlat #2 (sit)
    + AppDevEnv #3 (sit1)
+ AppDevPlat #3 (uat)
    + AppDevEnv #4 (uat1)
    + AppDevEnv #5 (uat2)
+ AppDevPlat #4
    + AppDevEnv #6

In an example like the above, four Azure subscriptions are used to separate various types of pre-production environments: dev, sit and uat, but multiple environments exist in each.

An Application Development Platform contains unique:

+ Virtual Network
+ KeyVault
+ Azure Container Registry
+ Storage Account
+ Delegated Internal DNS Zone (labs.int.az.company.com)
+ Delegated Public DNS Zone (labs.az.company.com)

These resources are used to serve the various environments deployed within the platform. For instance, containers or charts required by the application environments are all deployed into a single Container Registry.

# Usage

Deployment is driven by a PowerShell script named `deploy.ps1`. Arguments passed to this script configure its operation.

| Argument                          | Description
| ---                               | ---
| TfStateResourceGroupName          | Name of the resource group to hold the .tfstate file.
| TfStateStorageAccountName         | Name of the storage account to hold the .tfstate file.
| DefaultName                       | DefaultName should be a soft-globally unique identifier.
| ReleaseName                       | Represents the name of the specific release. Usually a version number.
| DefaultTags                       | Additional tags to place on resources.
| MetadataLocation                  | Location of ARM metadata: resource groups.
| ResourceLocation                  | Primary location of Azure resources.
| DnsZoneName                       | DNS zone name of the delegated public zone. Delegation is not handled.
| InternalDnsZoneName               | DNS zone name of the delegated private zone.
| VnetHubId                         | Full ARM ID of the Hub virtual network to peer to.
| VnetDnsServers                    | List of DNS servers, usually in the hub, to contact for resolution.
| VnetAddressPrefix                 | Address prefix for the Virtual Network. Must be unique within the peered VNet.
| DefaultVnetSubnetAddressPrefix    | Address prefix of the 'default' subnet.
| PrivateVnetSubnetAddressPrefix    | Address prefix of the 'private' subnet, into which private endpoints will be emitted.
| PrivateLinkZoneResourceGroupId    | Full ARM ID of the ResourceGroup hosting the privatelink zones for delegation.
