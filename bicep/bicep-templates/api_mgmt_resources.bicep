@description('The name of the API Management service instance')
param apiManagementServiceName string

param displayName string
param apiType string
param apiRevision string
param apiFormat string
param apiPath string
param protocols array
param apiValue string
param apiPolicyValue string
param apiPolicyFormat string


/////////////////////////////////////////////////
resource apiManagementService 'Microsoft.ApiManagement/service@2021-12-01-preview' existing = {
  name: apiManagementServiceName
}

resource apiManagementServiceApi 'Microsoft.ApiManagement/service/apis@2021-12-01-preview' = {
  parent: apiManagementService
  name: '${displayName}-api'
  properties: {
    displayName: displayName
    apiType: apiType
    apiRevision: apiRevision
    format: apiFormat
    path: apiPath
    protocols: protocols
    isCurrent: true
    subscriptionRequired: true
    type: apiType
    value: apiValue
    }
  }

resource unlimitedProduct 'Microsoft.ApiManagement/service/products@2021-12-01-preview' = {
  parent: apiManagementService
  name: 'unlimited'
  properties: {
    displayName: 'Unlimited'
    description: 'Subscribers have completely unlimited access to the API. Administrator approval is required.'
    subscriptionRequired: true
    approvalRequired: true
    subscriptionsLimit: 1
    state: 'published'
  }
}

resource AssociateProduct 'Microsoft.ApiManagement/service/products/apis@2021-12-01-preview' = {
  name: '${displayName}-api'
  parent: unlimitedProduct 
  dependsOn: [
    apiManagementService
  ]
}

////////////////////////////////////////
resource associatepolicy 'Microsoft.ApiManagement/service/apis/policies@2021-12-01-preview' = {
  parent: apiManagementServiceApi
  name: 'policy'
  properties: {
    value: apiPolicyValue
    format: apiPolicyFormat
  }
  dependsOn: [
    apiManagementServiceApi
  ]
}



// az deployment group create --resource-group IWAZU-MIP-NPD-SHARED-002 --template-file api_mgmt.bicep --parameters 
