#!/usr/bin/env bash
# Disposable pre-provided kubeadm lab only, not your laptop.
set -uo pipefail
mkdir -p /root/rebuild/Sessions/Session11
export KUBECONFIG=/etc/kubernetes/admin.conf
k(){ kubectl -n rebuild "$@"; }
ns(){ kubectl create ns rebuild 2>/dev/null || true; }
clean(){ kubectl delete ns rebuild --wait=true --timeout=90s; ns; }
s11(){ cd /root/rebuild/Sessions/Session11; ns; k create deploy web --image=nginx:1.27-alpine; k rollout status deploy/web --timeout=120s
 for type in ClusterIP NodePort LoadBalancer; do k expose deploy web --name=web-${type,,} --port=80 --type=$type; done
 k create service externalname external --external-name=example.com
 k expose deploy web --name=headless --port=80 --cluster-ip=None
 k get svc -o wide; k get endpointslices
 k run client --image=busybox:1.36 --restart=Never --command -- sleep 300; k wait --for=condition=Ready pod/client --timeout=120s
 k exec client -- wget -qO- http://web-clusterip | head -8
 k exec client -- nslookup web-clusterip.rebuild.svc.cluster.local
 k exec client -- nslookup headless.rebuild.svc.cluster.local
 k exec client -- nslookup external.rebuild.svc.cluster.local
 k get services -o yaml > services.yaml; clean; }
s11
