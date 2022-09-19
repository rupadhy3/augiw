@description('Specifies the name of the Log Analytics Workspace.')
param logWorkspaceName string

@description('Specifies the Azure location where the resource should be created.')
param location string 

param tags object

param skuName string = 'PerGB2018'

param retentionDays int = 30

param dailyQuotaGB int = 20

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: logWorkspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: skuName
    }
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    retentionInDays: retentionDays
    workspaceCapping: {
      dailyQuotaGb: dailyQuotaGB
    }
  }
}

output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
