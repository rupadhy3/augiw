#####
## Script to check before onceoff_dedicated_deployment.sh
#####
env=$1
instancenum=$2
prefix="IWAZU"
project="MIP"

if [[ $env == 'DEV' || $env == 'SIT' || $env == 'UAT' || $env == 'TRN' || $env == 'POC' || $env == 'PPD' || $env == 'TST' ]]
then
   envmnt='NPD'
else
   echo "Error: Environment (env) is not as expected, please check and provide correct env value"
   echo "Expected env values are: DEV, SIT, UAT, TRN, POC TST or PPD"
   exit 99
fi

if [[ $instancenum != 00[0-9] ]]; then
   echo "Error: Instance number is not correct, expected values are 001 to 009"
   exit 100
fi

#IWAZU-MIP-NPD-DEV-001
RG=$(echo "${prefix}-${project}-${envmnt}-${env}-${instancenum}")

RESPONSE=$(az group exists -n $RG)

if [[ $RESPONSE == "true" ]]
then
   echo "ERROR: ${envmnt} env already exists ... aborting onceoff dedicated deployment"
else
   echo "OK: Please proceed with the onceoff dedicated deployment"
fi

