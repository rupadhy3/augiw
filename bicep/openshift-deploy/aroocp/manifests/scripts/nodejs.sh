#!/bin/bash

oc import-image ubi8/nodejs-16 -n openshift --from=registry.access.redhat.com/ubi8/nodejs-16:1-37 --confirm 
oc get is nodejs-16 -n openshift -oyaml > nodejs1.yml
sed 's/- annotations: null/- annotations:/' nodejs1.yml > nodejs.yml
sed '/- annotations:/ r nodejs.txt' nodejs.yml | oc apply -f -  


