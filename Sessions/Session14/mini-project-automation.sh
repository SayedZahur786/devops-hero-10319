#!/usr/bin/env bash
export KUBECONFIG=/etc/kubernetes/admin.conf
(
set -x
kubectl create ns mini-verify
kubectl -n mini-verify apply -f /root/course/session-14-kubernetes-troubleshooting/mini-project
sleep 15
kubectl -n mini-verify get pods,svc
kubectl -n mini-verify describe pod project-broken-pod
kubectl -n mini-verify set image pod/project-broken-pod app=nginx:1.27-alpine
kubectl -n mini-verify wait --for=condition=Ready pod/project-broken-pod --timeout=120s
kubectl -n mini-verify rollout status deploy/troubleshooting-app --timeout=120s
kubectl -n mini-verify get pods,svc,endpointslices
kubectl -n mini-verify exec deploy/troubleshooting-app -- curl -sf http://troubleshooting-service
kubectl -n mini-verify top pods
kubectl -n mini-verify exec deploy/troubleshooting-app -- cat /etc/resolv.conf
kubectl delete ns mini-verify --wait=false
) > /root/rebuild/Sessions/Session14/mini-project-fixed-output.txt 2>&1
printf MINI_DONE
