// ========== keyvault.bicep ==========
@description('Name for the shared keyvault')
param keyVaultName string

@description('Tags for resources')
param tags object

@description('Location or region for your resource group deployment')
param location string = resourceGroup().location

@description('Address range in Cidr for the virtual network')
@allowed([
  'premium'
  'standard'
])
param skuName string

param clientObjectId4kv string

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: skuName
    }
    tenantId: subscription().tenantId  // or use tenant().tenantId

    enableRbacAuthorization: false      // Using Access Policies model
    accessPolicies: [
      {
        objectId: clientObjectId4kv //The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault.
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'all'
          ]
          certificates: [
            'all'
          ]
          keys: [
            'all'
          ]
        }
      }
    ]

    enabledForDeployment: true          // VMs can retrieve certificates
    enabledForTemplateDeployment: true  // ARM can retrieve values

    //enablePurgeProtection: false         // Not allowing to purge key vault or its objects after deletion
    enableSoftDelete: false
    softDeleteRetentionInDays: 7
    createMode: 'default'               // Creating or updating the key vault (not recovering)
  }
}
