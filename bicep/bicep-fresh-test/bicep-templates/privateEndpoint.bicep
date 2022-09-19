@description('Specifies the name of the Private endpoint')
param privateEndpointName string

@description('Specifies the Azure location where the resource should be created.')
param location string 

param tags object

@description('Virtual network name')
param virtualNetworkName string

@description('Name of the private subnet in the virtual network')
param pvtSubnetName string

@description('service id of the service to be served by private endpoint')
param serviceId string

@description('serviceId falls uder which group - vault, registry')
param groupIds array

//@description(FQDN of service)
//param serviceFqdn string
//
//@description(IP address for service FQDN)
//param serviceIpAddresses array

////////////////////////////////////////////////////////////////////////////
resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' existing = {
  name: virtualNetworkName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' existing = {
  parent: vnet
  name: pvtSubnetName
}

resource privateEndpointResource 'Microsoft.Network/privateEndpoints@2020-11-01' = {
  name: privateEndpointName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: serviceId
          groupIds: groupIds    //Is a list value []
        }
      }
    ]
    subnet: {
      id: subnet.id
    }
    customDnsConfigs: [
//      {
//        fqdn: serviceFqdn
//        ipAddresses: serviceIpAddresses  ## is a list value []
//      }
    ]
  }
}
