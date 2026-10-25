# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Private-registry how-to [run/kubernetes/private-registry.md](run/kubernetes/private-registry.md) and `mirror-kpm-image.sh`. A host with egress copies the chart and the images; the locked cluster installs from that registry. The script pushes the upstream tag and `sha256-<hex>`.

## [0.2.0] - 2026-10-25

### Added

- Helm chart `run/kubernetes/helm/kpm` (package `0.1.0`, `appVersion` `v1.1.0`). Daemon is the default. MCP stays off. The recommend CronJob execs into the daemon pod and does not mount the PVC. `affinity` schedules the sampler pod and the recommend Job. Daemon container resources are the top-level `resources` object. Pods run as distroless nonroot (65532) with a read-only root filesystem, dropped capabilities, and RuntimeDefault seccomp. `imagePullSecrets` is optional. Liveness probe is `/livez` (readiness stays `/readyz`), matching kpm v1.1.0. `secrets.existingSecret` is documented with create examples in the chart README, values, and install notes.
- Chart publish workflow `.github/workflows/release-charts.yml`. A `v*` tag runs chart-releaser (`charts_dir` `run/kubernetes/helm`) and publishes GitHub Release `kpm-<chartVersion>` plus the `gh-pages` index. That release is separate from the docs Release created by `release.yml`.
- macOS notes point at `brew install --cask hrodrig/kpm/kpm`. The tap is written by the kpm release.
- Daemon profile enables the charts UI and `GET /api/v1` (`server.enabled`, bearer `KPM_SERVER_TOKEN`). MCP stays commented out.
- CronJob `kpm-recommend` runs `kpm recommend --record` with `kubectl exec` into the daemon pod. The Job does not mount the RWO store. ServiceAccount `kpm-recommend` is namespace-local (`pods` get/list, `pods/exec`, `deployments` get).
- README hero: `assets/kpm-selfhosted-hero.jpg` (same family artwork as upstream `kpm` OSS hero).

### Changed

- Application image pin `ghcr.io/hrodrig/kpm:v1.1.0` in `run/` docs and manifests.
- README product captures (`assets/kpm-serve-analyze-local-dark.png`,
  `assets/kpm-tui-cpu-request-13pods.png`, `assets/kpm-flow-diagram.png`) plus link to the
  [DEV.to walkthrough](https://dev.to/hrodrig/kpm-kubernetes-rightsizing-without-prometheus-history-on-your-laptop-4272).

## [0.1.0] - 2026-10-13

### Added

- Bootstrap operator repository: Docker notes, Kubernetes manifests (CronJob + Deployment + PVC + RBAC), standalone linux/macos/bsd paths, and example YAML profiles.
- Docs gate: `make release-check` (VERSION, README badge, CHANGELOG) with CI on pull requests and pushes to `develop` / `main`.
- Default application image pin: `ghcr.io/hrodrig/kpm:v0.6.0`.
- README aligned with the hrodrig selfhosted family (TOC, pick-a-path sections, layout, community policies/standards, gghstats clones badge).

[Unreleased]: https://github.com/hrodrig/kpm-selfhosted/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/hrodrig/kpm-selfhosted/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/hrodrig/kpm-selfhosted/releases/tag/v0.1.0
