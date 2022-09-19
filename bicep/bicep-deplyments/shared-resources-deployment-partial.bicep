// Parameters definition
@description('Common prefix to be used for naming of all devices')
param prefix string = 'IWAZU'
param project string = 'MIP'
param instancenum string = '009'
param location string

param tags object = {
  env: env
  dept: 'infrastructure'
  project: project
  version: instancenum
}


@description('Environment abbreviation for deployment env')
@allowed([
  'DEV'
  'SIT'
  'UAT'
  'TST'
  'TRN'
  'POC'
  'PPD'
  'PRD'
])
param env string

var envmnt = env == 'DEV' || env == 'SIT' || env == 'UAT' || env == 'TST' || env == 'TRN' || env == 'POC' || env == 'PPD' ? 'NPD' : env
var envppd = env == 'PPD' || envmnt == 'NPD' ? 'PPD' : null

// resourceGroup names: RG NAME format is: IWAZU-MIP-NPD-<APP>-001
// env based shared resource group
//var RGSHARED = '${prefix}-${project}-${envmnt}-SHARED-${instancenum}'
/*
var RGARO = envppd == 'PPD' ? '${prefix}-${project}-${envppd}-ARO-${instancenum}' : '${prefix}-${project}-${envmnt}-ARO-${instancenum}' 
var RGAROMANAGED = envppd == 'PPD' ? '${prefix}-${project}-${envppd}-AROMNG-${instancenum}' : '${prefix}-${project}-${envmnt}-AROMNG-${instancenum}'
*/
/// RGMGT is not required in this module
//var RGMGT = envppd == 'PPD' ? '${prefix}-${project}-${envppd}-MGT-${instancenum}' : '${prefix}-${project}-${envmnt}-MGT-${instancenum}'

/// Below RG are declared conditionally above
//var RGAROPPD = '${prefix}-${project}-${envppd}-ARO-${instancenum}'
//var RGAROMANAGEDPPD = '${prefix}-${project}-${envppd}-AROMNG-${instancenum}'
//var RGMGTPPD = '${prefix}-${project}-${envppd}-MGT-${instancenum}'

var vnetName = '${prefix}${envmnt}-${project}-NET-${instancenum}'
/*
var subnetAroMaster = envppd == 'PPD' ? '${prefix}${envppd}-${project}AOM-SUB-006' : '${prefix}${envmnt}-${project}AOM-SUB-001'
var subnetAroWorker = envppd == 'PPD' ? '${prefix}${envppd}-${project}AOW-SUB-007' : '${prefix}${envmnt}-${project}AOM-SUB-002'
var subnetAppGw = '${prefix}${envmnt}-${project}AGW-SUB-003'
*/
var subnetBastion = 'AzureBastionSubnet'
var subnetMgt = envppd == 'PPD' ? '${prefix}${envppd}-${project}MGT-SUB-014' : '${prefix}${envmnt}-${project}MGT-SUB-005'
var subnetPvt = '${prefix}${envmnt}-${project}PVT-SUB-015'

var keyVaultName = '${prefix}${envmnt}KVT${instancenum}'

param addKVAccess bool
param clientObjectId4kv string = 'null'

// below vaues for clientObjectId and aroRpObjectId is read from keyVault
//@description('The Object ID of an Azure Active Directory client application')
//@secure()
//param clientObjectId string = keyVaultShared.getSecret('clientObjectId')

//@description('The ObjectID of the ARO Resource Provider')
//@secure()
//param aroRpObjectId string = keyVaultShared.getSecret('aroRpObjectId')
/*
var contribRole = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
//var acrPull = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/7f951dda-4ed3-4680-a7ca-43fe172d538d'
//var acrPush = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/8311e382-0749-4cb8-b61a-304f252e45ec'

var roles = [
  {
    name: 'clientObjectID'
  //  principalId: clientObjectId
    principalType: 'ServicePrincipal'
    roleDefinitionId: contribRole
  }
  {
    name: 'aroRpObjectID'
  //  principalId: aroRpObjectId
    principalType: 'ServicePrincipal'
    roleDefinitionId: contribRole
  }
]

var clusterName = '${prefix}${envmnt}ARO${instancenum}'
@description('Api Server Visibility')
@allowed([
  'Private'
  'Public'
])
param apiServerVisibility string = 'Private'

@description('Ingress Visibility')
@allowed([
  'Private'
  'Public'
])
param ingressVisibility string = 'Private'

@description('Domain prefix for the Azure ARO cluster')
param domain string

//@description('ARO managed RG name')
//param aroManagedRgName string = '${prefix}${env}aromanagedrg${instancenum}'

@description('Master node Size - Sku')
@allowed([
  'Standard_D2s_v3'
  'Standard_D4s_v3'
  'Standard_D8s_v3'
  'null'
])
param masterVmSku string

@description('Master node Size - Sku')
@allowed([
  'Standard_D2s_v3'
  'Standard_D4s_v3'
  'Standard_D8s_v3'
  'null'
])
param workerVmSku string

param workerCount int
*/
var vmWindowsName = '${prefix}${envmnt}WINM${instancenum}'
var vmLinuxName = '${prefix}${envmnt}LINM${instancenum}'

