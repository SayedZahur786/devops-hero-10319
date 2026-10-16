#!/usr/bin/env bash
# Disposable lab only. Never run this on your laptop or a production cluster.
export KUBECONFIG=/etc/kubernetes/admin.conf
if kubectl get ns ingress-nginx >/dev/null 2>&1; then echo "Existing ingress-nginx namespace. Use a fresh lab."; exit 1; fi
(
set -x
kubectl create ns ingress-check
kubectl -n ingress-check create deploy app --image=nginx:1.27-alpine
kubectl -n ingress-check expose deploy app --port=80
kubectl -n ingress-check rollout status deploy/app --timeout=120s
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.2/deploy/static/provider/baremetal/deploy.yaml
kubectl -n ingress-nginx rollout status deploy/ingress-nginx-controller --timeout=180s
kubectl -n ingress-nginx wait --for=condition=complete job/ingress-nginx-admission-create job/ingress-nginx-admission-patch --timeout=120s
cat > /root/rebuild/Sessions/Session12/ingress-verified.yaml <<'YAML'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: verified
spec:
  ingressClassName: nginx
  rules:
  - host: demo.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app
            port:
              number: 80
YAML
kubectl -n ingress-check apply -f /root/rebuild/Sessions/Session12/ingress-verified.yaml
kubectl -n ingress-check get ingress
kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 19080:80 >/root/ingress-pf.txt 2>&1 &
pf=$!
for i in $(seq 1 30); do code=$(curl -s -o /root/ingress-page.html -w '%{http_code}' -H 'Host: demo.local' http://localhost:19080); echo "route status=$code"; [ "$code" = 200 ] && break; sleep 2; done
head -8 /root/ingress-page.html
kubectl -n ingress-check patch svc app -p '{"spec":{"selector":{"app":"wrong"}}}'
sleep 5
kubectl -n ingress-check get endpointslices
curl -s -o /dev/null -w 'Broken route: %{http_code}\n' -H 'Host: demo.local' http://localhost:19080
kubectl -n ingress-check patch svc app -p '{"spec":{"selector":{"app":"app"}}}'
sleep 5
kubectl -n ingress-check get endpointslices
curl -s -o /dev/null -w 'Fixed route: %{http_code}\n' -H 'Host: demo.local' http://localhost:19080
kill "$pf"
kubectl delete ns ingress-check ingress-nginx --timeout=90s
) > /root/rebuild/Sessions/Session12/ingress-verified-output.txt 2>&1
printf INGRESS_REPAIR_DONE
