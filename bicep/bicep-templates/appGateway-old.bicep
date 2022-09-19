param appGwPublicIPName string = 'IWAZUNPDAGW001-IP001'
param location string
param domainNameLabel string = 'miptest'

@description('Virtual network name')
param virtualNetworkName string

@description('Name of the subnet in the virtual network')
param appGwSubnetName string

param appGatewaysName string = 'IWAZUNPDAGW001'

param appGwSkuName string = 'WAF_v2'
param appGwSkuTier string = 'WAF_v2'

param ocpIngressIP string

param backendPools array

param httpListenerHostname string


param apGwSettings array = [
  {
    addressPrefixes: [
      {
        name: 'firstPrefix1'
        addressPrefix: '10.0.0.0/22'
      }
    ]
    subnets: [
      {
        name: 'firstSubnet1'
        addressPrefix: '10.0.0.0/24'
      }
      {
        name: 'secondSubnet1'
        addressPrefix: '10.0.1.0/24'
      }
    ]
  }
  {
    properties: [
      {
        name: 'firstPrefix2'
        addressPrefix: '10.0.0.0/22'
      }
    ]
    subnets: [
      {
        name: 'firstSubnet2'
        addressPrefix: '10.0.0.0/24'
      }
      {
        name: 'secondSubnet2'
        addressPrefix: '10.0.1.0/24'
      }
    ]
  }
]

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
        name: 'port_80'
        properties: {
          port: 80
        }
      }
      {
        name: 'port_443'
        properties: {
          port: 443
        }
      }
    ]
    backendAddressPools: [for back in backendHttpSettings: [
      {
        name: 'backendAdrPool1'
        properties: {
          backendAddresses: [
            {
              ipAddress: backendIpOrFqdn1
            }
          ]
        }
      }
    ]
    //backendHttpSettingsCollection: [for backendHttpSetting in backendHttpSettings: [
    backendHttpSettingsCollection: [
      {
        name: 'backendHttpSetting1'
        properties: {
          port: backendHSPort
          protocol: backendHSProtocol
          cookieBasedAffinity: 'Disabled'
          hostName: backendHSHostname
          pickHostNameFromBackendAddress: false
          path: backendHSPath
          requestTimeout: 20
          probe: {
            id: '${applicationGateways.id}/probes/graphprobe'  // need to check
          }
        }
      }
    ]
    httpListeners: [
      {
        name: '${appGatewaysName}-listener1'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGateways.id}/frontendIPConfigurations/appGatewayFrontendIP'
            //id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', appGateWayName, 'appGwPublicFrontendIp')
          }
          frontendPort: {
            id: '${applicationGateways.id}/frontendPorts/appGatewayFrontendHttpsPort'
            //id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', appGateWayName, 'port_443')
          }
          protocol: 'Https'
          sslCertificate: {
            id: '${applicationGateways.id}/sslCertificates/jwtSslCertificate'
          }
          //hostName: httpListenerHostname
          //hostNames: []
          requireServerNameIndication: true
        }
      }
    ]
    requestRoutingRules: [
      {
        name: '${appGatewaysName}-routeRule1'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            //id: '${applicationGateways.id}/httpListeners/'${appGatewaysName}-listener1''
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', appGateWayName, '${appGatewaysName}-listener1')
          }
          backendAddressPool: {
            //id: '${applicationGateways.id}/backendAddressPools/mipnpd'
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', appGateWayName, 'backendAdrPool1')
          }
          backendHttpSettings: {
            //id: '${applicationGateways.id}/backendHttpSettingsCollection/mipapi1'
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', appGateWayName, '${appGatewaysName}-listener1')
          }
        }
      }
    ]
    sslCertificates: [
      {
        name: 'sslCertificate1'   
        properties: {
          data: ''
          keyVaultSecretId: 'string'
          password: 'string'
        }
      }
    ]
    trustedRootCertificates: [
      {
        name: 'rootCertificate1'     
        properties: {
          data: 'MIIDhjCCAm4CCQCzFjmS0xjHCzANBgkqhkiG9w0BAQsFADCBhDELMAkGA1UEBhMCRXUxEDAOBgNVBAgMB0lyZWxhbmQxDzANBgNVBAcMBkR1YmxpbjELMAkGA1UECgwCSVcxCzAJBgNVBAsMAklXMQswCQYDVQQDDAJJVzErMCkGCSqGSIb3DQEJARYcc3JhdmFuaS5kYXB1bGxhcHVkaUB3YXRlci5pZTAeFw0yMjAxMjAwOTU3MTFaFw0yMzAxMjAwOTU3MTFaMIGEMQswCQYDVQQGEwJFdTEQMA4GA1UECAwHSXJlbGFuZDEPMA0GA1UEBwwGRHVibGluMQswCQYDVQQKDAJJVzELMAkGA1UECwwCSVcxCzAJBgNVBAMMAklXMSswKQYJKoZIhvcNAQkBFhxzcmF2YW5pLmRhcHVsbGFwdWRpQHdhdGVyLmllMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArOljBJ5vWl4cWtw0RXq/avZHtGBuCdGr1DaPLEeWxGBgbja3owNXFjbFzgYg68kHkXEPC5WbFB6lqk4BJ/9modfeREG0sXM7usXQwyB/lXNtXBj6vn6bu7ZLgKNjrBTqjscFubEU+tF3BzJrz9f0hAwqkR05uRcM0HRZLGyBcCA3jGqtVE+PnRoq2y3vSgxPEdwZCowYapjy6ZEA5k9uSjtZHmwmjphkFzss55a/nMklyY/xVY2KRRaargmbstisPKA5mMRLbSM7/pnmO+n9Trbfh0+vteXntTJ7HPNn8brFwRlZG/itj7VLaqb2sUvN/CZNJ/Xa3IMLfwqLHWcpNQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQABzPwRPdWJidQb/aD9RLTHCM3k+pv24o7OEnXC8USQv26f3mpxyX3vxto/nvjbovAt/BFx3IZ3N+SKKZMTt+s0fnVhUd2kOB5xwErwrBQKiztEcDdix0aTyl4Yvao3v50KjZTVs6h8vT6RDhaoHiCC2sG5c6De+cUYz2qS05ls6l+ac2EI/S+cadi7Yq0XY0X9sjt9nZJQusA6g8htUGNKjxzCFATqTrtoYCIC6MV4N414XzlLXyk+zMMFkILtJlEKLh204i4bZ2Rh86FmXgxjoVk5lrZ7th99x95p3B2JSMaq0xtc/fPfelUiq5i/2j0VBD0+24IRP3+MYVatBSnB'
          keyVaultSecretId: 'string'
        }
      }
    ]
    trustedClientCertificates: []
    sslProfiles: []
    urlPathMaps: []
        probes: [
      {
        name: 'appGatewayProbe1'
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
