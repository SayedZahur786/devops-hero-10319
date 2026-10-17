# Session 13 Mini-Project: Storage, HPA and Probes

Mohd Jahur | Enrollment 10319

## Work and observations

I ran the full lab on a real Kubernetes cluster (Killercoda kubeadm playground, 2 nodes, Kubernetes v1.37.1):

1. **Volumes** - created an `emptyDir` volume and a `hostPath` volume and verified both from inside the pod.
2. **Static PV + PVC** - wrote a PersistentVolume manifest, bound a PersistentVolumeClaim to it, mounted it in a pod and wrote data.
3. **Dynamic provisioning** - used the `local-path` StorageClass (the cluster default) so the PVC was bound automatically (`web-data`, 500Mi, RWO).
4. **Mini-project** - deployed the course web app to the `production-webapp` namespace with the PVC mounted, liveness/readiness probes, and an HPA (min 2, max 5, 50% CPU).
5. **Persistence test** - wrote `Student: Mohd Jahur, Enrollment 10319` into the mounted volume, deleted the pod, and read the same data back from the new pod. PERSISTENCE CONFIRMED.
6. **HPA load test** - drove real CPU load with `bombardier` (500 connections, 4 minutes) against the Service ClusterIP. The HPA scaled the deployment from 2 to 5 replicas at 74%/50% CPU; `SuccessfulRescale` events show New size: 4 then New size: 5.

Notes: `metrics-server` needed the `--kubelet-insecure-tls` patch on this playground. The busybox wget load loop only reached ~28m CPU per pod, which is why I used bombardier for the real scale-out.

## Evidence

- `evidence/s13-evidence-full.log` - complete captured terminal output of every step above.
- `images/hpa-scaleout.png` - rendered from the real captured `kubectl get hpa` / `kubectl top pods` / `kubectl describe hpa` output (not a screenshot mockup).

## Captured output files

| File | Contents |
|------|----------|
| `evidence/s13-evidence-full.log` | Full lab log: volumes, PV/PVC, StorageClass, deploy, persistence test, probes, HPA scale-out |
| `images/hpa-scaleout.png` | HPA at 74%/50% with 5 replicas + SuccessfulRescale events |
