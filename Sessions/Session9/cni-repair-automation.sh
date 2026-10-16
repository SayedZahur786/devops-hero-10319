#!/usr/bin/env bash
unset KUBECONFIG
(
set -x
# Minikube's default CNI did not initialize after restarting the nested Docker VM.
/tmp/minikube kubectl -- get ds -n kube-system
/tmp/minikube kubectl -- get node minikube -o jsonpath='{.status.conditions}'
/tmp/minikube kubectl -- apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
/tmp/minikube kubectl -- set env ds/kube-flannel-ds -n kube-flannel KUBERNETES_SERVICE_HOST=192.168.49.2 KUBERNETES_SERVICE_PORT=8443
/tmp/minikube kubectl -- set env deploy/coredns -n kube-system KUBERNETES_SERVICE_HOST=192.168.49.2 KUBERNETES_SERVICE_PORT=8443
/tmp/minikube kubectl -- rollout status ds/kube-flannel-ds -n kube-flannel --timeout=180s
/tmp/minikube kubectl -- wait --for=condition=Ready node/minikube --timeout=180s
/tmp/minikube kubectl -- get nodes
/tmp/minikube kubectl -- rollout status deploy/bootcamp --timeout=180s
/tmp/minikube kubectl -- expose deploy bootcamp --type=NodePort --port=8080
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
) > /root/rebuild/Sessions/Session9/minikube-cni-recovered-output.txt 2>&1
printf MINIKUBE_CNI_DONE
