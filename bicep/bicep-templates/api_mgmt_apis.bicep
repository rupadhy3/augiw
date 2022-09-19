

param apis object = {
  displayName: 'somename'
  apiRevision: '1'
  serviceUrl: 'https://abc.com/xyz'
  path: 'xyz_api'
  protocols: [
    'https'
  ]
}

resource apiManagementServiceApis 'Microsoft.ApiManagement/service/apis@2021-12-01-preview' = [ for api in apis: {
  parent: apiManagementService
  name: api.apiName
  properties: {
    displayName: api.displayName
    apiRevision: api.apiRevision
    subscriptionRequired: 'true'
    serviceUrl: api.serviceUrl
    path: api.path
    protocols: api.protocols   // is an array or protocols inside []
    isCurrent: 'true'
  }
}

resource apiManagementServiceSubscription 'Microsoft.ApiManagement/service/subscriptions@2021-08-01' = {
  parent: service_IWAZUNPDAPI001_name_resource
  name: subscriptionName
  properties: {
    scope: service_IWAZUNPDAPI001_name_testhttp.id
    displayName: 'API testhttp subscription'
    state: 'active'
    allowTracing: true
  }
}


