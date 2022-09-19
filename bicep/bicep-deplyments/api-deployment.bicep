param virtualNetworkName string = 'IWAZUNPD-MIP-NET-002'
param apiSubnetName string = 'IWAZUNPD-MIPAPI-SUB-014'
param apiManagementServiceName string = 'IWAZUNPDAPI002'
param location string = resourceGroup().location
//param tags object

@description('The pricing tier of this API Management service')
@allowed([
  'Developer'
  'Basic'
  'Standard'
  'Premium'
])
param apiSku string = 'Developer'

param apiSkuCount int = 1
param publisherEmail string = 'rakesh.upadhyay1@ibm.com'
param publisherName string = 'RU'

@description('Virtual network type for the api')
@allowed([
  'External'
  'Internal'
  'None'
])
param apiVnetType string = 'Internal'

/*
param displayName string = 'Maximo-SIT'
param apiType string = 'http'
param apiRevision string = '1'
param apiFormat string = 'openapi+json'
param apiPath string = 'Maximo-SIT'
param apiValue string = '{"openapi":"3.0.1","info":{"title":"Maximo-SIT","contact":{},"version":"1.0"},"servers":[{"url":"https://10.231.8.24:8080/maximo/api/os"}],"paths":{"/*":{"get":{"summary":"Common-Get","description":"Generic get method to support all get calls to Maximo","operationId":"common-get","responses":{"200":{"description":null}}},"post":{"summary":"Common-Post","description":"Generic Post method to support all post calls to Maximo","operationId":"common-post","responses":{"200":{"description":null}}}}},"components":{"securitySchemes":{"apiKeyHeader":{"type":"apiKey","name":"Ocp-Apim-Subscription-Key","in":"header"},"apiKeyQuery":{"type":"apiKey","name":"subscription-key","in":"query"}}},"security":[{"apiKeyHeader":[]},{"apiKeyQuery":[]}],"tags":[{"name":"dev","description":""}]}'
param protocols array = [
    'https'
]

param apiPolicyValue string = '<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.\r\n    - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n    - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.\r\n-->\r\n<policies>\r\n  <inbound>\r\n    <base />\r\n    <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">\r\n      <openid-config url="https://login.microsoftonline.com/60beb100-3973-4346-bd68-d1c4eb6f4c42/.well-known/openid-configuration" />\r\n      <audiences>\r\n        <audience>https://mymipapi.water.ie</audience>\r\n      </audiences>\r\n    </validate-jwt>\r\n    <set-header name="Content-Type" exists-action="override">\r\n      <value>application/json</value>\r\n    </set-header>\r\n    <set-header name="x-public-uri" exists-action="override">\r\n      <value>http://maximo-project2.vip.iwater.ie/maximo/api</value>\r\n    </set-header>\r\n  </inbound>\r\n  <backend>\r\n    <base />\r\n  </backend>\r\n  <outbound>\r\n    <base />\r\n  </outbound>\r\n  <on-error>\r\n    <base />\r\n  </on-error>\r\n</policies>'
param apiPolicyFormat string = 'xml'
*/

var apiResources = [
  {
    displayName: 'Maximo-SIT'
    apiType: 'http'
    apiRevision: '1'
    apiFormat: 'openapi+json'
    apiPath: 'Maximo-SIT'
    apiValue: '{"openapi":"3.0.1","info":{"title":"Maximo-SIT","contact":{},"version":"1.0"},"servers":[{"url":"https://10.231.8.24:8080/maximo/api/os"}],"paths":{"/*":{"get":{"summary":"Common-Get","description":"Generic get method to support all get calls to Maximo","operationId":"common-get","responses":{"200":{"description":null}}},"post":{"summary":"Common-Post","description":"Generic Post method to support all post calls to Maximo","operationId":"common-post","responses":{"200":{"description":null}}}}},"components":{"securitySchemes":{"apiKeyHeader":{"type":"apiKey","name":"Ocp-Apim-Subscription-Key","in":"header"},"apiKeyQuery":{"type":"apiKey","name":"subscription-key","in":"query"}}},"security":[{"apiKeyHeader":[]},{"apiKeyQuery":[]}],"tags":[{"name":"dev","description":""}]}'
    protocols: [
       'https'
    ]
    apiPolicyValue: '<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.\r\n    - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n    - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.\r\n-->\r\n<policies>\r\n  <inbound>\r\n    <base />\r\n    <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">\r\n      <openid-config url="https://login.microsoftonline.com/60beb100-3973-4346-bd68-d1c4eb6f4c42/.well-known/openid-configuration" />\r\n      <audiences>\r\n        <audience>https://mymipapi.water.ie</audience>\r\n      </audiences>\r\n    </validate-jwt>\r\n    <set-header name="Content-Type" exists-action="override">\r\n      <value>application/json</value>\r\n    </set-header>\r\n    <set-header name="x-public-uri" exists-action="override">\r\n      <value>http://maximo-project2.vip.iwater.ie/maximo/api</value>\r\n    </set-header>\r\n  </inbound>\r\n  <backend>\r\n    <base />\r\n  </backend>\r\n  <outbound>\r\n    <base />\r\n  </outbound>\r\n  <on-error>\r\n    <base />\r\n  </on-error>\r\n</policies>'
    apiPolicyFormat: 'xml'
  }
]

//////////////////////////////////////////////////////////////////
module apiMgmtSvcMod '../bicep-templates/api_mgmt_new.bicep' = {
  name: '${apiManagementServiceName}-Deploy'
  params:{
    virtualNetworkName: virtualNetworkName
    apiSubnetName: apiSubnetName
    apiManagementServiceName: apiManagementServiceName
    location: location
    //tags: tags
    apiSku: apiSku
    apiSkuCount: apiSkuCount
    publisherEmail: publisherEmail
    publisherName: publisherName
    apiVnetType: apiVnetType
  }
}

module apiMgmtSvcResourcesMod '../bicep-templates/api_mgmt_resources.bicep' = [for resValue in apiResources: {
  name: '${resValue.displayName}-apiResources-Deploy'
  params:{
    apiManagementServiceName: apiManagementServiceName
    displayName: resValue.displayName
    apiType: resValue.apiType
    apiRevision: resValue.apiRevision
    apiFormat: resValue.apiFormat
    apiPath: resValue.apiPath
    protocols: resValue.protocols
    apiValue: resValue.apiValue
    apiPolicyValue: resValue.apiPolicyValue
    apiPolicyFormat: resValue.apiPolicyFormat
  }
  dependsOn: [
    apiMgmtSvcMod
  ]
}]
