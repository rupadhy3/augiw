<h2>Azure Bicep</h2>
Bicep is a Domain Specific Language (DSL) for deploying Azure resources declaratively. It aims to drastically simplify the authoring experience with a cleaner syntax, improved type safety, and better support for modularity and code re-use. Bicep is a transparent abstraction over ARM and ARM templates, which means anything that can be done in an ARM Template can be done in Bicep (outside of temporary known limitations). All resource types, apiVersions, and properties that are valid in an ARM template are equally valid in Bicep on day one (Note: even if Bicep warns that type information is not available for a resource, it can still be deployed).
<br>
Bicep code is transpiled to standard ARM Template JSON files, which effectively treats the ARM Template as an Intermediate Language (IL).<br>

<h3>Folder Structure</h3>
This folder has the below folder structure:
<b><br>bicep<br>
    |<br>
    |_____bicep-deployments<br>
    |<br>
    |_____bicep-templates<br>
    |<br>
    |_____scripts<br></b>
<br>
<h1>Bicep templates:</h1>
Bicep templates are kept under teh bicep-templates folder and these are the various modules for deploying individual resources in Azure, which will be used in the bicep deploymnets for deploying resources in Azure as per the environment requirement.<br>
The various bicep templates are:<br>
01. acr.bicep<br>
02. appGateway.bicep<br>
03. aro.bicep<br>
04. keyVault-with-rbac.bicep<br>
05. keyVault-with-accessPolicy.bicep<br>
06. keyVault-with-secret.bicep<br>
07. keyVault-getSecret.bicep<br>
08. keyVault-secretAdd.bicep<br>
09. keyVaultRoleAssignment.bicep<br>
10. publicIp.bicep<br>
11. rg.bicep<br>
12. rgCleanup.bicep<br>
13. roleAssignment-multi.bicep<br>
14. roleAssignment.bicep<br>
15. storageAccount.bicep<br>
16. subnet.bicep<br>
17. vnet-subnet.bicep<br>
18. vnet.bicep<br>
<br>
<b>NOTE</b>: For Azure keyVault we have chossen to use the access policy model over the RBAC model for Azure keyVault access.<br>
   An access policy specifies what actions a particular security principal (user, group, service principal, or managed identity) <br>
      is allowed to perform over different scopes (keys, secrets, certificates).<br>
      Access policy has a limitation of upto 1024 access policies in a keyVault.<br>

<h1>Bicep deployments:</h1>
Bicep deployments are used to combine bicep templates to orchestrate the environment build, there are the following bicep deployments and details on their usage and what they do is stated below:<br>
The various bicep deployments are:<br>
<table>
<tr><th>1. </th><th>onceoff-shared-deployment.bicep     </th><th>Done</th></tr>
<tr><th>2. </th><th>onceoff-dedicated-deployment.bicep  </th><th>Initial done - to check</th></tr>
<tr><th>3. </th><th>global-resources-deployment.bicep   </th><th> to do </th></tr>
<tr><th>4. </th><th>shared-resources-deployment.bicep   </th><th> in Progress</th></tr>
<tr><th>5. </th><th>dedicated-resources-deployment.bicep</th><th> to do </th></tr>
<tr><th>6. </th><th>key-vault-add-secret.bicep           </th><th> Done / will be part of shared</th></tr>
<tr><th>7. </th><th>key-vault-add-accesspolicy.bicep     </th><th> Done / will be part of shared</th></tr>
<tr><th>8. </th><th>rgcleanup.bicep                      </th><th> Done / not required </th></tr>
</table>

<h1>Scripts:</h1>
Scripts are menat to do some tasks that can not be done through bicep:<br>
The various scripts being used are:<br>
1. check_before_onceoff_deployment.sh     : Checks if a resource group already exists then considers that onceoff deployment is not required.<br>

======================================================

<b>NOTE:</b> BELOW SUMMARY IS JUST APLACE HOLDER THESE INDIVIDUAL DEPLOYMENT MODULES DETAILS WILL BE MOVED TO OTHER SPECIFIC MARKDOWN FILES.


1. onceoff-shared-deployment.bicep:<br>
   usage:<br>
     EXAMPLE:<br>
      az deployment sub create[or what-if] --location 'northeurope' --template-file bicep-deplyments/onceOff-shared-deployment.bicep --parameters environment='SIT' location='northeurope' instancenum='001' clientObjectId4kv='b3736081-3f29-41c7-81ee-cfca495e526d' <br>
<br>
   <b>pipelineWorkflow:</b>
      Check if resource group exists (script: check_before_onceoff_deployment.sh)<br>
           -- if exists pipeline should abort<br>
           -- if does not exists pipeline should proceed with onceoff-shared-deployment<br>
<br>
   <b>itCreates:</b>
      This deploymnet bicep will deploy the following resources:<br>
         resourceGroups - for ARO, AROMANAGED, SHARED<br>
         vnet - Vnet under the SHARED resource group.<br>
         subnets - for aro-masters, ar-workers, bastion, appGateway and mgmt<br>
         keyVault - keyVault under shared resource group with read/write role assigned to contributer.<br>
