@description('Name for the Azure ARO cluster')
param clusterName string

@description('Location or region for your resource group deployment')
param location string = resourceGroup().location

@description('Tags for resources')
param tags object

@description('Api Server Visibility')
@allowed([
  'Private'
  'Public'
])
param apiServerVisibility string

@description('Ingress Visibility')
@allowed([
  'Private'
  'Public'
])
param ingressVisibility string

@description('Domain prefix for the Azure ARO cluster')
param domain string

@description('Pull secret from cloud.redhat.com. The json should be input as a string')
@secure()
param pullSecret string

@description('ARO managed RG name')
param aroManagedRgName string

@description('Master node Size - Sku')
//@allowed([
//  'Standard_D2s_v3'
//  'Standard_D4s_v3'
//  'Standard_D8s_v3'
//  'null'
//])
param masterVmSku string

@description('Master node Size - Sku')
//@allowed([
//  'Standard_D2s_v3'
//  'Standard_D4s_v3'
//  'Standard_D8s_v3'
//  'null'
//])
param workerVmSku string

@description('Provide the masterSubnetId from the previously created master subnet')
param masterSubnetId string

@description('Provide a the workerSubnetId from the previously created master subnet')
param workerSubnetId string

@description('Azure ARo clusters POD Cidr')
param podCidr string = '10.128.0.0/14'

@description('Azure ARo clusters Service Cidr')
param serviceCidr string = '172.30.0.0/16'

@description('ARO Service principal clientId - AppId')
@secure()
param clientId string

@description('ARO Service principal clientSecret')
@secure()
param clientSecret string

@description('Number of worker nodes in ARO cluster')
param workerCount int

var ingressSpec = [
  {
    name: 'default'
    visibility: ingressVisibility
  }
]

var workerSpec = {
  name: 'worker'
  VmSize: workerVmSku
  diskSizeGB: 200
  count: workerCount
}

var aroManagedRgId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${aroManagedRgName}'

// OpenShift cluster (ARO) resource definition 
resource arocluster 'Microsoft.RedHatOpenShift/openShiftClusters@2020-04-30' = {
  name: clusterName
  location: location
  tags: tags
  properties: {
    apiserverProfile: {
      visibility: apiServerVisibility
    }
    clusterProfile: {
      domain: domain
      pullSecret: pullSecret
      resourceGroupId: aroManagedRgId
    }
    ingressProfiles: [for instance in ingressSpec: {
      name: instance.name
      visibility: instance.visibility
    }]
    masterProfile: {
      vmSize: masterVmSku
      subnetId: masterSubnetId
    }
    networkProfile: {
      podCidr: podCidr
      serviceCidr: serviceCidr
    }
    // SP is required with bicep and you need to create an ARO cluster in existing SP
    servicePrincipalProfile: {
      clientId: clientId
      clientSecret: clientSecret
    }
    workerProfiles: [
      {
        name: workerSpec.name
        vmSize: workerSpec.VmSize
        diskSizeGB: workerSpec.diskSizeGB
        subnetId: workerSubnetId
        count: workerSpec.count
      }
    ]
  }
}

output consoleUrl string = arocluster.properties.consoleProfile.url
output apiUrl string = arocluster.properties.apiserverProfile.url
output ingressIp string = arocluster.properties.ingressProfiles[0].ip


// Depolyment command
/* 
   Deploy using below command: 
   az deployment group create --location northeurope --template-file aro.bicep [--parameters clientId='' clientSecret='' ]
*/
