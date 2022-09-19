env=$1
instnum=$2
NOW=$(date +%d%m%Y%H%M%S)
mkdir -p /tmp/my-$NOW
BDIR="/tmp/my-$NOW"

if [[ $env == "" ]]; then echo " ERROR: Environment is not correct or provided,Please check Usage "; usage; exit 99  ; fi
if [[ $instnum == "" ]]; then echo " ERROR: Instance number  is not correct or provided,Please check Usage "; usage; exit 100  ; fi;


usage() {
  echo "Usage: basename $0 ARG1 ARG2"
  echo "Where:"
  echo "  ARG1 is the three letter environment, as dev."
  echo "  ARG2 is the instance number, as 001."
}

envl=$(echo $env| tr '[:upper:]' '[:lower:]')
NSNAME=$(echo "iwazu${envl}ina${instnum}")

cat << EOA > $BDIR/ns.yml
apiVersion: v1
kind: Namespace
metadata:
  labels:
    kubernetes.io/metadata.name: NSNAME
  name: NSNAME
EOA

sed "s/NSNAME/$NSNAME/g" $BDIR/ns.yml  |oc apply -f -


oc -n istio-system get smmr default -o yaml > /tmp/smmr.yaml
sed -n '1,/^status/p' /tmp/smmr.yaml |sed '/^status/d' > /tmp/smmr1.yaml
cat /tmp/smmr1.yaml | grep -w 'members:' > /dev/null
if [ $? != 0 ]; then
  sed "s/spec: .*/spec: /" /tmp/smmr1.yaml > /tmp/smmr2.yaml
  sed "/spec: /a \ \ members:" /tmp/smmr2.yaml > /tmp/smmr1.yaml
fi
cat /tmp/smmr1.yaml |grep $NSNAME > /dev/null
if [ $? != 0 ]; then
  echo "  - $NSNAME" >> /tmp/smmr1.yaml 
fi

oc apply -f /tmp/smmr1.yaml

oc adm policy add-scc-to-user anyuid -n $NSNAME -z default

#Need to execute below patch command on your deployment after executing this script and before executing ns2.sh
#oc -n n patch deployment/<yourdeploymentname> -p '{"spec":{"template":{"metadata":{"annotations":{"sidecar.istio.io/inject": "true"}}}}}'
