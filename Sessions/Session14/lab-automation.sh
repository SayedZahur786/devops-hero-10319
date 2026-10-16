#!/usr/bin/env bash
# Disposable pre-provided kubeadm lab only, not your laptop.
set -uo pipefail
mkdir -p /root/rebuild/Sessions/Session14
export KUBECONFIG=/etc/kubernetes/admin.conf
k(){ kubectl -n rebuild "$@"; }
ns(){ kubectl create ns rebuild 2>/dev/null || true; }
clean(){ kubectl delete ns rebuild --wait=true --timeout=90s; ns; }
s14(){ cd /root/rebuild/Sessions/Session14; cp -r /root/course/session-14-kubernetes-troubleshooting/{06-crashloopbackoff,07-imagepullbackoff,08-pending-pods,09-service-dns-troubleshooting,mini-project} .; ns
 for d in 06-crashloopbackoff 07-imagepullbackoff 08-pending-pods; do k apply -f "$d/broken-pod.yaml"; sleep 20; k get pods -o wide; k describe pods; k logs --all-containers --tail=8 $(k get pod -o name | head -1) || true; k delete -f "$d/broken-pod.yaml" --wait=true; k apply -f "$d/fixed-pod.yaml"; k wait --for=condition=Ready pod --all --timeout=120s; k get pods; clean; done
 k create deploy network-demo --image=nginx:1.27-alpine; k expose deploy network-demo --port=80; k rollout status deploy/network-demo --timeout=120s; k patch svc network-demo -p '{"spec":{"selector":{"app":"wrong"}}}'; k get endpointslices; k describe svc network-demo; k patch svc network-demo -p '{"spec":{"selector":{"app":"network-demo"}}}'; k get endpointslices; k exec deploy/network-demo -- nginx -t; k get events --sort-by=.lastTimestamp; k explain pod.spec.containers; k top pods; k logs deploy/network-demo --tail=8; clean
 k apply -f mini-project; sleep 20; k get pods,svc; k describe pods; k get events --sort-by=.lastTimestamp; clean; }
s14
