@minLength(3)
@maxLength(30)

@description('StorageAccount name')
param storageAccountName string

@description('Tags for StorageAccount')
param tags object

@description('Provide a location or region for your resource deployment')
param location string = resourceGroup().location

@description('Provide a kind or type of storage sku')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param storageSku string

@description('Provide a kind or type of storage sku')
@allowed([
  'BlobStorage'
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
  'StorageV2'
])
param storageKind string

resource storageAccountResource 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: storageSku
  }
  kind: storageKind
  properties: {
    isHnsEnabled: true
  }
}

output storageAccountName string = storageAccountName
output storageAccountId string = storageAccountResource.id

// Deployment command
/*
az deployment group create --location northeurope --template-file storageaccount.bicep
*/
