
keyVaultName=$1
resourcegroup=$2

az keyvault list --resource-group $resourcegroup |grep "name" |grep $keyVaultName

if [ $? = 0 ]; then
   echo "OK to proceed: keyVault $keyVaultName exists"
else
   echo "ERROR: Aborting keyVault $keyVaultName does not exist"
fi
