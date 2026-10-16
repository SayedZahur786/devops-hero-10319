#!/usr/bin/env bash
# Disposable lab only. Never run this on your laptop or a production cluster.
export KUBECONFIG=/etc/kubernetes/admin.conf
mkdir -p /root/rebuild/Sessions/Session15
(
set -x
cd /root/rebuild/Sessions/Session15
kubectl create ns helm-verify
curl -fsSL https://get.helm.sh/helm-v3.19.0-linux-amd64.tar.gz | tar xz
cp linux-amd64/helm /usr/local/bin/helm; rm -rf linux-amd64
helm version
helm create practice-chart
helm lint practice-chart
helm template practice practice-chart > rendered.yaml
cp -r /root/course/session-15-helm/mini-project/notes-chart .
helm install notes notes-chart -n helm-verify
kubectl -n helm-verify rollout status deploy/notes-deploy --timeout=120s
helm list -n helm-verify
helm status notes -n helm-verify
helm get values notes -n helm-verify
helm get manifest notes -n helm-verify
helm upgrade notes notes-chart -n helm-verify --set image.tag=1.25 --set replicaCount=2
kubectl -n helm-verify rollout status deploy/notes-deploy --timeout=120s
helm upgrade notes notes-chart -n helm-verify --set image.tag=1.26 --set replicaCount=1
kubectl -n helm-verify rollout status deploy/notes-deploy --timeout=120s
helm history notes -n helm-verify
helm rollback notes 1 -n helm-verify
kubectl -n helm-verify rollout status deploy/notes-deploy --timeout=120s
kubectl -n helm-verify get pods -o wide
kubectl -n helm-verify get deploy notes-deploy -o jsonpath='{.spec.template.spec.containers[*].image}'
helm history notes -n helm-verify
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm search repo bitnami/nginx | head
helm uninstall notes -n helm-verify
kubectl delete ns helm-verify --wait=false
) > /root/rebuild/Sessions/Session15/helm-verified-output.txt 2>&1
printf HELM_VERIFIED_DONE
