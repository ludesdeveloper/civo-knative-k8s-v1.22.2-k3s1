kubectl apply -f https://github.com/knative/operator/releases/download/knative-v1.2.0/operator.yaml
kubectl config set-context --current --namespace=default
kubectl apply -f knative-serving.yaml
istioctl install -y
kubectl label namespace knative-serving istio-injection=enabled
kubectl apply -f knative-peerAuthentication.yaml
ipaddress=$(kubectl get svc  istio-ingressgateway -n istio-system | awk 'NR==2 {print $4}')
cat <<EOF > config-domain.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-domain
  namespace: knative-serving
data:
  ${ipaddress}.sslip.io: ""
EOF
kubectl apply -f config-domain.yaml
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.2.0/serving-default-domain.yaml

