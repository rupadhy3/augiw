// Creates an Azure Container Registry with Azure Private Link endpoint
@description('Azure region of the deployment')
param location string

@description('Tags to add to the resources')
param tags object

@description('Container registry name')
param acrName string

@description('Tier of your Azure Container Registry')
@allowed([
  'Basic'
  'Classic'
  'Premium'
  'Standard'
])
param acrSku string = 'Premium'

@description('Container registry private link endpoint name')
param acrPeName string

@description('Resource name of the subnet')
param subnetName string

@description('Resource ID of the virtual network')
param virtualNetworkId string

var acrNameCleaned = replace(acrName, '-', '')

var privateDnsZoneName = 'privatelink${environment().suffixes.acrLoginServer}'

var groupName = 'registry' 

///////////// resource definition
resource acrPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-01-01' = {
  name: privateDnsZoneName
  location: 'global'
}

resource acrPrivateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-01-01' = {
  name: '${acrPrivateDnsZone.name}/${uniqueString(containerRegistry.id)}'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworkId
    }
  }
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' = {
  name: acrNameCleaned
  location: location
  tags: tags
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: true
    anonymousPullEnabled: false
    dataEndpointEnabled: false
    networkRuleBypassOptions: 'AzureServices'
    networkRuleSet: {
      defaultAction: 'Deny'
    }
    policies: {
      quarantinePolicy: {
        status: 'enabled'
      }
      retentionPolicy: {
        status: 'enabled'
        days: 7
      }
      trustPolicy: {
        status: 'disabled'
        type: 'Notary'
      }
    }
    publicNetworkAccess: 'Disabled'
    zoneRedundancy: 'Disabled'
  }
}

resource containerRegistryPrivateEndpoint 'Microsoft.Network/privateEndpoints@2020-11-01' = {
  name: acrPeName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: acrPeName
        properties: {
          groupIds: [
            groupName
          ]
          privateLinkServiceId: containerRegistry.id
        }
      }
    ]
    subnet: {
      id: subnetName
    }
  }
}

resource privateEndpointDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-06-01' = {
  name: '${containerRegistryPrivateEndpoint.name}${groupName}-PrivateDnsZoneGroup'
  parent: containerRegistryPrivateEndpoint
  properties:{
    privateDnsZoneConfigs: [
      {
        name: privateDnsZoneName
        properties:{
          privateDnsZoneId: acrPrivateDnsZone.id
        }
      }
    ]
  }
}



output containerRegistryId string = containerRegistry.id
