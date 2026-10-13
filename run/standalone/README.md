# Standalone — kpm binary

Run **kpm** from a [release tarball](https://github.com/hrodrig/kpm/releases) (or `go install` / package) without Docker.

| Platform | Notes |
|----------|--------|
| [linux/](linux/README.md) | cron one-shot + systemd daemon sketch |
| [macos/](macos/README.md) | launchd / cron notes |
| [bsd/](bsd/README.md) | FreeBSD / OpenBSD port skeletons in upstream **kpm** |

**Shapes:**

- **One-shot sample:** `sample.interval_seconds: 0` — suitable for cron.
- **Daemon:** `sample.interval_seconds > 0` — long-lived process; optional MCP/server listen for `/healthz` and `/metrics`.

Starter configs: [../examples/](../examples/README.md). Keep `store.path` on durable disk.
