@description('Roleassignment name: 36 chars max and Must be a globally unique identifier (GUID) and must be unique across tenant')
param raName string

//param clientObjectId string
//param aroRpObjectId string

@description('Address range in Cidr for the virtual network')
@secure()
param principalId string

@description('Principal type of the assigned principal')
@allowed([
  'Device'
  'ForeignGroup'
  'Group'
  'ServicePrincipal'
  'User'
])
param principalType string

@description('The role definition ID, like azure contributer role id')
param roleDefinitionId string

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: raName
  // scope is needed if RA is created in a scope that is different than the deployment scope. 
  //scope: resourceSymbolicName or tenant()
  properties: {
    principalId: principalId
    principalType: principalType
    roleDefinitionId: roleDefinitionId
  }
}

