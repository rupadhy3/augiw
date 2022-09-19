env=$1
developer=$2
instancenum=$3
clusterurl=$4
clustertoken=$5

cat << EOF > /tmp/ns.yaml
apiVersion: v1
kind: Namespace
metadata:
  labels:
    kubernetes.io/metadata.name: iwocp${env}${developer}${instancenum}
  name: iwocp${env}${developer}${instancenum}
EOF

### here we need to add code to login to the cluster
### oc login --token $clustertoken --server $clusterurl
### oc project default
### if [ $? != 0 ]; then echo "ERROR: Please check if you are logged int o your cluster"; fi 

env=sit;developer=nrj;instancenum=001;sed "s/ENVMNT/$env/g" /tmp/ns.yaml |sed "s/DEVELOPER/$developer/g" |sed "s/INSTNUM/$instancenum/g" |oc apply -f -
