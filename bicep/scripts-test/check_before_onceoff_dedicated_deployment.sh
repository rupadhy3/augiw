#####
## Script to check before onceoff_dedicated_deployment.sh
#####
environment=$1
instancenum=$2

if [[ $environment == 'DEV' || environment == 'SIT' || environment == 'UAT' || environment == 'TRN' || environment == 'POC' || environment == 'PPD' || environment == 'TST' ]]
then
   envmnt='YYY'
else
   echo "Error: Environment is not as expected, please check and provide correct environment value"
   echo "Expected environment values are: DEV, SIT, UAT, TRN, POC TST or PPD"
   exit 99
fi

if [[ $instancenum != 00[0-9] ]]; then
   echo "Error: Instance number is not correct, expected values are 001 to 009"
   exit 100
fi

#IWAZU-MIP-NPD-DEV-001
RG=$(echo "IWAZU-MIP-${envmnt}-${environment}-${instancenum}")

RESPONSE=$(az group exists -n $RG)

if [[ $RESPONSE == "true" ]]
then
   echo "ERROR: ${envmnt} Environment already exists ... aborting onceoff deployment"
   exit 101
else
   echo "OK: Please proceed with the onceoff deployment"
fi

