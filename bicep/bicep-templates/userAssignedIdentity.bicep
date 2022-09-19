
param location string
param tags object
param identityName string
var identityID = identityNameResource.id 

resource identityNameResource 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' = {
  name: identityName
  location: location
  tags: tags
}

output identityObjectId string = reference(identityID).principalId
output identityId string = '${identityID}'

/*
get the identityName ID:
var identityID = identityName_resource.id 

get the identityName objectId:
objectId: reference(identityID).principalId
*/
