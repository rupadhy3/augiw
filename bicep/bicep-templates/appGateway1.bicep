@description('Virtual network name')
param virtualNetworkName string

@description('Name of the subnet in the virtual network')
param appGwSubnetName string

param appGwPublicIPName string
param location string
param domainNameLabel string

param appGatewaysName string

param appGwSkuName string
param appGwSkuTier string

param appGwFePort int
//param appGwFeProtocol string

param backendPools array

param backendHttpSettings array

param httplisteners array

param backendCount int

//param sslCertificateData string
//param sslCertificatePassword string

param probeHostname string
param probePath string = '/graphql?query=%7B__typename%7D'

@secure()
param sslCertKVSecretId string

var appgw_id = resourceId('Microsoft.Network/applicationGateways', appGatewaysName)

////////////////////////////////////////////////////////////////////////////
///////////////// Resources definition
resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' existing = {
  name: virtualNetworkName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' existing = {
  parent: vnet
  name: appGwSubnetName
}


resource publicIPAddressForAppGateway 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: appGwPublicIPName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    dnsSettings: {
      domainNameLabel: domainNameLabel
    }
  }
}

resource applicationGateways 'Microsoft.Network/applicationGateways@2020-11-01' = {
  name: appGatewaysName
  location: location
  properties: {
    sku: {
      name: appGwSkuName
      tier: appGwSkuTier
      capacity: 2
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayFrontendIP'
        properties: {
          subnet: {
            id: subnet.id
            //id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, appGwSubnetName)
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGatewayPublicFrontendIP'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddressForAppGateway.id
            //id: resourceId('Microsoft.Network/publicIPAddresses', '${publicIPAddressName}0')
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'frontendPort'
        properties: {
          port: appGwFePort
        }
      }
    ]
    backendAddressPools: [for (beap,i) in backendPools: {
        name: 'backendAddressrPool${i}'
        properties: {
          backendAddresses: [
            {
              ipAddress: beap.backendIpOrFqdn
            }
          ]
        }
    }]
    backendHttpSettingsCollection: [for (behs, i) in backendHttpSettings: {
        name: 'backendHttpSetting${i}'
        properties: {
          port: behs.backendHSPort
          protocol: behs.backendHSProtocol
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          path: behs.backendHSPath
          requestTimeout: 20
          probe: {
            //id: '${applicationGateways.id}/probes/graphprobe'  // need to check
            //id: resourceId('Microsoft.Network/applicationGateways/probes', appGatewaysName, 'appGatewayProbe')
	    id: concat(appgw_id, '/probes/appGatewayProbe')
          }
        }
    }]
    httpListeners: [for (hl,i) in httplisteners: {
        name: '${appGatewaysName}-listener${i}'
        properties: {
          frontendIPConfiguration: {
            //id: '${applicationGateways.id}/frontendIPConfigurations/appGatewayFrontendIP'
            //id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', appGatewaysName, 'appGwPublicFrontendIp')
	    id: concat(appgw_id, '/frontendIPConfigurations/appGwPublicFrontendIp')
          }
          frontendPort: {
            //id: '${applicationGateways.id}/frontendPorts/appGatewayFrontendHttpsPort'
            //id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', appGatewaysName, hl.port)
	    id: concat(appgw_id, '/frontendPorts/appGwFePort')
          }
          protocol: hl.appGwFeProtocol
          sslCertificate: {
            //id: '${applicationGateways.id}/sslCertificates/jwtSslCertificate'
            //id: resourceId('Microsoft.Network/applicationGateways/sslCertificates', appGatewaysName, 'sslCertificate')
            id: concat(appgw_id, '/sslCertificates/appGwSslCertificate')
          }
          hostName: hl.httpListenerHostname
          //hostNames: []
          requireServerNameIndication: true
        }
    }]
    requestRoutingRules: [for i in range(1, backendCount): {
        name: '${appGatewaysName}-routeRule${i}'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            //id: '${applicationGateways.id}/httpListeners/'${appGatewaysName}-listener${i}''
            //id: resourceId('Microsoft.Network/applicationGateways/httpListeners', appGatewaysName, '${appGatewaysName}-listener${i}')
	    id: concat(appgw_id, '/httpListeners/${appGatewaysName}-listener${i}')
          }
          backendAddressPool: {
            //id: '${applicationGateways.id}/backendAddressPools/mipnpd'
            //id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', appGatewaysName, 'backendAdrPool${i}')
	    id: concat(appgw_id, '/backendAddressPools/backendAddressrPool${i}')
          }
          backendHttpSettings: {
            //id: '${applicationGateways.id}/backendHttpSettingsCollection/mipapi1'
            //id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', appGatewaysName, 'backendHttpSetting${i}')
	    id: concat(appgw_id, '/backendHttpSettingsCollection/backendHttpSetting${i}')
          }
        }
    }]
    sslCertificates: [
      {
        name: 'appGwSslCertificate'   
        properties: {
          keyVaultSecretId: sslCertKVSecretId
          //data: sslCertificateData
          //password: sslCertificatePassword
        }
      }
    ]
    trustedClientCertificates: []
    sslProfiles: []
    urlPathMaps: []
    probes: [
      {
        name: 'appGatewayProbe'
        properties: {
          protocol: 'Https'
          host: probeHostname
          //path: '/graphql?query=%7B__typename%7D'
          path: probePath
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: false
          minServers: 0
          match: {
            statusCodes: [
              '200-399'
            ]
          }
        }
      }
    ]
    rewriteRuleSets: []
    redirectConfigurations: []
    privateLinkConfigurations: []
    webApplicationFirewallConfiguration: {
      enabled: true
      firewallMode: 'Detection'
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.0'
      disabledRuleGroups: []
      exclusions: []
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
      fileUploadLimitInMb: 5
    }
  }
}
