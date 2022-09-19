@minLength(5)
@maxLength(50)

@description('Provide a globally unique name of your Azure Container Registry')
param acrName string

@description('Provide a location for the registry.')
param location string

@description('Tier of your Azure Container Registry')
@allowed([
  'Basic'
  'Classic'
  'Premium'
  'Standard'
])
param acrSku string = 'Basic'

resource acr 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: true
    anonymousPullEnabled: false
  }
}

@description('Output the login server property for later use')
output loginServer string = acr.properties.loginServer

/* Comments here
Deployment steps:
1. Connect to Azure using - az login
2. Set you subscription using - az account set <subscription>
3. To deploy resource to a resource-group:
az deployment group create --resource-group <resource-group-name> --template-file <path-to-bicep>

   To deploy resource to a subscription:
az deployment sub create --location <location> --template-file <path-to-bicep>
*/
