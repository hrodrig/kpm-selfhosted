# Linux (standalone binary)

← [Back to run/standalone](../README.md) · [run/README](../../README.md).

1. Download a **Linux** tarball from **[kpm Releases](https://github.com/hrodrig/kpm/releases)** (e.g. `kpm_v0.6.0_linux_amd64.tar.gz`).
2. Extract **`kpm`** (and optionally **`kubectl-kpm`**), then `chmod +x kpm`.
3. Copy a profile (e.g. [kpm-minimal.yml](../../examples/kpm-minimal.yml)) and edit `store.path` / optional `scope:`.

## Cron / one-shot (no daemon)

```bash
export KUBECONFIG=/home/kpm/.kube/config
# optional: export KPM_SLACK_WEBHOOK=...
*/5 * * * * /usr/local/bin/kpm sample --config /etc/kpm/kpm.yml >>/var/log/kpm.log 2>&1
```

Profile must use `sample.interval_seconds: 0` (default in kpm-minimal.yml). Point `store.path` at a durable directory (e.g. `/var/lib/kpm/metrics.db`).

## systemd (daemon)

Use a profile with `sample.interval_seconds > 0` ([kpm-daemon.yml](../../examples/kpm-daemon.yml)). Example unit sketch:

```ini
[Unit]
Description=kpm pods metrics sampler
After=network-online.target

[Service]
Type=simple
User=kpm
Group=kpm
Environment=KUBECONFIG=/home/kpm/.kube/config
EnvironmentFile=-/etc/kpm/kpm.env
ExecStart=/usr/local/bin/kpm sample --config /etc/kpm/kpm-daemon.yml
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Put `KPM_SLACK_WEBHOOK=...` and `KPM_MCP_TOKEN=...` in `/etc/kpm/kpm.env` (mode `0600`). Prefer `mcp.listen: 127.0.0.1:9740` unless scrapers need another bind.

Docker path: [run/docker/README.md](../../docker/README.md).
