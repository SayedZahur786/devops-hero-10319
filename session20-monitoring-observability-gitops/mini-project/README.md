# Session 20 Mini-Project: Monitoring, Observability and GitOps

Mohd Jahur | Enrollment 10319

## Work and observations

All of this ran on a real Kubernetes cluster (Killercoda kubeadm playground, 2 nodes, v1.37.1):

**Prometheus + Alertmanager (Helm):**
- Installed the `prometheus-community/prometheus` stack: server, alertmanager, kube-state-metrics, node-exporter, pushgateway - all pods Running.
- Ran real PromQL queries through the HTTP API (`up`, node memory metrics, `kube_pod_info` - raw JSON captured).
- Created a PrometheusRule `HighNodeMemoryUsage`; captured it first as `pending` and later as `firing` (see end of the evidence log).

**Grafana (Helm):**
- Installed Grafana, port-forwarded it, logged in, and imported dashboard **1860 (Node Exporter Full)** via the UI (the chart's gnetId auto-import did not take effect, so I imported it manually).
- `images/grafana-node-exporter-dashboard.png` is a real screenshot of the imported dashboard showing live node data (RAM ~93%, uptime 1.3 hours).

**ArgoCD (GitOps):**
- Installed Argo CD; all pods Running.
- Created a `guestbook` Application pointing at the Argo CD example repo - reached `Synced / Healthy`.
- **Self-heal test:** scaled `guestbook-ui` to 0 outside Git; Argo CD detected drift and reverted it back to 1/1 Running (captured in the log).
- Note: the ArgoCD UI was reachable only through kubectl port-forward on the ephemeral lab, so UI screenshots were not kept; the CLI status output is captured in full. One upstream CRD (`applicationsets.argoproj.io`) failed to apply ("annotations: Too long") - it does not affect the guestbook demo.

## Evidence

- `evidence/s20-full.log` - complete captured output: installs, pod status, API query results, alerts (pending then firing), guestbook sync and the self-heal revert.
- `images/grafana-node-exporter-dashboard.png` - real Grafana dashboard screenshot.
- `images/argocd-selfheal.png` - rendered from the real captured Argo CD status output.
- `docs/observability.md`, `docs/gitops.md` - written notes on the three pillars and on GitOps principles.
