@description('Specifies the name of the Private endpoint')
param privateDnsZoneName string

param tags object

resource privateDNSZoneResource 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
  tags: tags
  properties: {}
}

