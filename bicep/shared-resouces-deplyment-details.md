To deploy shared resources in Azure - shared-resources-deployment.bicep
=======================================================================

Command:
=========
az deployment group what-if --resource-group IWAZU-MIP-NPD-SHARED-001 --template-file shared-resources-deployment.bicep --parameters environment='SIT' location='northeurope' instancenum='001' addKVAccess='false' domain='sharedtest' masterVmSku='Standard_D4s_v3' workerVmSku='Standard_D2s_v3' workerCount=2

This will deploy the following azure shared resources:
======================================================
1. Add keyVault accessPolicy to a given user, securitygroup or ServicePrincipal objectID -- Optional
2. RoleAssignment for ARO cluster deployment to the ARO servicePrincipal objectID and Azure ARO resource provider ObjectID
3. ARO cluster.
4. Windows VM (management) host.
5. Linux VM (management) host.
6. Bastion host with public IP address.
7. Azure container registry.
8. Application gateway -- still to add


Pre-requisite:
==============
The onceoff-shared-deployment must have been executed and has already deployed the required resources (like resourceGroups, vnet, subnet, keyvault with accesspolicy set for the devops deployer service account)

Keyvault Secrets requirement:
=============================
The following secrets must to added/exist on to the keyVault to be retrieved by this bicep deployment during execution:
1. ARO servicePrincipal objectID - clientObjectID
2. ARO Resource Provider Object ID - aroRpObjectID
3. ARO servicePrincipal ID - aroClientID
4. ARO servicePrincipal Secret - aroClientSecret
5. admin account password for virtual machines (VMs) - adminPassword

ResourceGroup for the command:
===============================
IWAZU-MIP-NPD-SHARED-001 -- This is the shared resourceGroup for non-prod (NPD) with environmnet must be DEV, SIT, UAT, TRN, TST, POC or PPD 
OR
IWAZU-MIP-PRD-SHARED-001 -- This is the shared resourceGroup for prod (PRD) with environment must be PRD

Required Parameters:
====================
environment = with values from DEV, TST, SIT, UAT, POC, TRN, PPD or PRD
location = region where resources are deployed example 'northeurope'
instancenum = instance numer of shared resources (001 to 009)
addKVAccess = boolean true or false value, to tell if any furter access policy need to be set for the existing keyVault.
clientObjectId4kv = REQUIRED if addKVAccess is set to true., it is the clientObjectID (a user, security group or servicePrincipal)  to which access to the keyVault need to be set
domain = 8 character domain name to be added to ARO cluster domain.
masterVmSku = value from 'Standard_D2s_v3' or 'Standard_D4s_v3' or 'Standard_D8s_v3'
workerVmSku = value from 'Standard_D2s_v3' or 'Standard_D4s_v3' or 'Standard_D8s_v3'
workerCount = Number of ARO worker nodes


Optional Parameters:
=====================
prefix = Default value 'IWAZU'
project = Default value 'MIP'
apiServerVisibility = Default value 'Private'
ingressVisibility = Default value  'Private'
acrSku = Default value 'Basic' 
