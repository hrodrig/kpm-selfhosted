# Docker — kpm

Run the published **distroless** image with a mounted kubeconfig, YAML profile, and SQLite store directory.

**Image:** `ghcr.io/hrodrig/kpm:v0.6.0`

The image has **no shell**. Mount config, kubeconfig, and data as files/dirs; pass args after the image name.

## One-shot (single sample)

`sample.interval_seconds: 0` in the profile. Exit `0` on success; `2` on cluster / Metrics / RBAC failure.

```bash
docker run --rm \
  -v "$HOME/.kube/config:/kube/config:ro" \
  -v "$(pwd)/run/examples/kpm-minimal.yml:/config/kpm.yml:ro" \
  -v "$HOME/.local/share/kpm:/data" \
  -e KUBECONFIG=/kube/config \
  -e KPM_SLACK_WEBHOOK \
  ghcr.io/hrodrig/kpm:v0.6.0 \
  sample --config /config/kpm.yml
```

Omit `KPM_SLACK_WEBHOOK` when the profile has no notification sinks.

## Daemon (interval_seconds > 0)

Use a profile with `sample.interval_seconds > 0` (see [kpm-daemon.yml](../examples/kpm-daemon.yml)). Publish the HTTP port only if MCP/server listen is set and you scrape `/healthz` / `/metrics`.

```bash
docker run -d --name kpm \
  -v "$HOME/.kube/config:/kube/config:ro" \
  -v "$(pwd)/run/examples/kpm-daemon.yml:/config/kpm.yml:ro" \
  -v "$HOME/.local/share/kpm:/data" \
  -e KUBECONFIG=/kube/config \
  -e KPM_SLACK_WEBHOOK \
  -e KPM_MCP_TOKEN \
  -p 127.0.0.1:9740:9740 \
  ghcr.io/hrodrig/kpm:v0.6.0 \
  sample --config /config/kpm.yml
```

Prefer binding HTTP to loopback in the profile (`127.0.0.1:9740`); map host ports carefully. Off-loopback binds require a bearer token (`token_env`).

**Stop:** `docker stop kpm && docker rm kpm`

## Notes

- In-cluster: prefer [kubernetes/manifests/](../kubernetes/manifests/) (ServiceAccount + RBAC + PVC) instead of mounting a user kubeconfig.
- Schema and flags: upstream [SPECIFICATIONS.md](https://github.com/hrodrig/kpm/blob/main/SPECIFICATIONS.md).
- Metrics Server must be available in the target cluster for pod metrics.
