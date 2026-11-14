# Host security notes (CVE-2026-98432 / MPTCP)

Operator runbook for Linux hosts and nodes that run **kpm** with an HTTP listen
(`server.enabled` / `mcp.enabled`, `kpm serve`, or a daemon profile that binds
`:9740`).

## Primary fix

**Patch the Linux kernel** on bastions and cluster nodes. CVE-2026-98432 is a
kernel IPv4 TCP use-after-free. App and env mitigations do **not** replace that.

References:

- Go Security Team: [Protecting against CVE-2026-98432](https://groups.google.com/g/golang-announce/c/PCoQcdxoScw)
- [CVE-2026-98432](https://nvd.nist.gov/vuln/detail/CVE-2026-98432)
- Go 1.24+ listen default: [`multipathtcp`](https://go.dev/doc/godebug#go-124) (`=2` on listen)
- Discussion: [go.dev/issue/82717](https://go.dev/issue/82717)

Upstream binary (kpm **v1.2.0+**): module `godebug multipathtcp=0` plus
`SetMultipathTCP(false)` on the shared HTTP listener — see
[kpm README — TCP listeners and MPTCP](https://github.com/hrodrig/kpm/blob/main/README.md#tcp-listeners-and-mptcp).
Pin **`ghcr.io/hrodrig/kpm:v1.2.0`** (or newer) so in-cluster / Docker runs
include that mitigation.

## Why this still matters here

Go 1.24+ enables **Multipath TCP on listen sockets by default**. An MPTCP
listener is the demonstrated exposure path for the CVE: the PoC can hit the
kernel **before** the process accepts the connection.

Long-lived shapes in this repo that listen (daemon Deployment, Helm
`server.listen: 0.0.0.0:9740`, `kpm serve` on a host) create that precondition
on **unpatched** Linux until the node/kernel is fixed.

**Fragile:** one other MPTCP-enabled listener on the same host is enough for
the public PoC path. Disabling MPTCP only inside the kpm process does not
harden the whole machine.

## Prefer loopback when scrapers allow

Standalone / bastion examples should use `server.listen: 127.0.0.1:9740` and
publish through a reverse proxy when needed. Docker examples already map
`127.0.0.1:9740:9740`.

Loopback bind **does not disable MPTCP**. It only reduces who can reach the
socket.

In-cluster charts use `0.0.0.0:9740` behind a ClusterIP Service — keep a
bearer token (`KPM_SERVER_TOKEN`) and patch the **node** kernel.

## Optional belt-and-suspenders: `GODEBUG=multipathtcp=0`

Useful for **older** kpm binaries (before the go.mod / `SetMultipathTCP`
change), or as an extra env while you finish kernel patching. Still incomplete.

After changing env: **restart** the unit / pod / container so the process
picks up `GODEBUG`.

### systemd (standalone)

In the unit or in `/etc/kpm/kpm.env` (mode `0600`):

```ini
Environment=GODEBUG=multipathtcp=0
```

Then:

```bash
sudo systemctl daemon-reload
sudo systemctl restart kpm-sample   # or your unit name
```

### Docker

```bash
docker run ... \
  -e GODEBUG=multipathtcp=0 \
  ghcr.io/hrodrig/kpm:v1.2.0 \
  sample --config /config/kpm.yml
```

This repo does **not** ship Docker Compose.

### Kubernetes (manifests / Helm)

The daemon mounts Secret `kpm-secrets` with `envFrom`. Add a key (optional):

```bash
kubectl -n kpm create secret generic kpm-secrets \
  --from-literal=KPM_SERVER_TOKEN="$(openssl rand -hex 32)" \
  --from-literal=GODEBUG=multipathtcp=0 \
  --dry-run=client -o yaml | kubectl apply -f -
```

Or patch an existing Secret and restart the Deployment / CronJob writer so
pods recreate.

Helm: same Secret name as `secrets.existingSecret` — put `GODEBUG` there; the
chart does not invent a separate env block for it.

## Checklist

- [ ] Kernel patched on hosts/nodes (primary).
- [ ] Image / binary is kpm **v1.2.0+** (or set `GODEBUG` on older builds).
- [ ] Prefer `127.0.0.1` listen on bastions when scrapers allow.
- [ ] Restart after any `GODEBUG` change.
- [ ] Remember: app-only mitigation is fragile if other MPTCP listeners remain.
