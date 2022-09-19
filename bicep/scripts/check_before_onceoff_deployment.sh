#####

environment=$1
instancenum=$2

if [[ $environment == 'DEV' || environment == 'SIT' || environment == 'UAT' || environment == 'TRN' || environment == 'POC' || environment == 'PPD' || environment == 'TST' ]]
then
   envmnt='NPD'
else
   envmnt='PRD'
fi

#IWAZU-MIP-NPD-SHARED-001

RG=$(echo "IWAZU-MIP-${envmnt}-SHARED-${instancenum}")
echo "RG is $RG"

RESPONSE=$(az group exists -n $RG)
echo "RESPONSE is $RESPONSE"

if [[ $RESPONSE == "true" ]]
then
   echo "ERROR: ${envmnt} Environment already exists ... aborting onceoff deployment"
   exit 99
else
   echo "OK: Please proceed with the onceoff deployment"
fi

