# run/ — operator deployment index

This tree holds **how to run kpm**, not the CLI source. Product docs: [kpm](https://github.com/hrodrig/kpm).

**Image pin (default in manifests):** `ghcr.io/hrodrig/kpm:v1.1.0`

| Directory | Purpose |
|-----------|---------|
| [docker/](docker/README.md) | Run the published image on a bastion with kubeconfig + config + store mount |
| [kubernetes/](kubernetes/README.md) | Flat manifests or Helm chart `kubernetes/helm/kpm` |
| [standalone/](standalone/README.md) | **cron** and **systemd** using the Releases binary |
| [examples/](examples/README.md) | Minimal operator profiles |

## Pick a path

| You have… | Start here |
|-----------|------------|
| kubeconfig on a laptop / bastion | [docker/README.md](docker/README.md) |
| Kubernetes, scheduled one-shot sample | [kubernetes/manifests/cronjob.yaml](kubernetes/manifests/cronjob.yaml) |
| Kubernetes, long-running daemon | [kubernetes/manifests/deployment.yaml](kubernetes/manifests/deployment.yaml) plus [recommend-cronjob.yaml](kubernetes/manifests/recommend-cronjob.yaml), or [Helm](kubernetes/helm/kpm/README.md) |
| Kubernetes, Helm | [kubernetes/helm/kpm](kubernetes/helm/kpm/README.md) (`secrets.existingSecret` required for the daemon) |
| Linux host + cron only | [standalone/README.md](standalone/README.md) |
| Need a starter config | [examples/](examples/README.md) |

## Related upstream docs

- [SPECIFICATIONS.md](https://github.com/hrodrig/kpm/blob/main/SPECIFICATIONS.md) — behavior contract
- [configs/kpm.sample.yml](https://github.com/hrodrig/kpm/blob/main/configs/kpm.sample.yml) — all config keys
- [kpm README — Install](https://github.com/hrodrig/kpm/blob/main/README.md#install) — deb, rpm, tarball, `go install`
