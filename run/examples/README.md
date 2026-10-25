# Example profiles

Operator starters for **kpm**. Canonical schema: [configs/kpm.sample.yml](https://github.com/hrodrig/kpm/blob/main/configs/kpm.sample.yml) and [SPECIFICATIONS.md](https://github.com/hrodrig/kpm/blob/main/SPECIFICATIONS.md).

| File | Shape |
|------|--------|
| [kpm-minimal.yml](kpm-minimal.yml) | One-shot sample (`sample.interval_seconds: 0`) |
| [kpm-daemon.yml](kpm-daemon.yml) | Daemon (`interval_seconds > 0`) + charts/`/api/v1` on `:9740`. MCP is commented out |

Edit `store.path`, `cluster:`, and optional `scope:` for your environment. Do not commit real webhook URLs or bearer tokens — use `KPM_SLACK_WEBHOOK` and `KPM_SERVER_TOKEN` in the environment or a Kubernetes Secret. Add `KPM_MCP_TOKEN` only after uncommenting `mcp.enabled`.
