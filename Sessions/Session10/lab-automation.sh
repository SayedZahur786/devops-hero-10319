#!/usr/bin/env bash
# Disposable pre-provided kubeadm lab only, not your laptop.
set -uo pipefail
mkdir -p /root/rebuild/Sessions/Session10
export KUBECONFIG=/etc/kubernetes/admin.conf
k(){ kubectl -n rebuild "$@"; }
ns(){ kubectl create ns rebuild 2>/dev/null || true; }
clean(){ kubectl delete ns rebuild --wait=true --timeout=90s; ns; }
s10(){ cd /root/rebuild/Sessions/Session10; cp -r /root/course/session10-k8s-core-objects/{01-rolling-update,03-canary,04-recreate,pod-lifecycle} .; cp -r /root/course/session10-k8s-core-objects/*blue* .; ns
 # Lower teaching replica counts to fit 4GB. Canary retains a 3:1 stable/canary ratio.
 sed -i 's/replicas: 4/replicas: 2/g' 01-rolling-update/*.yaml
 sed -i 's/replicas: 9/replicas: 3/g' 03-canary/deployment-stable.yaml
 for f in 01-rolling-update/deployment-v1.yaml 01-rolling-update/service.yaml; do k apply -f "$f"; done
 k rollout status deploy/app-rolling --timeout=120s; k get pods -o wide; k apply -f 01-rolling-update/deployment-v2.yaml; k rollout status deploy/app-rolling --timeout=120s; k get rs,pods; k delete -f 01-rolling-update/deployment-v2.yaml -f 01-rolling-update/service.yaml
 for f in *blue*/*.yaml; do k apply -f "$f"; done; k get deploy,svc; sleep 15; k get pods -o wide
 blue=$(k get svc -o name | head -1); k patch "$blue" -p '{"spec":{"selector":{"version":"green"}}}'; k get "$blue" -o yaml; clean
 k apply -f 03-canary; k rollout status deploy/app-stable --timeout=120s || true; k get pods,svc; sleep 15; k get endpointslices; clean
 k apply -f 04-recreate/deployment-v1.yaml; k rollout status deploy/app-recreate --timeout=120s; k apply -f 04-recreate/deployment-v2.yaml; k get pods; k rollout status deploy/app-recreate --timeout=120s; k get rs,pods; clean
 for f in pod-lifecycle/*.yaml; do k apply -f "$f"; done; sleep 25; k get pods -o wide; for p in $(k get pods -o name); do k describe "$p"; k logs "$p" --all-containers --tail=8 || true; done; clean
 }
s10
