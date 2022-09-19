// This module deploys resourceGroups using the rg.bicep template 
// Scope definition
targetScope='subscription'

// Parameters definition
param prefix string = 'iwazumip'
param deploymentversion string
param purpose string

@description('Environment abbreviation for deployment environment')
@allowed([
  'dev'
  'sit'
  'uat'
  'npd'
  'trn'
  'ppd'
  'prd'
])
param environment string
param location string
param tags object = {
  env: environment
  dept: 'infra'
  version: deploymentversion
}

param rgName string = '${prefix}${environment}${purpose}${deploymentversion}'
param vnetName string = '${prefix}${environment}vnet${deploymentversion}'

param vnetCidr string = '10.91.0.0/16'
param subnets array = [
  {
    name: '${prefix}${environment}msub${deploymentversion}'
    cidr: '10.91.10.0/24'
    privEndPtNwPolicies: 'Enabled'
    privLinkSvcNwPolicies: 'Disabled'
  }
  {
    name: '${prefix}${environment}wsub${deploymentversion}'
    cidr: '10.91.12.0/23'
    privEndPtNwPolicies: 'Enabled'
    privLinkSvcNwPolicies: 'Enabled'
  }
]

@description('The Object ID of an Azure Active Directory client application')
param clientObjectId string

@description('The ObjectID of the Resource Provider Service Principal')
param aroRpObjectId string

var contribRole = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
var roles = [
  {
    name: 'clientObject'
    principalId: clientObjectId
    principalType: 'ServicePrincipal'
    roleDefinitionId: contribRole
  }
  {
    name: 'aroRpObject'
    //name: guid(rgMod.outputs.rgId, deployment().name, aroRpObjectId)
    principalId: aroRpObjectId
    principalType: 'ServicePrincipal'
    roleDefinitionId: contribRole
  }
]


param clusterName string = '${prefix}${environment}aro${deploymentversion}'
param apiServerVisibility string
param ingressVisibility string
param domain string
param pullSecret string

@description('ARO managed RG name')
param aroManagedRgName string = '${prefix}${environment}aromanagedrg${deploymentversion}'

@description('Master node Size - Sku')
@allowed([
  'Standard_D2s_v3'
  'Standard_D4s_v3'
  'Standard_D8s_v3'
  'null'
])
param masterVmSku string

@description('Master node Size - Sku')
@allowed([
  'Standard_D2s_v3'
  'Standard_D4s_v3'
  'Standard_D8s_v3'
  'null'
])
param workerVmSku string

param workerCount int

@description('The Application ID of an Azure Active Directory client application')
param clientId string 

@description('The secret of an Azure Active Directory client application')
@secure()
param clientSecret string


// Module Definition
module rgMod '../bicep-templates/rg.bicep' = {
  name: '${rgName}Deploy'
  params: {
    location: location
    rgName: rgName
    tags: tags
  }
}

module vnetMod '../bicep-templates/vnet-subnet.bicep' = {
  name: '${vnetName}Deploy'
  scope: resourceGroup(rgName)
  params:{
    tags: tags
    location: location
    vnetName: vnetName
    subnets: subnets
    vnetCidr: vnetCidr
  }

  dependsOn: [
    rgMod
  ]
}

module raMod '../bicep-templates/roleAssignment.bicep' = [for role in roles: {
  name: '${role.name}Deploy'
  scope: resourceGroup(rgName)
  params:{
    raName: role.name == 'clientObject' ? '${vnet}/Microsoft.Authorization/${guid(resourceGroup().id, deployment().name, clientObjectId)}' : '${vnet}/Microsoft.Authorization/${guid(resourceGroup().id, deployment().name, aroRpObjectId)}'
    principalId: role.principalId
    principalType: role.principalType
    roleDefinitionId: role.roleDefinitionId
  }

  dependsOn: [
    vnetMod
  ]
}]

module aroMod '../bicep-templates/aro.bicep' = {
  name: '${clusterName}Deploy'
  scope: resourceGroup(rgName)
  params:{
    clusterName: clusterName
    location: location
    tags: tags
    apiServerVisibility: apiServerVisibility
    ingressVisibility: ingressVisibility
    domain: domain
    pullSecret: pullSecret
    aroManagedRgName: aroManagedRgName
    masterVmSku: masterVmSku
    workerVmSku: workerVmSku
    workerCount: workerCount
    masterSubnetId: vnetMod.outputs.subnetId[0]
    workerSubnetId: vnetMod.outputs.subnetId[1]
    clientId: clientId
    clientSecret: clientSecret
  }

  dependsOn: [
    raMod
  ]
}

/*
Depployment command:
az deployment sub create --location 'northeurope' --template-file rg-deploy.bicep --parameters environment='dev' purpose='shared' location='northeurope' deploymentversion='001' 
*/
