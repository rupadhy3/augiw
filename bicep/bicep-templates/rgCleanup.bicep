/* use an empty .bicep file to delete all resources with a resourceGroup
   run it using powershell to delete MyRGName rg and its resources as:
   New-AzResourceGroupDeployment -ResourceGroupName MyRGName -Mode Complete -TemplateFile .\rgCleanup.bicep -Force -Verbose
   Run it using az cli to delete MyRGName rg and its resources as:
   az deployment group create -g MyRGName -f rgCleanup.bicep --mode Complete
*/
