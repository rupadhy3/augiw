@description('Name for the virtual network')
param kvName string

param secrets array

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: kvName
  // scope: resourceGroup('rg-contoso')   - if key vault is in a different resource group
}

module someMod '<template.bicep>' = {
  name: someDeploy
  params: {
    myPassword: keyVault.getSecret('<keyName>')
    // myPassword: keyVault.getSecret('mySqlPassword', '2cc1676124b77bc9a1bfd30d8f4b6225')
  }
}
