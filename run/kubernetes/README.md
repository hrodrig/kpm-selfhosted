# Kubernetes — kpm

Flat manifests under **[manifests/](manifests/)**. Helm chart: **[helm/kpm](helm/kpm)** (`sampler: daemon` by default, MCP off). The chart does not create the bearer Secret. Name it with `secrets.existingSecret`. Examples: [helm/kpm/README.md](helm/kpm/README.md).

**Image pin:** `ghcr.io/hrodrig/kpm:v1.0.0`

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

Then choose **one** sampler. Both mount the same ReadWriteOnce PVC; a second pod stays Pending.

| Shape | Manifest | Profile |
|-------|----------|---------|
| Scheduled one-shot sample | [manifests/cronjob.yaml](manifests/cronjob.yaml) | `sample.interval_seconds: 0` in ConfigMap |
| Long-running daemon | [manifests/deployment.yaml](manifests/deployment.yaml) (+ Service) | `interval_seconds > 0` + `server.enabled`. MCP off |

With the daemon, also apply [manifests/recommend-cronjob.yaml](manifests/recommend-cronjob.yaml). That CronJob does not mount the PVC.

Edit ConfigMap data to match your scope. The sampler RBAC is **read-only** (pods, metrics, owner resolution). The **PVC** holds SQLite history.

## Bastion powered off

When the admin bastion is off nights and weekends, sample from the daemon inside the cluster. One process owns the SQLite file. `client.id` in the daemon profile stays a fixed name (`kpm-daemon`), not the bastion hostname.

`server.enabled` serves the charts page (`GET /`, `GET /ui`) and `GET /api/v1/*` on port 9740. The `mcp:` block stays commented out. Uncomment it and set `KPM_MCP_TOKEN` to turn MCP on. The charts listen does not depend on MCP. The Service is ClusterIP. A product UI includes the charts with an iframe whose `src` is that origin (`https://kpm.example/ui`). Styles and the API are rooted at `/static/` and `/api/v1/`, so a subpath on another host does not resolve them. The HTML is public. The page asks for the bearer and keeps it in `sessionStorage`. Give that page to operators. A sentence for an end user comes from your backend calling `GET /api/v1/recommendations` with `KPM_SERVER_TOKEN` held server-side.

`kpm sample` does not write the `recommendations` table. `kpm recommend --record` does. The recommend CronJob runs every day, including weekends (`0 6 * * *`, controller timezone, usually UTC). It `kubectl exec`s into `deploy/kpm` because the disk is already mounted there. ServiceAccount `kpm-recommend` is a namespace Role: `pods` get/list, `pods/exec` create, and `deployments` get (so `kubectl exec deploy/kpm` can resolve the pod). That exec right is strong; keep the account in namespace `kpm` and do not reuse the sampler account.

Until some workload reaches `recommend.min_samples` (24 at a 300s interval is about two hours), `recommend` exits **3** and the Job is Failed. After that it writes the snapshot the API and the charts read. The sampler holds the database; the second process waits up to 5s (`busy_timeout`). `concurrencyPolicy: Forbid` keeps two execs from stacking. `kubectl` in the Job is `registry.k8s.io/kubectl:v1.33.13` — set the tag to your cluster minor (client/server skew ±1).

## Secrets

Copy [manifests/secret.example.yaml](manifests/secret.example.yaml), set notification and server env vars, apply as `kpm-secrets` in namespace `kpm`. The daemon fail-closes if `KPM_SERVER_TOKEN` is missing while `server.listen` is `0.0.0.0`. Omit the Secret and notification sinks if unused. Add `KPM_MCP_TOKEN` only when `mcp.enabled` is true.
