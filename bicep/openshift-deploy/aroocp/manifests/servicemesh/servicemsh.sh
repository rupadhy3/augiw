#!/bin/bash
NOW=$(date +%d%m%Y%H%M%S)
mkdir -p /tmp/my-$NOW
BDIR="/tmp/my-$NOW"

cat << EOA > $BDIR/my-es-ns.yml
apiVersion: v1
kind: Namespace
metadata:
  name: openshift-operators-redhat
EOA

cat << EOB > $BDIR/my-es-operator-group.yml
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: openshift-operators-redhat-global-og
  namespace: openshift-operators-redhat
spec: {}
EOB

cat << EOC > $BDIR/my-es-sub.yml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  labels:
    operators.coreos.com/elasticsearch-operator.openshift-operators-redhat: ""
  name: elasticsearch-operator
  namespace: openshift-operators-redhat
spec:
  channel: stable
  installPlanApproval: Automatic
  name: elasticsearch-operator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOC

cat << EOD > $BDIR/my-istio-namespace.yml
apiVersion: v1
kind: Namespace
metadata:
  name: istio-system
EOD

cat << EOE > $BDIR/my-ja.yml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  labels:
    operators.coreos.com/jaeger-product.openshift-operators: ""
  name: jaeger-product
  namespace: openshift-operators
spec:
  channel: stable
  installPlanApproval: Automatic
  name: jaeger-product
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOE

cat << EOF > $BDIR/my-kai.yml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  generation: 1
  labels:
    operators.coreos.com/kiali-ossm.openshift-operators: ""
  name: kiali-ossm
  namespace: openshift-operators
spec:
  channel: stable
  installPlanApproval: Automatic
  name: kiali-ossm
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOF

cat << EOG > $BDIR/my-sm.yml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  labels:
    operators.coreos.com/servicemeshoperator.openshift-operators: ""
  name: servicemeshoperator
  namespace: openshift-operators
spec:
  channel: stable
  installPlanApproval: Automatic
  name: servicemeshoperator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOG

cat << EOZ > $BDIR/kustomization.yml
resources:
  - $BDIR/my-es-ns.yml
  - $BDIR/my-es-operator-group.yml
  - $BDIR/my-es-sub.yml
  - $BDIR/my-istio-namespace.yml
  - $BDIR/my-ja.yml
  - $BDIR/my-kai.yml
  - $BDIR/my-sm.yml
EOZ

oc apply -k $BDIR