//@secure()
//param adminPassword string

var bastionHostName = '${prefix}${project}${envmnt}BAS${instancenum}'
var acrName = '${prefix}${project}${envmnt}ACR${instancenum}'
var acrPeName = '${prefix}${project}${envmnt}ACRPE${instancenum}'

@description('Tier of your Azure Container Registry')
@allowed([
  'Basic'
  'Classic'
  'Premium'
  'Standard'
])
param acrSku string = 'Premium'

///// Application Gateway parameters
/*
var appGwPublicIPName = '${prefix}${project}${envmnt}AGW${instancenum}-IP${instancenum}'
param domainNameLabel string
var appGatewaysName = '${prefix}${project}${envmnt}AGW${instancenum}'
param appGwSkuName string = 'WAF_v2'
param appGwSkuTier string = 'WAF_v2'
param appGwFePort int = 443
param httpListenerHostnameSuffix string = 'cloudapp.azure.com'

param backendPools array = [
  {
    backendIpOrFqdn: '10.86.1.254'
  }
]

param backendHttpSettings array = [
  {
    backendHSPort: '443'
    backendHSProtocol: 'HTTPS'
    backendHSPath: ''
  }
]

param httplisteners array = [
  {
    port: '443'
    appGwFeProtocol: 'HTTPS'
    httpListenerHostname: '${domainNameLabel}.${location}.${httpListenerHostnameSuffix}'
  }
]

param backendCount int = 1
*/
//param sslCertificateData string = 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tDQpNSUlDV0RDQ0FmMENGRHZFUEJKanR6eXoxMkZmZkNNcklzZStyelFaTUFvR0NDcUdTTTQ5QkFNQ01JR3RNUXN3DQpDUVlEVlFRR0V3SkpUakVMTUFrR0ExVUVDQXdDUzBFeEVqQVFCZ05WQkFjTUNVSmhibWRoYkc5eVpURU1NQW9HDQpBMVVFQ2d3RFNVSk5NUTB3Q3dZRFZRUUxEQVJKUWsxRE1UWXdOQVlEVlFRRERDMXRhWEF0WVhCd1oyRjBaWGRoDQplUzV1YjNKMGFHVjFjbTl3WlM1amJHOTFaR0Z3Y0M1aGVuVnlaUzVqYjIweEtEQW1CZ2txaGtpRzl3MEJDUUVXDQpHWEpoYTJWemFDNTFjR0ZrYUhsaGVURkFkMkYwWlhJdWFXVXdIaGNOTWpJd01qRXhNRGN5TmpVMVdoY05Nak13DQpNakV4TURjeU5qVTFXakNCclRFTE1Ba0dBMVVFQmhNQ1NVNHhDekFKQmdOVkJBZ01Ba3RCTVJJd0VBWURWUVFIDQpEQWxDWVc1bllXeHZjbVV4RERBS0JnTlZCQW9NQTBsQ1RURU5NQXNHQTFVRUN3d0VTVUpOUXpFMk1EUUdBMVVFDQpBd3d0Yldsd0xXRndjR2RoZEdWM1lYa3VibTl5ZEdobGRYSnZjR1V1WTJ4dmRXUmhjSEF1WVhwMWNtVXVZMjl0DQpNU2d3SmdZSktvWklodmNOQVFrQkZobHlZV3RsYzJndWRYQmhaR2g1WVhreFFIZGhkR1Z5TG1sbE1Ga3dFd1lIDQpLb1pJemowQ0FRWUlLb1pJemowREFRY0RRZ0FFb0phVm1xRVdnd2RzR2NqWEdpNCtkRU1jRGJNSUdCbGVXRzhMDQpudkNNN2d4YnhvS1R3RVowdVFDWDVPUnd5bk1HQ0F2SXFUdXRFanN4a1d4MzBNeWpoekFLQmdncWhrak9QUVFEDQpBZ05KQURCR0FpRUFrN2lLMCsyUlZucmZUUWtvVEJsOXE5dWIvekxVSjB6eXdwdlU5TEIvc084Q0lRRGdMU1FoDQpBdWdhMit1c0xHa1dYVWI4YjZzK2k0ckpIN1hYbkNnZlovZENKQT09DQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tDQo='
//param sslCertificatePassword string = 'SomePassword'
//var kvDnsZoneName = environment().suffixes.keyvaultDns
//param keyvault_mgmt_cert string = 'mgmtapicert'
/*
param probeHostname string 

param probePath string = '/graphql?query=%7B__typename%7D'
*/

////////////////////////////////////////////////////////////////////////////////////
////////////////////////////    Module Definitions      ////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

//resource sharedRG 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
//  name: RGSHARED
//}

resource vnet 'Microsoft.Network/virtualNetworks@2020-08-01' existing = {
  name : vnetName
}

resource keyVaultShared 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyVaultName
}

