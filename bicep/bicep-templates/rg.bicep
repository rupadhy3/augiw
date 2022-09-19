targetScope = 'subscription'

@minLength(3)
@maxLength(30)

@description('Name for the resource group within which other resources will be deployed')
param rgName string

@description('Tags for resources')
param tags object

@description('Location or region for your resource group deployment')
param location string

// resourceGroup definition
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
  tags: tags
}

output rgId string = resourceGroup.id
output rgName string = resourceGroup.name

/* Depolyment command:
   az deployment sub create --location northeurope --template-file rg.bicep [--parameters param1='' param2='']
   Example:
   az deployment sub create --location northeurope --template-file rg.bicep --parameters rgName='rakeshu' tags="{\"env\": \"dev\",\"dept\": \"infra\"}" location='northeurope'
*/
