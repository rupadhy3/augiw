@description('Specifies the name of the Private DNS Zone')
param privateDnsZoneName string

@description('Specifies the name of the Private DNS Zone')
param virtualNetworkName string

param tags object

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' existing = {
  name: virtualNetworkName
}

resource privateDNSZoneResource 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
}

resource privateDnsZoneVnetLinkResource 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: privateDnsZoneVnetLinkName
  location: 'global'
  tags: tags
  parent: privateDNSZoneResource
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}
