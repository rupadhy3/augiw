@description('Name for the virtual network')
param kvName string

@description('Tags for resources')
param tags object

@description('Location or region for your resource group deployment')
param location string

@description('Address range in Cidr for the virtual network')
@allowed([
  'premium'
  'standard'
])
param skuName string

param secrets array

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: kvName
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: skuName
    }    
    tenantId: subscription().tenantId
    enabledForDeployment: true          // VMs can retrieve certificates
    enabledForTemplateDeployment: true  // ARM can retrieve values
    enablePurgeProtection: true         // Not allowing to purge key vault or its objects after deletion
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    createMode: 'default'
//    accessPolicies: []
  }

  resource secret 'secrets' = [for sec in secrets: {  // No need for full type name
    name: sec.secretName
    properties: {
      value: sec.secretValue
    }
  }]
}
