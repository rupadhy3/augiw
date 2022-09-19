## This script need to run using the DevOps regular service connection
# Script requires to be run on bash shell and jq tool available
# to run the script - usage:
# keepKvValue.sh <SUBSID> <NEWSPNAME> <KVNAME> -- new tenantid and masterspname are not required
# Where: SUBSID="00fe6969-c451-4979-b280-e4387d5ac43a"
#        NEWSPNAME="IWAZUNPDAROSP002"
#        KVNAME="IWAZUNPDKVT002"
#


SUBSID=$1
NEWSPNAME=$2
KVNAME=$3
PULL_SECRET_FILE="bicep/scripts/pull-secret.txt"


usage() {
   echo "`basename $0` ARG1 ARG2 ARG3"
   echo "Where:"
   echo "ARG1 is the Azure subscription ID."
   echo "ARG2 is the display name for new service principal."
   echo "ARG3 is the display name for key vault."
}

## Uncomment this if statement if pull-secret is provided as an argument
## Comment this if statement if pull-secret is provided as a file
## At a time only one of the below 2 if statements can be active.
#if [[ ${PULL_SECRET} == "" ]]; then
#   echo "ERROR: Pull-secret is not provided or it is incorrect, please check and provide correct RedHat Pull-secret"
#   usage
#   exit 1
#fi
#pullSecret=${PULL_SECRET}

## Comment this if statement if above if statement is uncommented
if [ -s "${PULL_SECRET_FILE}" ]; then
   echo "Redhat Openshift pull secret file exists"
else
   echo "Redhat Openshift pull secret file pull-secret.txt does not exist under the current directory, please and run the script again"
   exit 99
fi
pullSecret=$(cat ${PULL_SECRET_FILE})


if [[ $SUBSID == "" ]]; then 
   echo "ERROR: Subscription is not provided or it is incorrect, please check and provide correct Azure subscription ID"
   usage
   exit 100
fi

if [[ $NEWSPNAME == "" ]]; then 
   echo "ERROR: New Service Principal (to create) name is not provided or it is incorrect, please check and provide correct name for New Service Principal"
   usage
   exit 101
fi

if [[ $KVNAME == "" ]]; then 
   echo "ERROR: Key Vault name is not provided or it is incorrect, please check and provide correct name for Key Vault"
   usage
   exit 102
fi

## Azure login using service principal
##az login --service-principal --username $MASTERSPID --password PASSWORD --tenant tenantID

## Target the specific and relevant subscription ID:
az account set --subscription $SUBSID

##Read client ID and secret from the temporary file
aroclientId=$(cat tmp-aro-sp.json|grep -i appId|cut -d':' -f2|cut -d'"' -f2)
aroclientSecret=$(cat tmp-aro-sp.json|grep -i password|cut -d':' -f2|cut -d'"' -f2)
#aadclientId="$(jq -r .appId <tmp-aro-sp.json)"
#aadclientSecret="$(jq -r .password <tmp-aro-sp.json)"

#clientObjectId="$(az ad sp list --filter "AppId eq '$aroclientId'" --query "[?appId=='$aroclientId'].objectId" -o tsv)"
#aroRpObjectId="$(az ad sp list --filter "displayname eq 'Azure Red Hat OpenShift RP'" --query "[?appDisplayName=='Azure Red Hat OpenShift RP'].{objectId: objectId}" -o tsv)"
clientObjectId=$(cat tmp-aro-sp.json|grep -i clientObjectId |cut -d' ' -f2)
aroRpObjectId=$(cat tmp-aro-sp.json|grep -i aroRpObjectId |cut -d' ' -f2)

## Above avlues into key vault 
az keyvault secret set --name aroclientId --vault-name $KVNAME --value $aroclientId
az keyvault secret set --name aroclientSecret --vault-name $KVNAME --value $aroclientSecret
az keyvault secret set --name clientObjectId --vault-name $KVNAME --value $clientObjectId
az keyvault secret set --name aroRpObjectId --vault-name $KVNAME --value $aroRpObjectId
az keyvault secret set --name pullSecret --vault-name $KVNAME --value $pullSecret

rm tmp-aro-sp.json
