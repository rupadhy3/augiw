///// Parameters definitions
param publicIpName string
param location string
param tags array
param skuName string = 'Standard'
param skuTier string = 'Regional'
@description('Public IP Address behaviour on disassociation')
@allowed([
  'Delete'
  'Detach'
])
param deleteOpt string = 'Detach'

@description('Public IP Address allocation method')
@allowed([
  'Dynamic'
  'Static'
])
param IpAdrAllocMethod string = 'Dynamic'

param publicIpDomain string = 'miptest'

///// Resource Definition
resource publicIpAdr 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: publicIpName
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    deleteOption: deleteOpt
    dnsSettings: {
      domainNameLabel: publicIpDomain
    }
    idleTimeoutInMinutes: 5
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: IpAdrAllocMethod

  }
}
