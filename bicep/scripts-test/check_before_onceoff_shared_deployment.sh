#####
## Script to check before onceoff_shared_deployment.sh
#####
environment=$1
instancenum=$2

###if [[ $environment != 'DEV' || environment != 'SIT' || environment != 'UAT' || environment != 'TRN' || environment != 'POC' || environment != 'PPD' || environment != 'TST' || environment != 'PRD' ]]
if [[ $environment == 'DEV' || $environment == 'SIT' || $environment == 'UAT' || $environment == 'TRN' || $environment == 'POC' || $environment == 'PPD' || $environment == 'TST' ]]
then
   echo "Good to proceed"
else
   echo "Error: Environment is not as expected, please check and provide correct environment value"
   echo "Expected environment values are: DEV, SIT, UAT, TRN, POC TST, PPD or PRD" ## PRD removed for testing
   exit 99
fi

if [[ $instancenum != 00[0-9] ]]; then
   echo "Error: Instance number is not correct, expected values are 001 to 009"
   exit 100
fi

if [[ $environment == 'DEV' || $environment == 'SIT' || $environment == 'UAT' || $environment == 'TRN' || $environment == 'POC' || $environment == 'PPD' || $environment == 'TST' ]]
then
   envmnt='YYY'
else
   envmnt='AAA'
fi

#IWAZU-MIP-NPD-SHARED-001

RG=$(echo "IWAZU-MIP-${envmnt}-SHARED-${instancenum}")
echo $RG

RESPONSE=$(az group exists -n $RG)

echo $RESPONSE
if [[ $RESPONSE == "true" ]]
then
   echo "ERROR: ${envmnt} Environment already exists ... aborting onceoff deployment"
   exit 101
else
   echo "OK: Please proceed with the onceoff deployment"
fi

