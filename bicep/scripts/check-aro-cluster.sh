## This script need to be run by devops service connection
ENV=$1
INSTNUM=$2

usage() {
  echo "`basename $0` ARG1 ARG2"
  echo "Where:"
  echo "ARG1 is the environment with possible values: DEV, SIT, UAT, TRN, TST, POC, PPD or PRD"
  echo "ARG2 is the instance number, with possible values from 001 to 009"
  echo ""
}

###Check for the arguments
if [[ $ENV == "DEV" || $ENV == "SIT" || $ENV == "UAT" || $ENV == "TRN" || $ENV == "POC" || $ENV == "TST" || $ENV == "PPD" || $ENV == "PRD" ]]; then
   echo "OK: Provided environment is fine."
else
   echo "ERROR: Provided environment is not correct ... exiting."
   usage
   exit 99
fi

if [[ $INSTNUM == 00[1-9] ]]; then
   echo "OK: Provided Instance number is fine"
else
   echo "ERROR: Provided instance number is not correct ... exiting."
   usage
   exit 100
fi


if [[ $ENV == "DEV" || $ENV == "SIT" || $ENV == "UAT" || $ENV == "TRN" || $ENV == "POC" || $ENV == "TST" || $ENV == "PPD" ]]; then
   AENV="NPD"
else 
   AENV="PRD"
fi

CLUSTER="IWAZU${AENV}ARO${INSTNUM}"
ARORG="IWAZU-MIP-${AENV}-ARO-${INSTNUM}"

az aro list --resource-group $ARORG -o table | grep $CLUSTER |grep -i Succeeded > /dev/null
if [ $? = 0 ]; then 
   echo "Cluster $CLUSTER Exists"
   export AROCREATE="false"
   echo $AROCREATE > /tmp/AROCREATE
else
   echo "Cluster $CLUSTER does not exist"
   export AROCREATE="true"
   echo $AROCREATE > /tmp/AROCREATE
fi