<br>
   <b>cuation:</b>
      This must be executed once in the beginning of the environment setup. <br>
    <br>
    <b>NOTE:</b> Further access to the keyVault can be added using key-vault-add-accesspolicy.bicep deployment.

2. onceoff-dedicated-deployment.bicep:
   usage: 
      az seployment sub
   itCreates:
      resourceGroups - for minor environment - like DEV, SIT, UAT, TRN, POC, TST 
      subnets - minor environment subnets
      keyVault - keyVault under minor environment resource group with no access assigned

   cuation: This need to be executed before creating any other resources in Azure (except the once-off-shared-deployment)

   NOTE: Initial/Further access to the keyVault can be added using key-vault-add-accesspolicy.bicep deployment.

3. shared-resources-deployment.bicep
   usage:
   itCreates:
   cuation:

4. global-resources-deplyment.bicep
   usage:
   itCreates:
   cuation:

5. dedicated-resources-deplyment.bicep
   usage:
   itCreates:
   cuation:

6. key-vault-add-secret.bicep
   usage:<br>
     EXAMPLE:<br>
      az deployment group create --resource-group <RESOURCE-GROUP> --template-file key-vault-add-accesspolicy.bicep [--parameters ]<br>
<br>
      <b>Where:</b><br>
      <RESOURCE-GROUP> = IWAZU-MIP-NPD-SHARED-001 for NPD shared keyVault, similarly you may change the environmnet to PRD for shared or<br>
                         IWAZU-MIP-NPD-DEV-001 for NPD's DEV sub-environments, similarly change it to - SIT, DEV, UAT, POC, TRN etc <br>
                         <br>
      <b>Parameters:</b><br>
      keyVaultName = is teh name of the existing keyVault for shared it will be: IWAZU<ENV>KVT001, where <ENV> is NPD or PRD
                     IWAZU<ENV>KVT001: for dedicated it will be NPD's sub-environments -- DEV, SIT, POD, TRN, UAT etc.

      secretName: a string value with name of the secret
      secretValue: a string value with value of the secret

<br>
   <b>pipelineWorkflow:</b>
      Check if keyVault exists (script: check_if_keyvault_exists.sh)<br>
           -- if exists pipeline should continue with key-vault-add-secret.bicep <br>
           -- if does not exists pipeline should abort<br>
<br>
   <b>itCreates:</b>
      This deploymnet bicep will add access policy to the existing keyVault
<br>
   <b>cuation:</b>
      This will just add teh ccess policy to the keyVault, so teh keyVault must be existing. <br>
    <br>

   usage:
   itCreates:
   cuation:

7. key-vault-add-accesspolicy.bicep
   usage:<br>
     EXAMPLE:<br>
      az deployment group create --resource-group <RESOURCE-GROUP> --template-file key-vault-add-accesspolicy.bicep [--parameters ]<br>
<br>
      <b>Where:</b><br>
      <RESOURCE-GROUP> = IWAZU-MIP-NPD-SHARED-001 for NPD shared keyVault, similarly you may change the environmnet to PRD for shared or<br>
                         IWAZU-MIP-NPD-DEV-001 for NPD's DEV sub-environments, similarly change it to - SIT, DEV, UAT, POC, TRN etc <br>
			 <br>
      <b>Parameters:</b><br>
      keyVaultName = is teh name of the existing keyVault for shared it will be: IWAZU<ENV>KVT001, where <ENV> is NPD or PRD
                     IWAZU<ENV>KVT001: for dedicated it will be NPD's sub-environments -- DEV, SIT, POD, TRN, UAT etc.
      secertsAType = Secrets access type, it has a default value of 'all', and can take below values<br>
      certsAType = Certificates access type, it has a default value of 'all', and can take below values<br>
      keysAType = Keys access type, it has a default value of 'all', and can take below values<br>
         These can take an array parameter with one or more of the below values:<br>
	 'all'<br>
         'backup'<br>
         'create' |'set' --> secret/storage<br>
         'delete'<br>
         'get'<br>
         'import' |no --> secret/storage<br>
         'list'<br>
         'purge'<br>
	 'recover'<br>
         'restore'<br>

      <b>objectId:</b> is the objectId for the user, service principal or security group in the Azure Active Directory tenant for the vault.<br>
                it must be unique in the tenant.
<br>
   <b>pipelineWorkflow:</b>
      Check if keyVault exists (script: check_if_keyvault_exists.sh)<br>
           -- if exists pipeline should continue with key-vault-add-accesspolicy.bicep <br>
           -- if does not exists pipeline should abort<br>
<br>
   <b>itCreates:</b>
      This deploymnet bicep will add access policy to the existing keyVault
<br>
   <b>cuation:</b>
      This will just add teh ccess policy to the keyVault, so teh keyVault must be existing. <br>
    <br>


8. key-vault-remove-secret.bicep
   usage:
   itCreates:
   cuation:

9. rgcleanup.bicep
   usage:
   itCreates:
   cuation:
