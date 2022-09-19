@description('Specifies the name of the Private DNS Zone')
param privateDnsZoneName string

@description('Specifies the Private DNS zone aRecord.')
param privateDnsZoneARecord string 

param privateIpAddress string



resource privateDNSZoneResource 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
}

resource privateDnsZonesARecordResource 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: privateDnsZoneARecord
  parent: privateDNSZoneResource
  properties: {
    aRecords: [
      {
        ipv4Address: privateIpAddress
      }
    ]
    ttl: 3600
  }
}
