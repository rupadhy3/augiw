// ============ add access policies to existing keyVault ============
@description('Name for the keyVault')
param keyVaultName string

param secertsAType string = 'all'
param certsAType string = 'all'
param keyAType string = 'all'

param objectId string


resource accessPolicies 'Microsoft.KeyVault/vaults/accessPolicies@2019-09-01' = {
  name: '${keyVaultName}/add'
  properties: {
    accessPolicies: [
      {
        objectId: 
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            secertsAType
          ]
          certificates: [
            certsAType
          ]
          keys: [
            keyAType
          ]
        }
      }
    ]
  }
}