module addKVAccessPolicyMod '../bicep-templates/keyVault-add-accessPolicies.bicep' = if (addKVAccess) {
  name: '${keyVaultName}Deploy'
  params:{
    keyVaultName: keyVaultName
    objectId: clientObjectId4kv
  }
}

/*
module raMod '../bicep-templates/roleAssignment.bicep' = [for role in roles: {
  name: '${role.name}Deploy'
  params:{
    //raName: role.name == 'clientObject' ? '${vnet.id}/Microsoft.Authorization/${guid(resourceGroup().id, deployment().name, clientObjectId)}' : '${vnet.id}/Microsoft.Authorization/${guid(resourceGroup().id, deployment().name, aroRpObjectId)}'
    raName: '${vnet.id}/Microsoft.Authorization/${guid(resourceGroup().id, deployment().name, role.principalId)}'
    //principalId: role.principalId
    principalId: keyVaultShared.getSecret(role.name)
    principalType: role.principalType
    roleDefinitionId: role.roleDefinitionId
  }
}]

module aroMod '../bicep-templates/aro.bicep' = {
  name: '${clusterName}Deploy'
  scope: resourceGroup(RGARO)
  params:{
    clusterName: clusterName
    location: location
    tags: tags
    apiServerVisibility: apiServerVisibility
    ingressVisibility: ingressVisibility
    domain: domain
    pullSecret: keyVaultShared.getSecret('pullSecret')
    aroManagedRgName: RGAROMANAGED
    masterVmSku: masterVmSku
    workerVmSku: workerVmSku
    workerCount: workerCount
    masterSubnetId: '${vnet.id}/subnets/${subnetAroMaster}'
    workerSubnetId: '${vnet.id}/subnets/${subnetAroWorker}'
    clientId: keyVaultShared.getSecret('aroClientId')
    clientSecret: keyVaultShared.getSecret('aroClientSecret')
  }

  dependsOn: [
    raMod
  ]
}
*/

module vmWindowsMod '../bicep-templates/vmWindows.bicep' = {
  name: '${vmWindowsName}Deploy'
  params:{
    vmName: vmWindowsName
    location: location
    adminUsername: 'windowsadmin'
    adminPassword: keyVaultShared.getSecret('adminPassword')
    virtualNetworkName: vnetName
    subnetName: subnetMgt
  }
}

module vmLinuxMod '../bicep-templates/vmLinux.bicep' = {
  name: '${vmLinuxName}Deploy'
  params:{
    location: location
    vmName: vmLinuxName
    adminUsername: 'linuxadmin'
    adminPasswordOrKey: keyVaultShared.getSecret('adminPassword')
    virtualNetworkName: vnetName
    subnetName: subnetMgt
  }
  
  dependsOn: [
    vmWindowsMod
  ]
}

module bastionHostMod '../bicep-templates/bastionHost.bicep' = {
  name: '${bastionHostName}Deploy'
  params:{
    location: location
    virtualNetworkName: vnetName
    bastionSubnetName: subnetBastion
  }
  
  dependsOn: [
    vmLinuxMod
  ]
}

module acrMod '../bicep-templates/acr-with-pe.bicep' = {
  name: '${acrName}Deploy'
  params:{
    location: location
    tags: tags
    acrName: acrName
    acrSku: acrSku
    acrPeName: acrPeName
    subnetName: subnetPvt
    virtualNetworkId: vnet.id
  }
  
  //dependsOn: [
  //  bastionHostMod
  //]
}

/*
module appGatewayMod '../bicep-templates/appGateway1.bicep' = {
  name: '${appGatewaysName}Deploy'
  params:{
    location: location
    virtualNetworkName: vnetName
    appGwSubnetName: subnetAppGw
    appGwPublicIPName: appGwPublicIPName
    domainNameLabel: domainNameLabel
    appGatewaysName: appGatewaysName
    appGwSkuName: appGwSkuName
    appGwSkuTier: appGwSkuTier
    appGwFePort: appGwFePort
    backendPools: backendPools
    backendHttpSettings: backendHttpSettings
    httplisteners: httplisteners
    backendCount: backendCount
    //sslCertKVSecretId: 'https://${keyVaultShared.name}${kvDnsZoneName}/secrets/${keyvault_mgmt_cert}'
    sslCertKVSecretId: keyVaultShared.getSecret('mgmtApiCert')
    //sslCertificateData: sslCertificateData
    //sslCertificatePassword: sslCertificatePassword
    probeHostname: probeHostname
    probePath: probePath
  }
}
*/

///// Deployment command:
//RGSHARED = '${prefix}-${project}-${envmnt}-SHARED-${instancenum}' ==> IWAZU-MIP-NPD-SHARED-001
//az deployment group what-if --resource-group IWAZU-MIP-NPD-SHARED-001 --template-file shared-resources-deployment.bicep --parameters 
//az deployment group create --resource-group IWAZU-MIP-NPD-SHARED-001 --template-file shared-resources-deployment.bicep --parameters 
//
