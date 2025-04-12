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
