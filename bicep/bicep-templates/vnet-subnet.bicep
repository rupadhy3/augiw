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

@description('Array of subnets')
param subnets array

/*@description('Tags for resources')
@allowed([
  'Enabled'
  'Disabled'
])
param privEndPtNwPolicies string

@description('Tags for resources')
@allowed([
  'Enabled'
  'Disabled'
])
param privLinkSvcNwPolicies string
*/

// vnet resource definition
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetCidr
      ]
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.cidr
        serviceEndpoints: [
          {
            service: 'Microsoft.ContainerRegistry'
            locations: [
              '*'
            ]
          }
        ]
        privateEndpointNetworkPolicies: subnet.privEndPtNwPolicies
        privateLinkServiceNetworkPolicies: subnet.privLinkSvcNwPolicies
      }
    }]
  }
}


output vnetId string = vnet.id
output subnetId array = [for (subnet, i) in subnets: {
   subnets : vnet.properties.subnets[i].id
}]

/* Depolyment command 
   Deploy using below command: 
   az deployment group create --resource-group rakeshu --template-file vnet.bicep [--parameters vnetName='' vnetCidr='']
*/
