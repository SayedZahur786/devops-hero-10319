#!/usr/bin/env bash
# Disposable lab only. Never run this on your laptop or a production cluster.
unset KUBECONFIG
mkdir -p /root/rebuild/Sessions/Session9
cp /root/rebuild/Sessions/Session9/output.txt /root/rebuild/Sessions/Session9/output-first-attempt.txt
(
set -x
/tmp/minikube start --driver=docker --cpus=1 --memory=2048 --force --extra-config=kubeadm.ignore-preflight-errors=NumCPU
/tmp/minikube update-context
/tmp/minikube status
/tmp/minikube kubectl -- get nodes -o wide
/tmp/minikube kubectl -- cluster-info
/tmp/minikube kubectl -- create deployment bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
/tmp/minikube kubectl -- rollout status deployment/bootcamp --timeout=180s
/tmp/minikube kubectl -- expose deployment bootcamp --type=NodePort --port=8080
/tmp/minikube kubectl -- get pods,deploy,svc -o wide
/tmp/minikube kubectl -- exec deploy/bootcamp -- curl -s localhost:8080
/tmp/minikube kubectl -- scale deploy bootcamp --replicas=2
/tmp/minikube kubectl -- rollout status deploy/bootcamp --timeout=120s
/tmp/minikube kubectl -- set image deploy/bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2
/tmp/minikube kubectl -- rollout status deploy/bootcamp --timeout=180s
/tmp/minikube kubectl -- exec deploy/bootcamp -- curl -s localhost:8080
/tmp/minikube kubectl -- rollout undo deploy/bootcamp
/tmp/minikube kubectl -- rollout status deploy/bootcamp --timeout=180s
/tmp/minikube kubectl -- get deploy bootcamp -o jsonpath='{.spec.template.spec.containers[*].image}'
/tmp/minikube kubectl -- exec deploy/bootcamp -- curl -s localhost:8080
/tmp/minikube kubectl -- delete deployment,svc bootcamp
/tmp/minikube stop
) > /root/rebuild/Sessions/Session9/minikube-verified-output.txt 2>&1
printf MINIKUBE_VERIFIED_DONE
