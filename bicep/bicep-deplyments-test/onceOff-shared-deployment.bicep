targetScope='subscription'

// Parameters definition
@description('Common prefix to be used for naming of all devices')
param prefix string = 'IWAZU'
param project string = 'MIP'
param instancenum string = '009'
param location string
param tags object = {
  env: environment
  dept: 'infrastructure'
  project: project
  version: instancenum
}

@description('Environment abbreviation for deployment environment')
@allowed([
  'DEV'
  'SIT'
  'UAT'
  'TST'
  'TRN'
  'POC'
  'PPD'
  'PRD'
])
param environment string

var envmnt = environment == 'DEV' || environment == 'SIT' || environment == 'UAT' || environment == 'TST' || environment == 'TRN' || environment == 'POC' || environment == 'PPD' ? 'YYY' : environment
var envppd = environment == 'PPD' || envmnt == 'YYY' ? 'ZZZ' : null

// resourceGroup names: RG NAME format is: IWAZU-MIP-NPD-<APP>-001
// environment based shared resource group
var RGSHARED = '${prefix}-${project}-${envmnt}-SHARED-${instancenum}'
var RGARO = '${prefix}-${project}-${envmnt}-ARO-${instancenum}'
var RGAROMANAGED = '${prefix}-${project}-${envmnt}-AROMNG-${instancenum}'
var RGMGT = '${prefix}-${project}-${envmnt}-MGT-${instancenum}'
var RGAROPPD = '${prefix}-${project}-${envppd}-ARO-${instancenum}'
var RGAROMANAGEDPPD = '${prefix}-${project}-${envppd}-AROMNG-${instancenum}'
var RGMGTPPD = '${prefix}-${project}-${envppd}-MGT-${instancenum}'

/// 
var rgroups = {
  YYY: [
    {
      name: RGSHARED
      location: location
      tags: tags
    }
    {
      name: RGARO
      location: location
      tags: tags
    }
    {
      name: RGAROMANAGED
      location: location
      tags: tags
    }
    {
      name: RGMGT
      location: location
      tags: tags
    }
    {
      name: RGAROPPD
      location: location
      tags: tags
    }
    {
      name: RGAROMANAGEDPPD
      location: location
      tags: tags
    }
    {
      name: RGMGTPPD
      location: location
      tags: tags
    }
  ]
  PRD: [
    {
      name: RGSHARED
      location: location
      tags: tags
    }
    {
      name: RGARO
      location: location
      tags: tags
    }
    {
      name: RGAROMANAGED
      location: location
      tags: tags
    }
    {
      name: RGMGT
      location: location
      tags: tags
    }
  ]
}

var vnetName = '${prefix}${envmnt}-${project}-NET-003'
var vnetCidr = environment == 'DEV' || environment == 'SIT' || environment == 'UAT' || environment == 'TST' || environment == 'TRN' || environment == 'POC' || environment == 'PPD' ? '10.80.0.0/16' : '10.100.0.0/16'

var subnets = {
  YYY: [
    {
      name: '${prefix}${envmnt}-${project}AOM-SUB-001'
      cidr: '10.80.1.0/24'
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Disabled'
    }
    {
      name: '${prefix}${envmnt}-${project}AOW-SUB-002'
      cidr: '10.80.2.0/24'
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled' 
    }
    {
      name: '${prefix}${envmnt}-${project}AGW-SUB-003'
      cidr: '10.80.3.0/24'
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      name: '${prefix}${envmnt}-${project}BAS-SUB-004'
      cidr: '10.80.4.0/24'
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      name: '${prefix}${envmnt}-${project}MGT-SUB-005'
      cidr: '10.80.5.0/24'
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      name: '${prefix}${envppd}-${project}AOM-SUB-006'
      cidr: '10.80.6.0/24'
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Disabled'
    }
    {
      name: '${prefix}${envppd}-${project}AOW-SUB-007'
      cidr: '10.80.7.0/24'
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled' 
    }
    {
      name: '${prefix}${envppd}-${project}MGT-SUB-008'
      cidr: '10.80.8.0/24'
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
  ]
  PRD: [
    {
      name: '${prefix}${envmnt}-${project}AOM-SUB-001'
      cidr: '10.100.1.0/24'
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Disabled'
    }
    {
      name: '${prefix}${envmnt}-${project}AOW-SUB-002'
      cidr: '10.100.2.0/24'
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled' 
    }
    {
      name: '${prefix}${envmnt}-${project}AGW-SUB-003'
      cidr: '10.100.3.0/24'
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      name: '${prefix}${envmnt}-${project}BAS-SUB-004'
      cidr: '10.100.4.0/24'
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      name: '${prefix}${envmnt}-${project}MGT-SUB-005'
      cidr: '10.100.5.0/24'
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
  ]
}

//var keyVaultName = '${prefix}${envmnt}KVT${instancenum}'
var keyVaultName = '${prefix}${envmnt}KVT003'

@description('Specifies whether the key vault is a standard vault or a premium vault.')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

param clientObjectId4kv string

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

module rgDeploy '../bicep-templates/rg.bicep' = [for rg in rgroups[envmnt]: {
  name: rg.name
  scope: subscription()
  params: {
    location: rg.location
    rgName: rg.name
    tags: rg.tags
  }
}]

output deployedRGs array = [for (rg, i) in items(rgroups): {
  rgroupId: rgDeploy[i].outputs.rgId
}]

/// Create Vnet and Subnets
module vnetDeploy '../bicep-templates/vnet-subnet.bicep' = {
  name: vnetName
  scope: resourceGroup(rgDeploy[0].name)
  params:{
    tags: tags
    location: location
    vnetName: vnetName
    subnets: subnets[envmnt]
    vnetCidr: vnetCidr
  }

  dependsOn: [
    rgDeploy
  ]
}

/// Create Key vault - Shared
module kvDeploy '../bicep-templates/keyVault-with-accesspolicy.bicep' = {
  name: keyVaultName
  scope: resourceGroup(rgDeploy[0].name)
  params:{
    location: location
    tags: tags
    keyVaultName: keyVaultName
    skuName: skuName
    clientObjectId4kv: clientObjectId4kv
  }
}
