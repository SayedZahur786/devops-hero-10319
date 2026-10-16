# Session 13: Storage and CPU HPA

Mohd Jahur | Enrollment 10319

## Work and observations

1. This is a separate bounded CPU HPA demonstration, not the course HTTP traffic exercise. See the actual HPA samples before treating scaling as verified.
2. The lab configuration uses 30m CPU requests, a 200m limit, maximum 3 replicas, and a 30-second scale-down stabilization window. Metrics-server uses an insecure kubelet TLS flag only for this disposable lab. The course traffic generator and mini-project are not done.

## Evidence

Fresh run on 9 October 2026 in a separate disposable lab. These are rendered views of actual captured command output, not live terminal screenshots. Raw logs are included so the text can be checked.

<!-- EVIDENCE -->

## References

- https://kubernetes.io/docs/concepts/storage/volumes/

The first attempt changed desired HPA replicas 1 -> 3 -> 1, but two new Pods stayed Pending under disk pressure. This is autoscaler-decision evidence, not proof that three workload Pods ran. A recovered-run log, if present, must separately show all three Running.

Sources: https://kubernetes.io/docs/concepts/workloads/autoscaling/horizontal-pod-autoscale/

![Actual browser capture of three Running HPA Pods](hpa-scale-up-live.png)

This image is an actual browser terminal capture of scale-up. Other terminal-window images in the package are rendered from raw logs.

## Verified recovered result
The recovered run shows HPA and Running workload Pods scaling 1 -> 3 -> 1. cpu-hpa-verified-output.txt records the samples. The earlier disk-pressure-attempt.txt is a separate failed workload attempt, not the proof used for this result. All replicas share a common epoch cutoff for CPU work, so the load really ends across the whole Deployment.

![Actual browser capture after HPA scale-down](hpa-scale-down-live.png)

## Captured output files

- [cpu-hpa-verified-output.txt](cpu-hpa-verified-output.txt)
- [disk-pressure-attempt.txt](disk-pressure-attempt.txt)
- [output.txt](output.txt)

![Output of the command, captured from the lab run](images/cpu-hpa-verified-output-01.png)

![Output of the command, captured from the lab run](images/cpu-hpa-verified-output-02.png)

![Output of the command, captured from the lab run](images/cpu-hpa-verified-output-03.png)
