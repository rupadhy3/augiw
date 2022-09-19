targetScope='subscription'

// Parameters definition
@description('Common prefix to be used for naming of all devices')
param prefix string
param project string
param instancenum string
param location string
param datetimenow string = utcNow()
param tags object = {
  env: environment
  dept: 'infrastructure'
  project: project
  version: instancenum
  creationDate: datetimenow
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

var envmnt = environment == 'DEV' || environment == 'SIT' || environment == 'UAT' || environment == 'TST' || environment == 'TRN' || environment == 'POC' || environment == 'PPD' ? 'NPD' : environment
var envppd = environment == 'PPD' || envmnt == 'NPD' ? 'PPD' : null

// resourceGroup names: RG NAME format is: IWAZU-MIP-NPD-<APP>-001
// environment based shared resource group
var RGSHARED = '${prefix}-${project}-${envmnt}-SHARED-${instancenum}'
var RGARO = '${prefix}-${project}-${envmnt}-ARO-${instancenum}'
//var RGAROMANAGED = '${prefix}-${project}-${envmnt}-AROMNG-${instancenum}'
var RGMGT = '${prefix}-${project}-${envmnt}-MGT-${instancenum}'
var RGAROPPD = '${prefix}-${project}-${envppd}-ARO-${instancenum}'
//var RGAROMANAGEDPPD = '${prefix}-${project}-${envppd}-AROMNG-${instancenum}'
var RGMGTPPD = '${prefix}-${project}-${envppd}-MGT-${instancenum}'

/// 
var rgroups = {
  NPD: [
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
    //{
    //  name: RGAROMANAGED
    //  location: location
    //  tags: tags
    //}
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
    //{
    //  name: RGAROMANAGEDPPD
    //  location: location
    //  tags: tags
    //}
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
    //{
    //  name: RGAROMANAGED
    //  location: location
    //  tags: tags
    //}
    {
      name: RGMGT
      location: location
      tags: tags
    }
  ]
}

var vnetName = '${prefix}${envmnt}-${project}-NET-${instancenum}'
var vnetCidr = environment == 'DEV' || environment == 'SIT' || environment == 'UAT' || environment == 'TST' || environment == 'TRN' || environment == 'POC' || environment == 'PPD' ? '10.86.32.0/20' : 'null'

param npdAOMCidr string   //'10.86.32.0/24'
param npdAOWCidr string   //'10.86.33.0/24'
param npdAGWCidr string   //'10.86.47.0/24'
param npdBASCidr string   //'10.86.46.192/26'
param npdMGTCidr string   //'10.86.46.0/26'
param npdDEVCidr string   //'10.86.46.64/26'
param ppdAOMCidr string   //'10.86.34.0/24'
param ppdAOWCidr string   //'10.86.35.0/24'
param npdAPICidr string   //'10.86.45.0/27'
param npdPVTCidr string   //'10.86.46.128/26'
param npdASPCidr string   //'10.86.36.0/24'

param prdAOMCidr string   //'10.86.0.0/24'
param prdAOWCidr string   //'10.86.1.0/24'
param prdAGWCidr string   //'10.86.15.0/24'
param prdBASCidr string   //'10.86.14.192/26'
param prdMGTCidr string   //'10.86.14.0/26'
param prdAPICidr string   //'10.86.13.0/27'
param prdPVTCidr string   //'10.86.14.128/26'
param prdASPCidr string   //'10.86.2.0/26'

var subnets = {
  NPD: [
    {
      name: '${prefix}${envmnt}-${project}AOM-SUB-001'
      cidr: npdAOMCidr
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Disabled'
    }
    {
      name: '${prefix}${envmnt}-${project}AOW-SUB-002'
      cidr: npdAOWCidr
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled' 
    }
    {
      name: '${prefix}${envmnt}-${project}AGW-SUB-003'
      cidr: npdAGWCidr
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      //name: '${prefix}${envmnt}-${project}BAS-SUB-004'
      name: 'AzureBastionSubnet'
      cidr: npdBASCidr
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      name: '${prefix}${envmnt}-${project}MGT-SUB-005'
      cidr: npdMGTCidr
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      name: '${prefix}${envmnt}-${project}DEV-SUB-006'
      cidr: npdDEVCidr
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      name: '${prefix}${envppd}-${project}AOM-SUB-012'
      cidr: ppdAOMCidr
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Disabled'
    }
    {
      name: '${prefix}${envppd}-${project}AOW-SUB-013'
      cidr: ppdAOWCidr
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled' 
    }
    {
      name: '${prefix}${envmnt}-${project}API-SUB-014'
      cidr: npdAPICidr
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      name: '${prefix}${envmnt}-${project}PVT-SUB-015'
      cidr: npdPVTCidr
      privEndPtNwPolicies: 'Disabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      name: '${prefix}${envmnt}-${project}ASP-SUB-016'
      cidr: npdASPCidr
      privEndPtNwPolicies: 'Disabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
  ]
  PRD: [
    {
      name: '${prefix}${envmnt}-${project}AOM-SUB-001'
      cidr: prdAOMCidr
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Disabled'
    }
    {
      name: '${prefix}${envmnt}-${project}AOW-SUB-002'
      cidr: prdAOWCidr
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled' 
    }
    {
      name: '${prefix}${envmnt}-${project}AGW-SUB-003'
      cidr: prdAGWCidr
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      //name: '${prefix}${envmnt}-${project}BAS-SUB-004'
      name: 'AzureBastionSubnet'
      cidr: prdBASCidr
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      name: '${prefix}${envmnt}-${project}MGT-SUB-005'
      cidr: prdMGTCidr
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      name: '${prefix}${envmnt}-${project}PVT-SUB-015'
      cidr: prdPVTCidr
      privEndPtNwPolicies: 'Disabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      name: '${prefix}${envmnt}-${project}API-SUB-014'
      cidr: prdAPICidr
      privEndPtNwPolicies: 'Enabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
    {
      name: '${prefix}${envmnt}-${project}ASP-SUB-016'
      cidr: prdASPCidr
      privEndPtNwPolicies: 'Disabled'
      privLinkSvcNwPolicies: 'Enabled'
    }
  ]
}

// This is used in production
//var keyVaultName = '${prefix}${envmnt}KV0${instancenum}'
// below is used in testing since KVT005 instancenum=5 will be free
var keyVaultName = '${prefix}${envmnt}KVT${instancenum}'

@description('Specifies whether the key vault is a standard vault or a premium vault.')
@allowed([
  'standard'
  'premium'
])
param kvSkuName string

param clientObjectId4kv string

param mysecrets array 

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
    skuName: kvSkuName
    clientObjectId4kv: clientObjectId4kv
  }
}

/// Add secret to keyVault
module kvAddSecret '../bicep-templates/kv-secretAdd.bicep' = {
  name: '${keyVaultName}SecretAdd'
  scope: resourceGroup(rgDeploy[0].name)
  params:{
    kvName: keyVaultName
    mysecrets: mysecrets
  }
  dependsOn: [
    kvDeploy
  ]
}

/// Deployment command - example only
/// az deployment sub what-if --location 'northeurope' --template-file bicep-deplyments/onceOff-shared-deployment.bicep --parameters environment='SIT' location='northeurope' instancenum='005' clientObjectId4kv='b3736081-3f29-41c7-81ee-cfca495e526d'
/// az deployment sub create --location 'northeurope' --template-file bicep-deplyments/onceOff-shared-deployment.bicep --parameters environment='SIT' location='northeurope' instancenum='005' clientObjectId4kv='b3736081-3f29-41c7-81ee-cfca495e526d'
