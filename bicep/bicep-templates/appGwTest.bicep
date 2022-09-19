///// Parameters Definition
@description('Name for the Azure Application Gateway')
param appGwName string

@description('Location or region for your resource group deployment')
param location string = resourceGroup().location

@description('Tags for resources')
param tags object

param appGwSubnetId string
param publicIpAddressId string
param frontendPort int = 443
param backendIpAddress string
param backendPort int
param backendProtocol string
param backendHostname string
param httpProbeId string
param appGwRootcertificateId string
param frontendIpConfigId string
param frontendPortId string
param frontendProtocol string
param sslCertificateId string
param httpListenerId string
param backendAddressPoolId string
param backendHttpSettingsId string
param backendHealthProbeHost string
param backendHealthProbePort string
param backendHealthProbeProtocol string
param backendHealthProbePath string


///// Resource Definition
resource symbolicname 'Microsoft.Network/applicationGateways@2021-05-01' = {
  name: appGwName
  location: location
  tags: tags
  properties: {
    sku: {
      capacity: 2
      name: 'WAF_v2'
      tier: 'WAF_v2'
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: appGwSubnetId
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGatewayFrontendIP'
        properties: {
          publicIPAddress: {
            id: publicIpAddressId
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'appGatewayFrontendPort'
        properties: {
          port: frontendPort
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'appGatewayBackendPool'
        properties: {
          backendAddresses: [
            {
              ipAddress: backendIpAddress
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'appGatewayBackendHttpSettings'
        properties: {
          port: backendPort
          protocol: backendProtocol
          cookieBasedAffinity: 'Disabled'
          connectionDraining: {
            drainTimeoutInSec: 20
            enabled: false
          }
          hostName: backendHostname
          path: ''
          pickHostNameFromBackendAddress: false
          probeEnabled: true
          probe: {
            id: httpProbeId
          }
          trustedRootCertificates: [
            {
              id: appGwRootcertificateId
            }
          ]
        }
      }
    ]
    httpListeners: [
      {
        name: 'appGatewayHttpListener'
        properties: {
          frontendIPConfiguration: {
            id: frontendIpConfigId
          }
          frontendPort: {
            id: frontendPortId
          }
          protocol: frontendProtocol
          sslCertificate: {
            id: sslCertificateId
          }                    
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'appGwRule1'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: httpListenerId
          }
          backendAddressPool: {
            id: backendAddressPoolId
          }
          backendHttpSettings: {
            id: backendHttpSettingsId
          }
        }
      }
    ]
    webApplicationFirewallConfiguration: {
      enabled: true
      fileUploadLimitInMb: 5
      firewallMode: 'Detection'
      maxRequestBodySizeInKb: 128
      requestBodyCheck: true
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.0'
    }
    enableHttp2: false      
    probes: [
      {
        name: 'appGatewayProbe'
        properties: {
          host: backendHealthProbeHost
          port: backendHealthProbePort
          protocol: backendHealthProbeProtocol
          path: backendHealthProbePath
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          match: {
            statusCodes: [
              '200-399'
            ]
          }
          pickHostNameFromBackendHttpSettings: false
        }
      }
    ]
    sslCertificates: [
      {
        name: 'appGatewaySslCertificate'
        properties: {
          data: sslCertData
          password: sslCertPassword
        }
      }
    ]



    trustedClientCertificates: [ ---ToCheck
      {
        id: 'string'
        name: 'string'
        properties: {
          data: 'string'
        }
      }
    ]
    trustedRootCertificates: [ ---ToCheck
      {
        id: 'string'
        name: 'string'
        properties: {
          data: 'string'
          keyVaultSecretId: 'string'
        }
      }
    ]
    
  }
}
