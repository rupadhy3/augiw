#####
## Script to check before onceoff_shared_deployment.sh
#####
env=$1
instancenum=$2
prefix="IWAZU"
project="MIP"

echo "Environment=$env, Instance=$instancenum, Prefix=$prefix, Project=$project"

usage() {
   echo "`basename $0` ARG1 ARG2"
   echo "Where:"
   echo "ARG1 is the environment and expects a value of: DEV, SIT, UAT, TRN, POC, TST, PPD or PRD"
   echo "ARG2 is the instance number and expects a value of 001, oo2, 003 ... to 009"
}

if [[ $env == 'DEV' || $env == 'SIT' || $env == 'UAT' || $env == 'TRN' || $env == 'POC' || $env == 'PPD' || $env == 'TST' || $env == 'PRD' ]]
then
   echo "OK: Environment is good, proceeding with further checks"
else
   echo "Error: Environment is either not provided or not provided as expected, please check and provide correct env value"
   usage
   exit 99
fi

if [[ $instancenum != 00[0-9] ]]; then
   echo "Error: Instance number is either not provided or it is not correct."
   usage
   exit 100
fi

if [[ $env == 'DEV' || $env == 'SIT' || $env == 'UAT' || $env == 'TRN' || $env == 'POC' || $env == 'PPD' || $env == 'TST' ]]
then
   envmnt='NPD'
else
   envmnt='PRD'
fi

echo "Management Environment = $envmnt"

#IWAZU-MIP-NPD-SHARED-001

RG=$(echo "${prefix}-${project}-${envmnt}-SHARED-${instancenum}")

echo "ResourceGroup = $RG"

RESPONSE=$(az group exists -n $RG)

echo "Response = $RESPONSE"

export RESPONSE=$RESPONSE
echo $RESPONSE > /tmp/RESPONSE

## Wanted to comment out belwo line so with the output of RESPONSE we can take decision to 
## execute shared deployment or not
## So if RESPONSE=true, DO NOT RUN the shared-deployment bicep
##    if RESPONSE=false, RUN the shared-deployment bicep
#if [[ $RESPONSE == "true" ]]
#then
#   echo "ERROR: ${envmnt} Environment already exists ... aborting onceoff shared deployment"
#   exit 102
#else
#   echo "OK: Please proceed with the onceoff shared deployment"
#fi

