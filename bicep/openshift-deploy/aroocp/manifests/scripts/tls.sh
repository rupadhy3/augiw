#!/bin/bash
TLS_NAME=`oc get secret -n openshift-ingress | grep tls | grep -v router | cut -d " " -f1`
oc extract secret/${TLS_NAME} -n openshift-ingress --to=/tmp/
oc create secret tls iwtls-secret -n istio-system --key /tmp/tls.key --cert /tmp/tls.crt
