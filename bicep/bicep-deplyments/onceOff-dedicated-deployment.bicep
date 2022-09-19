/////////////////// onceOff-dedicated-deployment.bicep ///////////////////
/////////////////////////////////////////////////////////////////////////
targetScope='subscription'

// Parameters definition
@description('Common prefix to be used for naming of all devices')
param prefix string = 'IWAZU'
param project string = 'MIP'
param instancenum string = '001'
param location string
param tags object = {
  env: environment
  dept: 'infrastructure'
  project: project
  version: instancenum
}

/// Dedicated deployment only runs for the non-prod environment
@description('Environment abbreviation for deployment environment')
@allowed([
  'DEV'
  'SIT'
  'UAT'
  'TST'
  'TRN'
  'POC'
  'PPD'
])
param environment string

var envmnt = environment == 'DEV' || environment == 'SIT' || environment == 'UAT' || environment == 'TST' || environment == 'TRN' || environment == 'POC' || environment == 'PPD' ? 'NPD' : environment

// resourceGroup names: RG NAME format is: IWAZU-MIP-NPD-<APP>-001
// environment based dedicated resource group
var RGDEDICATED = '${prefix}-${project}-${envmnt}-${environment}-${instancenum}'

/// Resource group details
var rgroups = [
  {
      name: RGDEDICATED
      location: location
      tags: tags
  }
]

var keyVaultName = '${prefix}${environment}KVT${instancenum}'

@description('Specifies whether the key vault is a standard vault or a premium vault.')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

param clientObjectId4kv string

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

module oddrgDeploy '../bicep-templates/rg.bicep' = [for rg in rgroups: {
  name: rg.name
  scope: subscription()
  params: {
    location: rg.location
    rgName: rg.name
    tags: rg.tags
  }
}]

output deployedRGs array = [for (rg, i) in rgroups: {
  rgroupId: oddrgDeploy[i].outputs.rgId
}]


/// Create Key vault - Dedicated
module oddkvDeploy '../bicep-templates/keyVault-with-accesspolicy.bicep' = {
  name: keyVaultName
  scope: resourceGroup(oddrgDeploy[0].name)
  params:{
    location: location
    tags: tags
    keyVaultName: keyVaultName
    skuName: skuName
    clientObjectId4kv: clientObjectId4kv
  }
}
