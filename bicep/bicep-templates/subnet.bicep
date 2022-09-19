// subnets as separate modules is not supproetd cleanly as of now in bicep

@minLength(3)
@maxLength(30)

@description('Name for the virtual network')
param subnetName string

@description('Address range in Cidr for the virtual network')
param subnetCidr string

@description('Tags for resources')
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

@description('Address range in Cidr for the virtual network')
param serviceEp string = 'Microsoft.ContainerRegistry'

@description('Name of existing virtual network')
param existingVnetName string

// dummy definition for existing vnet
resource existingVNET 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: existingVnetName
}

// subnet definition
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  name: subnetName
  parent: existingVNET
  properties: {
    addressPrefix: subnetCidr
    delegations: []
    privateEndpointNetworkPolicies: privEndPtNwPolicies
    privateLinkServiceNetworkPolicies: privLinkSvcNwPolicies
    serviceEndpoints: [
      {
        locations: [
          '*'
        ]
        service: serviceEp
      }
    ]
  }
}



/* Depolyment command 
   Deploy using below command: 
   az deployment group create --resource-group rakeshu --template-file subnet.bicep [--parameters vnetName='' vnetCidr='']
*/
