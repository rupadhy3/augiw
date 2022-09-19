@description('Name for the virtual network')
param kvName string

param mysecrets array

@description('Expiration time of the key , 1Year from now')
param keyExpiration int = dateTimeToEpoch(dateTimeAdd(utcNow(), 'P1Y'))

//resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
//  name: kvName
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
  name: kvName
  
  resource secret 'secrets' = [ for sec in mysecrets: {  // Type of the resource is just "secret"
    name: sec.secretName
    properties: {
      attributes: {
        enabled: true
        exp: keyExpiration
      }
      value: sec.secretValue
    }
  }]
}
