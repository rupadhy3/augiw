#!/bin/bash
NSNAME=$1
SVCNAME=$2
SVCPORT=$3
GLP=$4
NOW=$(date +%d%m%Y%H%M%S)
mkdir -p /tmp/my-$NOW
BDIR="/tmp/my-$NOW"

HOSTDOMAIN=$(oc whoami --show-console | cut -d "." -f2-6)
if [[ $NSNAME == "" || $SVCNAME == "" || $SVCPORT == "" || $GLP == "" ]]; then echo "Error: One or more required arguments are missing"; usage; exit 100; fi


usage() {
	  echo "Usage: basename $0 ARG1 ARG2 ARG3 ARG4"
	  echo "Where:"
	  echo "  ARG1 is the namespace name."
	  echo "  ARG2 is the service name (oc get svc)."
	  echo "  ARG3 is the service port number."
	  echo "  ARG4 is the path for the graphql route."
}

cat << EOA > $BDIR/gw.yml
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: graphql-gateway
  namespace: NSNAME
spec:
  selector:
    istio: ingressgateway
  servers:
  - hosts:
    - NSNAME.HOSTDOMAIN
    port:
      name: https
      number: 443
      protocol: HTTPS
    tls:
      credentialName: iwtls-secret
      mode: SIMPLE
EOA
cat << EOB > $BDIR/vs.yml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: graphql
  namespace: NSNAME
spec:
  gateways:
  - graphql-gateway
  hosts:
  - HOSTROUTE 
  http:
  - match:
    - uri:
        exact: GLP
    route:
    - destination:
        host: SVCNAME
        port:
          number: SVCPORT
EOB
cat << EOC > $BDIR/ra.yml
apiVersion: security.istio.io/v1beta1
kind: RequestAuthentication
metadata:
  name: jwt-iw
  namespace: NSNAME
spec:
  jwtRules:
  - forwardOriginalToken: true
    issuer: https://sts.windows.net/60beb100-3973-4346-bd68-d1c4eb6f4c42/
    jwksUri: https://login.microsoftonline.com/common/discovery/keys
    outputPayloadToHeader: x-jwt
  selector:
    matchLabels:
      app: SVCNAME
EOC
cat << EOD > $BDIR/ap.yml
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: require-jwt-iw
  namespace: NSNAME
spec:
  action: DENY
  rules:
  - from:
    - source:
        notRequestPrincipals:
        - '*'
  selector:
    matchLabels:
      app: SVCNAME
EOD

sed "s/NSNAME/$NSNAME/g" $BDIR/gw.yml | sed "s/HOSTDOMAIN/$HOSTDOMAIN/g"  |oc apply -f -
HOSTROUTE=$(echo "$NSNAME.$HOSTDOMAIN")
echo $HOSTROUTE

sed "s/NSNAME/$NSNAME/g" $BDIR/vs.yml > $BDIR/vstmp.yml
sed "s/SVCNAME/$SVCNAME/g" $BDIR/vstmp.yml > $BDIR/vstmp1.yml
sed "s/SVCPORT/$SVCPORT/g" $BDIR/vstmp1.yml > $BDIR/vstmp2.yml
sed "s|GLP|$GLP|g" $BDIR/vstmp2.yml > $BDIR/vstmp3.yml
sed "s/HOSTROUTE/$HOSTROUTE/g" $BDIR/vstmp3.yml | oc apply -f -

sed "s/NSNAME/$NSNAME/g" $BDIR/ra.yml | sed "s/SVCNAME/$SVCNAME/g" |oc apply -f -
sed "s/NSNAME/$NSNAME/g" $BDIR/ap.yml | sed "s/SVCNAME/$SVCNAME/g" |oc apply -f -
