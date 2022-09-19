@minLength(3)
@maxLength(30)

@description('Name for the virtual network')
param vnetName string

@description('Address range in Cidr for the virtual network')
param vnetCidr string

@description('Tags for resources')
param tags object

@description('Location or region for your resource group deployment')
param location string = resourceGroup().location

@description('Location or region for your resource group deployment')
@allowed([
  'new'
  'existing'
])
param newOrExisting string

// vnet resource definition
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = if (newOrExisting == 'new') {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetCidr
      ]
    }
  }
}

output vnetId string = vnet.id

/* Depolyment command 
   Deploy using below command: 
   az deployment group create --resource-group rakeshu --template-file vnet.bicep [--parameters vnetName='' vnetCidr='']
*/
