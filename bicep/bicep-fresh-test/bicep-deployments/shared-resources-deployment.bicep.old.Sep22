// Parameters definition
@description('Common prefix to be used for naming of all devices')
param prefix string = 'IWAZU'
param project string = 'MIP'
param instancenum string = '009'
param location string
param datetimenow string = utcNow()
param tags object = {
  env: env
  dept: 'infrastructure'
  project: project
  version: instancenum
  creationDate: datetimenow
  region: location
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
var envppd = env == 'PPD' && envmnt == 'NPD' ? 'PPD' : null

// resourceGroup names: RG NAME format is: IWAZU-MIP-NPD-<APP>-001
// env based shared resource group
var RGSHARED = '${prefix}-${project}-${envmnt}-SHARED-${instancenum}'
var RGARO = envppd == 'PPD' ? '${prefix}-${project}-${envppd}-ARO-${instancenum}' : '${prefix}-${project}-${envmnt}-ARO-${instancenum}' 
var RGAROMANAGED = envppd == 'PPD' ? '${prefix}-${project}-${envppd}-AROMNG-${instancenum}' : '${prefix}-${project}-${envmnt}-AROMNG-${instancenum}'
/// RGMGT is not required in this module
var RGMGT = envppd == 'PPD' ? '${prefix}-${project}-${envppd}-MGT-${instancenum}' : '${prefix}-${project}-${envmnt}-MGT-${instancenum}'
var RGSTG = envppd == 'PPD' ? '${prefix}-${project}-${envppd}-PVC-${instancenum}' : '${prefix}-${project}-${envmnt}-PVC-${instancenum}'

/// Below RG are declared conditionally above
//var RGAROPPD = '${prefix}-${project}-${envppd}-ARO-${instancenum}'
//var RGAROMANAGEDPPD = '${prefix}-${project}-${envppd}-AROMNG-${instancenum}'
//var RGMGTPPD = '${prefix}-${project}-${envppd}-MGT-${instancenum}'

var vnetName = '${prefix}${envmnt}-${project}-NET-${instancenum}'
var subnetAroMaster = envppd == 'PPD' ? '${prefix}${envppd}-${project}AOM-SUB-012' : '${prefix}${envmnt}-${project}AOM-SUB-001'
var subnetAroWorker = envppd == 'PPD' ? '${prefix}${envppd}-${project}AOW-SUB-013' : '${prefix}${envmnt}-${project}AOW-SUB-002'
var subnetAppGw = '${prefix}${envmnt}-${project}AGW-SUB-003'
var subnetBastion = 'AzureBastionSubnet'
var subnetMgt = envppd == 'PPD' ? '${prefix}${envppd}-${project}MGT-SUB-014' : '${prefix}${envmnt}-${project}MGT-SUB-005'
var subnetPvt = '${prefix}${envmnt}-${project}PVT-SUB-015'

var keyVaultName = '${prefix}${envmnt}KV0${instancenum}'

param addKVAccess bool
param clientObjectId4kv string = 'null'

// below vaues for clientObjectId and aroRpObjectId is read from keyVault
//@description('The Object ID of an Azure Active Directory client application')
//@secure()
//param clientObjectId string = keyVaultShared.getSecret('clientObjectId')

//@description('The ObjectID of the ARO Resource Provider')
//@secure()
//param aroRpObjectId string = keyVaultShared.getSecret('aroRpObjectId')

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
param aroCreate bool

var vmWindowsName = '${prefix}${envmnt}WINM${instancenum}'
var vmLinuxName = '${prefix}${envmnt}LINM${instancenum}'

//@secure()
//param adminPassword string

var bastionHostName = '${prefix}${project}${envmnt}BAS${instancenum}'
var acrName = '${prefix}${project}${envmnt}ACR${instancenum}'

@description('Tier of your Azure Container Registry')
@allowed([
  'Basic'
  'Classic'
  'Premium'
  'Standard'
])
param acrSku string = 'Premium'


///// Application Gateway parameters
var appGwPublicIPName = '${prefix}${project}${envmnt}AGW${instancenum}-IP${instancenum}'
param publicIpDomainLabel string
var appGatewaysName = '${prefix}${project}${envmnt}AGW${instancenum}'
//var aroIngressIpAddress string
param Listeners array
param BackendHttp array
param frontendPorts array
param SSLCerts array

//param appGwSkuName string = 'WAF_v2'
//param appGwSkuTier string = 'WAF_v2'
//param appGwFePort int = 443
//param httpListenerHostnameSuffix string = 'cloudapp.azure.com'

//param backendPools array = [
//  {
//    backendIpOrFqdn: '10.86.1.254'
//  }
//]

//param backendHttpSettings array = [
//  {
//    backendHSPort: '443'
//    backendHSProtocol: 'HTTPS'
//    backendHSPath: ''
//  }
//]

//param httplisteners array = [
//  {
//    port: '443'
//    appGwFeProtocol: 'HTTPS'
//    httpListenerHostname: '${domainNameLabel}.${location}.${httpListenerHostnameSuffix}'
//  }
//]

//param backendCount int = 1

//param sslCertificateData string = 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tDQpNSUlDV0RDQ0FmMENGRHZFUEJKanR6eXoxMkZmZkNNcklzZStyelFaTUFvR0NDcUdTTTQ5QkFNQ01JR3RNUXN3DQpDUVlEVlFRR0V3SkpUakVMTUFrR0ExVUVDQXdDUzBFeEVqQVFCZ05WQkFjTUNVSmhibWRoYkc5eVpURU1NQW9HDQpBMVVFQ2d3RFNVSk5NUTB3Q3dZRFZRUUxEQVJKUWsxRE1UWXdOQVlEVlFRRERDMXRhWEF0WVhCd1oyRjBaWGRoDQplUzV1YjNKMGFHVjFjbTl3WlM1amJHOTFaR0Z3Y0M1aGVuVnlaUzVqYjIweEtEQW1CZ2txaGtpRzl3MEJDUUVXDQpHWEpoYTJWemFDNTFjR0ZrYUhsaGVURkFkMkYwWlhJdWFXVXdIaGNOTWpJd01qRXhNRGN5TmpVMVdoY05Nak13DQpNakV4TURjeU5qVTFXakNCclRFTE1Ba0dBMVVFQmhNQ1NVNHhDekFKQmdOVkJBZ01Ba3RCTVJJd0VBWURWUVFIDQpEQWxDWVc1bllXeHZjbVV4RERBS0JnTlZCQW9NQTBsQ1RURU5NQXNHQTFVRUN3d0VTVUpOUXpFMk1EUUdBMVVFDQpBd3d0Yldsd0xXRndjR2RoZEdWM1lYa3VibTl5ZEdobGRYSnZjR1V1WTJ4dmRXUmhjSEF1WVhwMWNtVXVZMjl0DQpNU2d3SmdZSktvWklodmNOQVFrQkZobHlZV3RsYzJndWRYQmhaR2g1WVhreFFIZGhkR1Z5TG1sbE1Ga3dFd1lIDQpLb1pJemowQ0FRWUlLb1pJemowREFRY0RRZ0FFb0phVm1xRVdnd2RzR2NqWEdpNCtkRU1jRGJNSUdCbGVXRzhMDQpudkNNN2d4YnhvS1R3RVowdVFDWDVPUnd5bk1HQ0F2SXFUdXRFanN4a1d4MzBNeWpoekFLQmdncWhrak9QUVFEDQpBZ05KQURCR0FpRUFrN2lLMCsyUlZucmZUUWtvVEJsOXE5dWIvekxVSjB6eXdwdlU5TEIvc084Q0lRRGdMU1FoDQpBdWdhMit1c0xHa1dYVWI4YjZzK2k0ckpIN1hYbkNnZlovZENKQT09DQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tDQo='
//param sslCertificatePassword string = 'SomePassword'
//var kvDnsZoneName = environment().suffixes.keyvaultDns
//param keyvault_mgmt_cert string = 'mgmtapicert'

param probeHost string 
param probePath string = '/graphql?query=%7B__typename%7D'
param aroAppUrl string = 'apps.${domain}.northeurope.aroapp.io'

/// Parameters for user assigned identity
var identityName = '${prefix}${envmnt}AGWManagedIdentity${instancenum}'

////////// Parameters and variables for API MANAGEMENT SERVICE //////////
//param virtualNetworkName string = 'IWAZUNPD-MIP-NET-002'
var apiSubnetName = '${prefix}${envmnt}-${project}API-SUB-014'
var apiManagementServiceName = '${prefix}${envmnt}API${instancenum}'

@description('The pricing tier of this API Management service')
@allowed([
  'Developer'
  'Basic'
  'Standard'
  'Premium'
])
param apiSku string = 'Developer'

param apiSkuCount int = 1
param publisherEmail string
param publisherName string

@description('Virtual network type for the api')
@allowed([
  'External'
  'Internal'
  'None'
])
param apiVnetType string = 'Internal'

var apiResources = [
  {
    displayName: 'Maximo-SIT'
    apiType: 'http'
    apiRevision: '1'
    apiFormat: 'openapi+json'
    apiPath: 'Maximo-SIT'
    apiValue: '{"openapi":"3.0.1","info":{"title":"Maximo-SIT","contact":{},"version":"1.0"},"servers":[{"url":"https://10.231.8.24:18080/maximo/api/os"}],"paths":{"/*":{"get":{"summary":"Common-Get","description":"Generic get method to support all get calls to Maximo","operationId":"common-get","responses":{"200":{"description":null}}},"post":{"summary":"Common-Post","description":"Generic Post method to support all post calls to Maximo","operationId":"common-post","responses":{"200":{"description":null}}}}},"components":{"securitySchemes":{"apiKeyHeader":{"type":"apiKey","name":"Ocp-Apim-Subscription-Key","in":"header"},"apiKeyQuery":{"type":"apiKey","name":"subscription-key","in":"query"}}},"security":[{"apiKeyHeader":[]},{"apiKeyQuery":[]}],"tags":[{"name":"dev","description":""}]}'
    protocols: [
       'https'
    ]
    apiPolicyValue: '<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.\r\n    - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n    - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.\r\n-->\r\n<policies>\r\n  <inbound>\r\n    <base />\r\n    <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">\r\n      <openid-config url="https://login.microsoftonline.com/60beb100-3973-4346-bd68-d1c4eb6f4c42/.well-known/openid-configuration" />\r\n      <audiences>\r\n        <audience>https://mymipapi.water.ie</audience>\r\n      </audiences>\r\n    </validate-jwt>\r\n    <set-header name="Content-Type" exists-action="override">\r\n      <value>application/json</value>\r\n    </set-header>\r\n    <set-header name="x-public-uri" exists-action="override">\r\n      <value>http://maximo-project2.vip.iwater.ie/maximo/api</value>\r\n    </set-header>\r\n  </inbound>\r\n  <backend>\r\n    <base />\r\n  </backend>\r\n  <outbound>\r\n    <base />\r\n  </outbound>\r\n  <on-error>\r\n    <base />\r\n  </on-error>\r\n</policies>'
    apiPolicyFormat: 'xml'
  }
]

var storageAccountAzureFileName = '${prefix}${envmnt}AROFILE${instancenum}'
@description('Provide a kind or type of storage sku')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param storageSku string = 'Standard_LRS'

@description('Provide a kind or type of storage sku')
@allowed([
  'BlobStorage'
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
  'StorageV2'
])
param storageKind string = 'StorageV2'

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

module raMod '../bicep-templates/roleAssignment.bicep' = [for role in roles: {
  name: '${role.name}Deploy'
  params:{
    raName: guid(resourceGroup().id, deployment().name, role.name)
    principalId: keyVaultShared.getSecret(role.name)
    principalType: role.principalType
    roleDefinitionId: role.roleDefinitionId
  }
}]

module aroMod '../bicep-templates/aro.bicep' = if (aroCreate) {
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

var ocpsecrets = [
  {
    secretName: 'aroConsoleUrl'
    secretValue: '${aroMod.outputs.consoleUrl}'
  }
  {
    secretName: 'aroApiUrl'
    secretValue: '${aroMod.outputs.apiUrl}'
  }
  {
    secretName: 'aroIngressIp'
    secretValue: '${aroMod.outputs.ingressIp}'
  }
  {
    secretName: 'aroAdminUser'
    secretValue: 'kubeadmin'
  }
  {
    secretName: 'aroAdminPassword'
    secretValue: 'tobefilledlater'
  }
]

module ocpSecretsAdd '../bicep-templates/kv-secretAdd.bicep' = if (aroCreate) {
  name: '${keyVaultName}AroSecret'
  scope: resourceGroup(RGSHARED)
  params:{
    kvName: keyVaultName
    mysecrets: ocpsecrets
  }
  dependsOn: [
    aroMod
  ]
}

module vmWindowsMod '../bicep-templates/vmWindows.bicep' = {
  name: '${vmWindowsName}Deploy'
  scope: resourceGroup(RGMGT)
  params:{
    vmName: vmWindowsName
    location: location
    adminUsername: 'windowsadmin'
    adminPassword: keyVaultShared.getSecret('adminPassword')
    virtualNetworkName: vnetName
    subnetName: subnetMgt
    vnetRGName: RGSHARED
  }
}

module vmLinuxMod '../bicep-templates/vmLinux.bicep' = {
  name: '${vmLinuxName}Deploy'
  scope: resourceGroup(RGMGT)
  params:{
    location: location
    vmName: vmLinuxName
    adminUsername: 'linuxadmin'
    adminPasswordOrKey: keyVaultShared.getSecret('adminPassword')
    virtualNetworkName: vnetName
    subnetName: subnetMgt
    vnetRGName: RGSHARED
  }

  dependsOn: [
    vmWindowsMod
  ]
}

module bastionHostMod '../bicep-templates/bastionHost.bicep' = {
  name: '${bastionHostName}Deploy'
  scope: resourceGroup(RGMGT)
  params:{
    location: location
    virtualNetworkName: vnetName
    bastionSubnetName: subnetBastion
    vnetRGName: RGSHARED
  }

  dependsOn: [
    vmLinuxMod
  ]
}

module acrMod '../bicep-templates/acr-new.bicep' = {
  name: '${acrName}Deploy'
  params:{
    location: location
    tags: tags
    acrName: acrName
    acrSku: acrSku
  }
  
  //dependsOn: [
  //  bastionHostMod
  //]
}

module identityNameMod '../bicep-templates/userAssignedIdentity.bicep' = {
  name: '${identityName}Deploy'
  params:{
    location: location
    tags: tags
    identityName: identityName
  }
}

module addKVAccessPolicyForAppGwUserIdentityMod '../bicep-templates/keyVault-add-accessPolicies.bicep' = {
  name: '${identityName}KVPolicyDeploy'
  params:{
    keyVaultName: keyVaultName
    objectId: identityNameMod.outputs.identityObjectId
  }
  dependsOn: [
    identityNameMod
  ]
}

module appGatewayMod '../bicep-templates/appGateway.bicep' = {
  name: '${appGatewaysName}Deploy'
  params:{
    appGwRg: RGSHARED                          // uncomment RGSHARED above in line 32
    identityID: identityNameMod.outputs.identityId
    virtualNetworkName: vnetName               // Good
    appGwSubnetName: subnetAppGw               // Good
    applicationGatewayName: appGatewaysName    // Good
    keyvaultName: keyVaultName                 // Good
    location: location                         // Good
    appGwPublicIPName: appGwPublicIPName       // Good
    publicIpDomainLabel: publicIpDomainLabel   // change domainNameLabel to publicIpDomainLabel line 146
    aroIngressIpAddress: aroMod.outputs.ingressIp   //
    Listeners: Listeners                       // Declared on line 149, defined in parameter file
    BackendHttp: BackendHttp                   // Declared on line 150, defined in parameter file
    frontendPorts: frontendPorts               // Declared on line 151, defined in parameter file
    SSLCerts: SSLCerts                         // Declared on line 152, defined in parameter file
    probeHost: '${probeHost}.${aroAppUrl}'     // Declared on line 188, defined in parameter file
    probePath: probePath                       // Defined in line 189
    aroAppUrl: aroAppUrl                       // Defined in line 190
  }
  dependsOn: [
    addKVAccessPolicyForAppGwUserIdentityMod 
  ]
}

module apiMgmtSvcMod '../bicep-templates/api_mgmt_new.bicep' = {
  name: '${apiManagementServiceName}-Deploy'
  params:{
    virtualNetworkName: vnetName
    apiSubnetName: apiSubnetName
    apiManagementServiceName: apiManagementServiceName
    location: location
    tags: tags
    apiSku: apiSku
    apiSkuCount: apiSkuCount
    publisherEmail: publisherEmail
    publisherName: publisherName
    apiVnetType: apiVnetType
  }
}

module apiMgmtSvcResourcesMod '../bicep-templates/api_mgmt_resources.bicep' = [for resValue in apiResources: {
  name: '${resValue.displayName}-apiResources-Deploy'
  params:{
    apiManagementServiceName: apiManagementServiceName
    displayName: resValue.displayName
    apiType: resValue.apiType
    apiRevision: resValue.apiRevision
    apiFormat: resValue.apiFormat
    apiPath: resValue.apiPath
    protocols: resValue.protocols
    apiValue: resValue.apiValue
    apiPolicyValue: resValue.apiPolicyValue
    apiPolicyFormat: resValue.apiPolicyFormat
  }
  dependsOn: [
    apiMgmtSvcMod
  ]
}]

module storageAccountAzureFileMod '../bicep-templates/storageAccount.bicep' = {
  name: 'storageAccountAzureFileOcpDeploy'
  scope: resourceGroup(RGSTG)
  params:{
    storageAccountName: toLower(storageAccountAzureFileName)
    tags: tags
    location: location
    storageSku: storageSku
    storageKind: storageKind
  }
}

module storageAccountAzureFileRAMod '../bicep-templates/roleAssignment.bicep' = {
  name: 'storageAccountAzureFileRADeploy'
  scope: resourceGroup(RGSTG)
  params:{
    raName: guid(resourceGroup().id, deployment().name, storageAccountAzureFileMod.outputs.storageAccountId)
    principalId: keyVaultShared.getSecret('clientObjectId')
    principalType: 'ServicePrincipal'
    roleDefinitionId: contribRole
  }
}


///// Deployment command:
//RGSHARED = '${prefix}-${project}-${envmnt}-SHARED-${instancenum}' ==> IWAZU-MIP-NPD-SHARED-001
//az deployment group what-if --resource-group IWAZU-MIP-NPD-SHARED-001 --template-file shared-resources-deployment.bicep --parameters 
//az deployment group create --resource-group IWAZU-MIP-NPD-SHARED-001 --template-file shared-resources-deployment.bicep --parameters 
//
