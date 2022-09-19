resource WAF 'Microsoft.Network/applicationGateways@2021-05-01' = {
  name: Name
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
    //forceFirewallPolicyAssociation: true
    //autoscaleConfiguration: {
    //  minCapacity: 0
    //  maxCapacity: 10
    //}
    //sslPolicy: contains(wafinfo, 'SSLPolicy') ? SSLpolicyLookup[wafinfo.SSLPolicy] : null
    //firewallPolicy: !(contains(wafinfo, 'WAFPolicyAttached') && bool(wafinfo.WAFPolicyAttached)) ? null : {
    //  id: WAFPolicy.id
    //}
    //privateLinkConfigurations: [for (privateLink, index) in PL: {
    //  name: 'private'
    //  properties: {
    //    ipConfigurations: [
    //      {
    //        name: 'waf-internal-${index}'
    //        properties: {
    //          primary: true //index == 0 ? true : false
    //          privateIPAllocationMethod: 'Dynamic'
    //          subnet: {
    //            id: '${VnetID}/subnets/${privateLink.Subnet}'
    //          }
    //        }
    //      }
    //    ]
    //  }
    //}]
    // Move to WAF Policy attached
    // webApplicationFirewallConfiguration: contains(wafinfo, 'WAFPolicyAttached') && bool(wafinfo.WAFPolicyAttached) ? webApplicationFirewallConfiguration : null
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
        name: 'frontendPublic'
        properties: {
          publicIPAddress: {
            id: appGwPublicIPAddressResource.id
          }
          privateIPAllocationMethod: 'Dynamic'
          privateLinkConfiguration: !contains(wafinfo, 'privateLinkInfo') ? null : {
            id: resourceId('Microsoft.Network/applicationGateways/privateLinkConfigurations', Name, 'private')
          }
        }
      }
      {
        name: 'frontendPrivate'
        properties: {
          privateIPAddress: '${networkId}.${wafinfo.PrivateIP}'
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: SubnetRefGW
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'BackendPool'
        properties: {
          backendAddresses: [for (be, Index) in (contains(wafinfo, 'FQDNs') ? wafinfo.FQDNs : wafinfo.BEIPs): {
            fqdn: contains(wafinfo, 'FQDNs') ? '${DeploymentURI}${be}.${Global.DomainName}' : null
            ipAddress: contains(wafinfo, 'BEIPs') ? '${networkIdUpper}.${be}' : null
          }]
        }
      }
    ]
    sslCertificates: [for (cert, index) in wafinfo.SSLCerts: {
      name: cert
      properties: {
        keyVaultSecretId: '${KV.properties.vaultUri}secrets/${cert}'
      }
    }]
    frontendPorts: [for (fe, index) in wafinfo.frontendPorts: {
      name: 'FrontendPort${fe.Port}'
      properties: {
        port: fe.Port
      }
    }]
    urlPathMaps: [for (pr, index) in wafinfo.pathRules: {
      name: pr.Name
      properties: {
        defaultBackendAddressPool: {
          id: '${WAFID}/backendAddressPools/BackendPool'
        }
        defaultBackendHttpSettings: {
          id: '${WAFID}/backendHttpSettingsCollection/BackendHttpSettings443'
        }
        pathRules: [
          {
            name: pr.Name
            properties: {
              paths: pr.paths
              backendAddressPool: {
                id: '${WAFID}/backendAddressPools/BackendPool'
              }
              backendHttpSettings: {
                id: '${WAFID}/backendHttpSettingsCollection/BackendHttpSettings443'
              }
            }
          }
        ]
      }
    }]
    backendHttpSettingsCollection: [for (be, index) in wafinfo.BackendHttp: {
      name: 'BackendHttpSettings${be.Port}'
      properties: {
        port: be.Port
        protocol: be.Protocol
        cookieBasedAffinity: contains(be, 'CookieBasedAffinity') ? be.CookieBasedAffinity : 'Disabled'
        requestTimeout: contains(be, 'RequestTimeout') ? be.RequestTimeout : 600
        probe: contains(be, 'probeName') ? BackendHttp[index].probe : null
      }
    }]
    httpListeners: [for (list, index) in wafinfo.Listeners: {
      name: 'httpListener-${(contains(list, 'pathRules') ? 'PathBasedRouting' : 'Basic')}-${list.Hostname}-${list.Port}'
      properties: {
        frontendIPConfiguration: {
          id: '${WAFID}/frontendIPConfigurations/Frontend${list.Interface}'
        }
        frontendPort: {
          id: '${WAFID}/frontendPorts/FrontendPort${list.Port}'
        }
        protocol: list.Protocol
        hostName: toLower('${Deployment}-${list.Hostname}.${list.Domain}')
        requireServerNameIndication: (list.Protocol == 'https')
        sslCertificate: list.Protocol == 'https' ? Listeners[index].sslCertificate : null
      }
    }]
    requestRoutingRules: [for (list, index) in wafinfo.Listeners: {
      name: 'requestRoutingRule-${list.Hostname}-${list.Port}'
      properties: {
        ruleType: (contains(list, 'pathRules') ? 'PathBasedRouting' : 'Basic')
        httpListener: {
          id: '${WAFID}/httpListeners/httpListener-${(contains(list, 'pathRules') ? 'PathBasedRouting' : 'Basic')}-${list.Hostname}-${list.Port}'
        }
        backendAddressPool: contains(list, 'httpsRedirect') && bool(list.httpsRedirect) ? null : Listeners[index].backendAddressPool
        backendHttpSettings: contains(list, 'httpsRedirect') && bool(list.httpsRedirect) ? null : Listeners[index].backendHttpSettings
        redirectConfiguration: contains(list, 'httpsRedirect') && bool(list.httpsRedirect) ? Listeners[index].redirectConfiguration : null
        urlPathMap: contains(list, 'pathRules') ? Listeners[index].urlPathMap : null
      }
    }]
    //redirectConfigurations: [for (list, index) in wafinfo.Listeners: {
    //  name: 'redirectConfiguration-${list.Hostname}-${list.Port}'
    //  properties: {
    //    redirectType: 'Permanent'
    //    targetListener: {
    //      id: '${WAFID}/httpListeners/httpListener-${(contains(list, 'pathRules') ? 'PathBasedRouting-' : 'Basic-')}${list.Hostname}-443'
    //    }
    //    includePath: true
    //    includeQueryString: true
    //  }
    //}]
    probes: [for (probe, index) in wafinfo.probes: {
      name: probe.name
      properties: {
        protocol: probe.protocol
        path: probe.path
        host: bool(probe.useBE) ? null : '${probe.name}.${Global.domainName}'
        interval: 30
        timeout: 30
        unhealthyThreshold: 3
        pickHostNameFromBackendHttpSettings: probe.useBE
        minServers: 0
        match: {
          body: ''
          statusCodes: [
            '200-399'
          ]
        }
      }
    }]
  }
}
