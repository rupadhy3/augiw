@description('Virtual network name')
param virtualNetworkName string = 'IWAZUNPD-MIP-NET-002'

@description('API management subnet name')
param apiSubnetName string = 'IWAZUNPD-MIPAPI-SUB-014'

@description('The name of the API Management service instance')
//param apiManagementServiceName string = 'apim-privateendpoint-${uniqueString(resourceGroup().id)}'
param apiManagementServiceName string = 'IWAZUNPDAPI002'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Tags for resources')
param tags object

@description('The pricing tier of this API Management service')
@allowed([
  'Developer'
  'Basic'
  'Standard'
  'Premium'
])
param apiSku string = 'Developer'

@description('The instance size of this API Management service.')
param apiSkuCount int = 1

@description('The email address of the owner of the service')
@minLength(1)
param publisherEmail string = 'rakesh.upadhyay1@ibm.com'

@description('The name of the owner of the service')
@minLength(1)
param publisherName string = 'RU'

@description('Virtual network type for the api')
@allowed([
  'External'
  'Internal'
  'None'
])
param apiVnetType string = 'Internal'

//@description('Private endpoint name')
//param privateEndpointName string = 'apiMgmtSvcPvtEndpoint'

var privateDNSZoneName = '${apiManagementServiceName}.azure-api.net'



//////////////////////////////////////////////////////////////////////////////

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' existing = {
  name: virtualNetworkName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' existing = {
  parent: vnet
  name: apiSubnetName
}

resource apiManagementService 'Microsoft.ApiManagement/service@2021-12-01-preview' = {
  name: apiManagementServiceName
  location: location
  tags: tags
  sku: {
    name: apiSku
    capacity: apiSkuCount
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    //publicNetworkAccess: 'Disabled'
    virtualNetworkConfiguration: {
      subnetResourceId: subnet.id
    }
    virtualNetworkType: apiVnetType
  }
}

resource privateDnsZones 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDNSZoneName
  location: 'global'
  dependsOn: [
    vnet
  ]
}

resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZones
  name: '${privateDnsZones.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

// az deployment group create --resource-group IWAZU-MIP-NPD-SHARED-002 --template-file api_mgmt.bicep --parameters 
