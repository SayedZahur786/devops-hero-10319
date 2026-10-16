#!/usr/bin/env bash
export KUBECONFIG=/etc/kubernetes/admin.conf
mkdir -p /root/rebuild/Sessions/Session13
(
set -x
kubectl create ns hpa-recovered
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl -n kube-system patch deploy metrics-server --type=json -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"},{"op":"replace","path":"/spec/template/spec/containers/0/resources/requests/cpu","value":"30m"}]'
kubectl -n kube-system rollout status deploy/metrics-server --timeout=180s
stop=$(($(date +%s)+270)); start=$(($(date +%s)+90))
cat > /root/rebuild/Sessions/Session13/cpu-hpa-verified.yaml <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cpu-demo
spec:
  replicas: 1
  selector:
    matchLabels: {app: cpu-demo}
  template:
    metadata:
      labels: {app: cpu-demo}
    spec:
      containers:
      - name: cpu
        image: busybox:1.36
        command: [sh, -c, 'while [ \$(date +%s) -lt $start ]; do sleep 1; done; while [ \$(date +%s) -lt $stop ]; do :; done; sleep 3600']
        resources:
          requests: {cpu: 30m}
          limits: {cpu: 200m}
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: cpu-demo
spec:
  scaleTargetRef: {apiVersion: apps/v1, kind: Deployment, name: cpu-demo}
  minReplicas: 1
  maxReplicas: 3
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 30
  metrics:
  - type: Resource
    resource:
      name: cpu
      target: {type: Utilization, averageUtilization: 50}
YAML
kubectl -n hpa-recovered apply -f /root/rebuild/Sessions/Session13/cpu-hpa-verified.yaml
kubectl -n hpa-recovered rollout status deploy/cpu-demo --timeout=120s
for i in $(seq 1 35); do date -Is; kubectl -n hpa-recovered get hpa; kubectl -n hpa-recovered get pods -l app=cpu-demo; kubectl -n hpa-recovered top pods -l app=cpu-demo; sleep 15; done
kubectl -n hpa-recovered describe hpa
kubectl delete ns hpa-recovered --timeout=90s
) > /root/rebuild/Sessions/Session13/cpu-hpa-verified-output.txt 2>&1
printf HPA_VERIFIED_DONE
