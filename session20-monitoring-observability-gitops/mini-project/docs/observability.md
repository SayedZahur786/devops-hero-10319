# Observability - The Three Pillars

Mohd Jahur | Enrollment 10319

## What each pillar means

### 1. Metrics
Numbers measured over time: CPU utilization, memory usage, request rate, error count, latency percentiles. Metrics are cheap to store and fast to query, which makes them the first thing you dashboard and alert on. In Kubernetes they come from metrics-server (kubectl top), node-exporter, kube-state-metrics and the app's own /metrics endpoint, and Prometheus stores and queries them.

### 2. Logs
Timestamped text records of discrete events: an HTTP request, an error stack, a pod restart. Logs answer "what exactly happened, in what order". kubectl logs is the first stop; at scale they are shipped to a central system (Loki, Elasticsearch, CloudWatch) because a pod's logs die with the pod.

### 3. Traces
A trace follows one request through every service it touches, broken into spans with timings. Traces answer "where did the time go" in a distributed system - which service was slow, which call failed. Common tools: Jaeger, Tempo, Zipkin, with OpenTelemetry instrumentation in the app.

## Why observability is required

Monitoring tells you WHEN something is wrong (a known symptom crosses a threshold). Observability lets you ask WHY, including for failures you never predicted. In Kubernetes, pods are short-lived, move between nodes and scale up and down, so you cannot debug by SSHing into "the server". You need metrics to see the fire, logs to read the fire, and traces to find which room it started in.

## Common tools

| Pillar | Tools |
| --- | --- |
| Metrics | Prometheus, Grafana, metrics-server, Datadog |
| Logs | kubectl logs, Loki, ELK/Elasticsearch, Fluentd |
| Traces | Jaeger, Tempo, Zipkin, OpenTelemetry |

## Kubernetes observability

- metrics-server gives live CPU/memory per node and pod (kubectl top).
- Prometheus scrapes node-exporter (node hardware/OS), kube-state-metrics (K8s object state: deployments, pods, restarts) and app /metrics endpoints.
- Grafana dashboards turn those metrics into the standard "Kubernetes cluster" views.
- Alerting rules in Prometheus (PrometheusRule) fire to Alertmanager, which routes to email/Slack/PagerDuty.
- HPA and GitOps controllers consume the same metrics/events, so observability feeds automation too.
