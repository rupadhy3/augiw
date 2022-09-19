#!/bin/bash
sleep 60
NOW=$(date +%d%m%Y%H%M%S)
mkdir -p /tmp/my-$NOW
BDIR="/tmp/my-$NOW"

cat << EOA > $BDIR/smcp.yml
apiVersion: maistra.io/v2
kind: ServiceMeshControlPlane
metadata:
    name: basic
    namespace: istio-system
spec:
    addons:
      grafana:
        enabled: true
      jaeger:
        install:
          storage:
            type: Memory
      kiali:
        enabled: true
      prometheus:
        enabled: true
    policy:
      type: Istiod
    profiles:
    - default
    proxy:
      accessLogging:
        file:
          name: /dev/stdout
    telemetry:
      type: Istiod
    tracing:
      sampling: 10000
      type: Jaeger
    version: v2.1
EOA

cat << EOB > $BDIR/smmr.yml

apiVersion: maistra.io/v1
kind: ServiceMeshMemberRoll
metadata:
  name: default
  namespace: istio-system
spec:
  members:
EOB

cat << EOC > $BDIR/kustomization.yml
resources:
  - $BDIR/smcp.yml
  - $BDIR/smmr.yml
EOC

oc apply -k $BDIR
