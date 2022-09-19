@description('Array of roleAssignments')
param roles array

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = [for role in roles: {
  name: role.name
  // scope is needed if RA is created in a scope that is different than the deployment scope. 
  //scope: resourceSymbolicName or tenant()
  properties: {
    principalId: role.principalId
    principalType: role.principalType
    roleDefinitionId: role.roleDefinitionId
  }
}]

