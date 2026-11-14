# Standalone — kpm binary

Run **kpm** from a [release tarball](https://github.com/hrodrig/kpm/releases) (or `go install` / package) without Docker.

| Platform | Notes |
|----------|--------|
| [linux/](linux/README.md) | cron one-shot + systemd daemon sketch |
| [macos/](macos/README.md) | launchd / cron notes |
| [bsd/](bsd/README.md) | FreeBSD / OpenBSD port skeletons in upstream **kpm** |

**Shapes:**

- **One-shot sample:** `sample.interval_seconds: 0` — suitable for cron.
- **Daemon:** `sample.interval_seconds > 0` — long-lived process; optional MCP/server listen for `/livez` and `/metrics`.

Starter configs: [../examples/](../examples/README.md). Keep `store.path` on durable disk.

**Laptop / offline analyze:** use **`kpm backup`** (not a hot copy of the live
`.db`) before taking history home — see the root README
[Take the store home](../../README.md#take-the-store-home) and upstream
[take-home-store.md](https://github.com/hrodrig/kpm/blob/develop/docs/take-home-store.md).
