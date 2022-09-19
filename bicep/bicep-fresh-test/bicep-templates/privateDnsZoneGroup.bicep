@description(Private dns zone group name)
param privateDnsZonegroupName string

param privateDnsZoneId string

param privateEndpointResourceName string


resource privateEndpointDNSGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-11-01' = {
  parent: privateEndpointResourceName
  name: privateDnsZonegroupName
  properties: {
    privateDnsZoneConfigs: [
      {
        name: privateDnsZonegroupName
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
}
