param appGwRg string
param virtualNetworkName string
param appGwSubnetName string
param applicationGatewayName string
param keyvaultName string
param location string
param appGwPublicIPName string
param publicIpDomainLabel string
param aroIngressIpAddress string
param Listeners array
param BackendHttp array
param frontendPorts array

//@secure()
param SSLCerts array

//@secure()
//param sslCertKVSecretId string

param probeHost string
param probePath string
param aroAppUrl string

var publicIpDomain = '${location}.cloudapp.azure.com'
var appGwSku = 'WAF_v2'
var appGwCapacity = 2
//var appGwId = appGwResource.id
var AGID = resourceId('Microsoft.Network/applicationGateways',applicationGatewayName)

var thisListeners = [for listener in Listeners : {
  name: listener.Port
  backendAddressPool: {
    id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'appGatewayBackendPool')
  }
  backendHttpSettings: {
    id: (contains(listener, 'BackendPort') ? resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'appGatewayBackendHttpSettings${listener.BackendPort}') : json('null'))
  }
  redirectConfiguration: {
    id: resourceId('Microsoft.Network/applicationGateways/redirectConfigurations', applicationGatewayName, 'redirectConfiguration-${listener.Hostname}-80')
  }
  sslCertificate: {
    id: (contains(listener, 'Cert') ? resourceId('Microsoft.Network/applicationGateways/sslCertificates', applicationGatewayName, listener.Cert) : json('null'))
  }
}]

var thisBackendHttp = [for be in BackendHttp : {
  probe: {
    id: resourceId('Microsoft.Network/applicationGateways/probes', applicationGatewayName, (contains(be, 'probeName') ? be.probeName : 'na'))
  }
}]

param identityID string

//////////////////////////////////////////////////////////////////////////

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' existing = {
  name: virtualNetworkName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' existing = {
  parent: vnet
  name: appGwSubnetName
}

resource keyvaultShared 'Microsoft.KeyVault/vaults@2020-04-01-preview' existing = {
  name : keyvaultName
}

resource appGwPublicIPAddressResource 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: appGwPublicIPName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    dnsSettings: {
      domainNameLabel: publicIpDomainLabel
      //fqdn: 'miptest.northeurope.cloudapp.azure.com'
    }
    ipTags: []
  }
}


resource appGwResource 'Microsoft.Network/applicationGateways@2020-11-01' = {
  name: applicationGatewayName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identityID}': {}
    }
  }
  properties: {
    sku: {
      name: appGwSku
      tier: appGwSku
      capacity: appGwCapacity
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayFrontendIP'
        properties: {
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGatewayFrontendPublic'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: appGwPublicIPAddressResource.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'appGatewayBackendPool'
        properties: {
          backendAddresses: [
            {
              ipAddress: aroIngressIpAddress
            }
          ]
        }
      }
    ]
    sslCertificates: [for (cert,index) in SSLCerts : {
        name: cert
        properties: {
          //keyVaultSecretId: sslCertKVSecretId
          //keyVaultSecretId: keyvaultShared.getSecret(cert.value.name, cert.value.version)
          keyVaultSecretId: '${reference(resourceId(appGwRg, 'Microsoft.KeyVault/vaults', keyvaultName), '2019-09-01').vaultUri}secrets/${cert}'
        }
    }]
    trustedRootCertificates: []
    trustedClientCertificates: []
    sslProfiles: []
    frontendPorts: [for (fe,index) in frontendPorts : {
      name: 'appGatewayFrontendPort${fe.Port}'
      properties: {
        port: fe.Port
      }
    }]
    backendHttpSettingsCollection: [for (be,index) in BackendHttp : {
      name: 'appGatewayBackendHttpSettings${be.Port}'
      properties: {
        port: be.Port
        protocol: be.Protocol
        cookieBasedAffinity: be.CookieBasedAffinity
        hostName: '${be.Hostname}.${aroAppUrl}'
        pickHostNameFromBackendAddress: false
        requestTimeout: be.RequestTimeout
        probe: (contains(be, 'probeName') ? thisBackendHttp[index].probe : json('null'))
      }
    }]
    httpListeners: [for (list,index) in Listeners: {
      name: 'httpListener-${list.Hostname}-${list.Port}'
      properties: {
        frontendIPConfiguration: {
          id: '${AGID}/frontendIPConfigurations/appGatewayFrontend${list.Interface}'
        }
        frontendPort: {
          id: '${AGID}/frontendPorts/appGatewayFrontendPort${list.Port}'
        }
        protocol: list.Protocol
        hostName: toLower('${list.Hostname}.${publicIpDomain}')
        requireServerNameIndication: (list.Protocol == 'https')
        sslCertificate: ((list.Protocol == 'https') ? thisListeners[index].sslCertificate : json('null'))
      }
    }]
    urlPathMaps: []
    requestRoutingRules: [for (list,index) in Listeners: {
      name: 'requestRoutingRule-${list.Hostname}${list.Port}'
      properties: {
        ruleType: 'Basic'
        httpListener: {
          id: '${AGID}/httpListeners/httpListener-${list.Hostname}-${list.Port}'
        }
        backendAddressPool: thisListeners[index].backendAddressPool
        backendHttpSettings: thisListeners[index].backendHttpSettings
      }
    }]
    probes: [
      {
        name: 'appGwProbe'
        properties: {
          protocol: 'Https'
          host: probeHost
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
