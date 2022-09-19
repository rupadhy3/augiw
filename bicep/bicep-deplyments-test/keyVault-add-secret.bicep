@description('Name for the virtual network')
param keyVaultName string

#param secrets array

param secretName string
param secretValue string

//resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
//  name: keyVaultName
//}
//
//resource secret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = [for sec in secrets: {
//  name: sec.secretName
//  parent: keyVault  // Passing key vault symbolic name as a parent for the secret
//  properties: {
//    value: sec.secretValue
//  }
//}]

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
  
#  resource secret 'secrets' = [ for sec in secrets: {  // Type of the resource is just "secret"
  resource secret 'secrets' = {  // Type of the resource is just "secret"
    name: secretName
    properties: {
      value: secretValue
    }
  }]
}
