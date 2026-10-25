# kpm

In-cluster sampler. One RWO volume, one writer. Default shape is the daemon
(`server.enabled`, MCP off).

| Field | Meaning |
|-------|---------|
| `version` | This chart package |
| `appVersion` | kpm image tag when `image.tag` is empty |

## Secret the chart does not create

`secrets.existingSecret` is the **name** of a Secret already in the release
namespace. The chart never creates it and never reads the token into a values
file. The daemon mounts that Secret with `envFrom`.

Required when `sampler` is `daemon` and `server.enabled` or `mcp.enabled` is
true. `helm install` fails closed if the name is empty. The one-shot
`sampler=cronjob` shape does not serve HTTP, so the Secret is optional there.

Create it before install. Do not commit the token.

```bash
kubectl -n kpm create secret generic kpm-secrets \
  --from-literal=KPM_SERVER_TOKEN="$(openssl rand -hex 32)"
```

`KPM_SERVER_TOKEN` is the charts and `/api/v1` bearer. The listen is
`0.0.0.0`, so the process refuses to start when that env var is missing.

```yaml
secrets:
  existingSecret: kpm-secrets
```

```bash
helm install kpm . \
  --namespace kpm --create-namespace \
  --set secrets.existingSecret=kpm-secrets
```

The same flag works from a checkout of this repo:

```bash
helm install kpm run/kubernetes/helm/kpm \
  --namespace kpm --create-namespace \
  --set secrets.existingSecret=kpm-secrets
```

### MCP

Off by default. Turn it on only together with a second key in the same Secret:

```bash
kubectl -n kpm create secret generic kpm-secrets \
  --from-literal=KPM_SERVER_TOKEN="$(openssl rand -hex 32)" \
  --from-literal=KPM_MCP_TOKEN="$(openssl rand -hex 32)"
```

```yaml
mcp:
  enabled: true
secrets:
  existingSecret: kpm-secrets
```

### v1.0.0 liveness path

The chart probes `/livez`. Image `v1.0.0` still serves `/healthz`. Until a
published image serves `/livez`:

```yaml
probes:
  livenessPath: /healthz
```

## One writer

Do not install this chart and `run/kubernetes/manifests/` against the same PVC.
The recommend CronJob execs into the daemon pod and does not mount the disk.
