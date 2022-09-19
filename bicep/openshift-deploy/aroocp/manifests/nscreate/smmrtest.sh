oc -n istio-system get smmr default -o yaml > /tmp/smmr1.yaml
sed -n '1,/^status/p' /tmp/smmr1.yaml |sed '/^status/d' > /tmp/smmr.yaml
echo "============================================"
cat /tmp/smmr.yaml 
read a 
echo "============================================"
cat /tmp/smmr.yaml|grep -w 'members:' >/dev/null

if [ $? != 0 ]; then
  sed "s/spec: .*/spec: /" /tmp/smmr.yaml > /tmp/smmr1.yaml
  sed "/spec: /a \ \ members:" /tmp/smmr1.yaml > /tmp/smmr.yaml
fi
cat /tmp/smmr.yaml 
