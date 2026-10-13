# Kubernetes — kpm

Flat manifests under **[manifests/](manifests/)**. No Helm chart in v0.1.0.

**Image pin:** `ghcr.io/hrodrig/kpm:v0.6.0`

Requires **metrics-server** (or equivalent Metrics API) in the cluster.

## Apply order

```bash
kubectl apply -f manifests/namespace.yaml
kubectl apply -f manifests/rbac.yaml
kubectl apply -f manifests/pvc.yaml
kubectl apply -f manifests/configmap.yaml
# Create Secret from secret.example.yaml (edit values first) — do not commit real secrets
# kubectl apply -f manifests/secret.yaml   # after copying from secret.example.yaml
```

Then choose **one** shape:

| Shape | Manifest | Profile |
|-------|----------|---------|
| Scheduled one-shot sample | [manifests/cronjob.yaml](manifests/cronjob.yaml) | `sample.interval_seconds: 0` in ConfigMap |
| Long-running daemon | [manifests/deployment.yaml](manifests/deployment.yaml) (+ Service) | `interval_seconds > 0` + MCP/server listen |

Edit ConfigMap data to match your scope. RBAC is **read-only** (pods, metrics, owner resolution). The **PVC** holds SQLite history — required for recommend windows across CronJob runs.

## Secrets

Copy [manifests/secret.example.yaml](manifests/secret.example.yaml), set notification / MCP env vars, apply as `kpm-secrets` in namespace `kpm`. Omit the Secret and notification sinks if unused.
