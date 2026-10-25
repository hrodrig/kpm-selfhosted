# Agent Guidelines (kpm-selfhosted)

Context and instructions for AI coding agents working on **kpm-selfhosted** (operator docs and manifests for the **kpm** CLI). See [agents.md](https://agents.md/) for the format.

## Project overview

- **What it is:** Operator-focused **documentation and manifests** for running **[kpm](https://github.com/hrodrig/kpm)** on a bastion, via cron/systemd, Docker, or in-cluster CronJob/Deployment. **No Go application code** in this repository.
- **Upstream application:** **[hrodrig/kpm](https://github.com/hrodrig/kpm)** owns the CLI, **`make release-check`**, tests, packages, and **`ghcr.io/hrodrig/kpm`** images. Config contract: **[SPECIFICATIONS.md](https://github.com/hrodrig/kpm/blob/main/SPECIFICATIONS.md)**.
- **`.cursor/`** is **local-only** (not committed). Shared agent policy belongs in tracked files such as this **AGENTS.md**, **README**, and **CONTRIBUTING.md**.

## Scope (operator vs product)

| **kpm-selfhosted** | **[hrodrig/kpm](https://github.com/hrodrig/kpm)** |
|--------------------|-----------------------------------------------------|
| Operator README, **`run/`** | Go CLI, sample→SQLite, **`make release-check`**, packages |
| Example YAML under **`run/examples/`** | Canonical sample: **`configs/kpm.sample.yml`** |
| In-cluster CronJob / Deployment + PVC + RBAC, Helm chart | Metrics sampling, recommend, capacity, TUI, optional notify/MCP/server |

**Not here:** Docker Compose. Flat manifests stay under **`run/kubernetes/manifests/`**. Helm chart: **`run/kubernetes/helm/kpm/`**.

**Do not** invent YAML keys in examples that the application does not support — when upstream schema changes, update **`run/examples/*.yml`** and README snippets together.

## Two version names

| Name | Meaning |
|------|---------|
| Root **`VERSION`** + README badge + Git tag **`v*`** | Snapshot of **this** repo (docs/examples) |
| **`Chart.yaml` `version:`** | Helm package semver. Bump only when `run/kubernetes/helm/kpm/` changes. May lag repo `VERSION`. |
| **`Chart.yaml` `appVersion`** and **`ghcr.io/hrodrig/kpm:vX.Y.Z`** | **kpm** application image — pin published [kpm releases](https://github.com/hrodrig/kpm/releases) only. Empty `image.tag` uses `appVersion`. |

Do **not** bump this repo’s `VERSION` only to mirror an app tag.

## Checks and make targets

- **`make release-check`** — VERSION semver, README **Version** badge, CHANGELOG section for current VERSION. Script: **`testing/scripts/release-check.sh`**.
- **`make helm-lint`** — `helm lint` and `helm template` for the daemon and the one-shot CronJob shapes. CI: **`.github/workflows/helm-lint.yml`**.

**Application gate:** clone **kpm** and run **`make release-check`** there before tagging an upstream app release.

## Git flow

- **Branches:** Work on **`develop`**. Topic branch → **PR into `develop`**. Release snapshot: **PR `develop` → `main`**, then annotated tag **`v<semver>`** on **`main`**.
- **Never** merge to **`main`**, create/push a release tag, or trigger [**.github/workflows/release.yml**](.github/workflows/release.yml) **without explicit user approval**.
- **Commits:** Show the proposed commit message and wait for user approval before `git commit`.
- **Language:** English only for code, comments, commit messages, docs, and README.

## Version bump (this repo)

| # | Artifact | Action |
|---|----------|--------|
| 1 | **`VERSION`** | New semver without `v` |
| 2 | **`README.md`** | Static **Version** badge `version-<semver>` |
| 3 | **`CHANGELOG.md`** | Move `[Unreleased]` into `## [X.Y.Z] - YYYY-MM-DD` |
| 4 | **Upstream pins** | When documenting a new **kpm** app release: update **`ghcr.io/hrodrig/kpm:v…`** in **`run/`** and **`Chart.yaml` `appVersion`** |
| 5 | **Helm package** | Bump **`Chart.yaml` `version:`** only when `run/kubernetes/helm/kpm/` changed |
| 6 | **Gate** | `make release-check` and `make helm-lint` |
| 7 | **Ship** | Merge `develop` → `main`, annotated tag — **only after user approves** |

## Repository structure

- **`run/docker/`** — `docker run` notes (distroless image; mount kubeconfig + config + store volume).
- **`run/examples/`** — operator YAML samples; must match upstream SPEC.
- **`run/kubernetes/manifests/`** — CronJob (one-shot sample), Deployment (daemon), PVC, Service, RBAC.
- **`run/kubernetes/helm/kpm/`** — Helm chart for the same shapes. `sampler: daemon` (default) or `cronjob`. MCP off unless `mcp.enabled`.
- **`run/standalone/`** — binary + cron/systemd notes (linux, macos, bsd).
- **`testing/scripts/`** — `release-check.sh`, `extract-changelog.sh`.

## Pull request checklist

- Example YAML changes: validate against **[kpm SPECIFICATIONS](https://github.com/hrodrig/kpm/blob/main/SPECIFICATIONS.md)**.
- No real **kubeconfig** contents, tokens, or private cluster URLs in commits.
- Prefer published **`ghcr.io/hrodrig/kpm:v*`** pins — never `:latest` as the only documented default.
- In-cluster shapes need a **persistent store** (PVC) for SQLite history across CronJob runs / pod restarts.

## Supply chain

Prefer reviewing manifests in this clone and image tags from documented upstreams (**GHCR** tags matching **kpm** releases). Avoid `curl | sh` unless the user explicitly accepts the risk.

## Other instructions

- **README:** Keep **Version** badge aligned with **`VERSION`**.
- **CHANGELOG:** Operator-facing changes under `[Unreleased]`; finalize on release.
- See **[CONTRIBUTING.md](CONTRIBUTING.md)** for published scope and release flow.
