# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Helm chart `run/kubernetes/helm/kpm` (package `0.1.0`, `appVersion` `v1.0.0`). Daemon is the default. MCP stays off. The recommend CronJob execs into the daemon pod and does not mount the PVC. `affinity` schedules the sampler pod and the recommend Job. Daemon container resources are the top-level `resources` object. Pods run as distroless nonroot (65532) with a read-only root filesystem, dropped capabilities, and RuntimeDefault seccomp. `imagePullSecrets` is optional.
- Daemon profile enables the charts UI and `GET /api/v1` (`server.enabled`, bearer `KPM_SERVER_TOKEN`). MCP stays commented out.
- CronJob `kpm-recommend` runs `kpm recommend --record` with `kubectl exec` into the daemon pod. The Job does not mount the RWO store. ServiceAccount `kpm-recommend` is namespace-local (`pods` get/list, `pods/exec`, `deployments` get).
- README hero: `assets/kpm-selfhosted-hero.jpg` (same family artwork as upstream `kpm` OSS hero).

### Changed

- Application image pin `ghcr.io/hrodrig/kpm:v1.0.0` in `run/` docs and manifests.
- README product captures (`assets/kpm-serve-analyze-local-dark.png`,
  `assets/kpm-tui-cpu-request-13pods.png`, `assets/kpm-flow-diagram.png`) plus link to the
  [DEV.to walkthrough](https://dev.to/hrodrig/kpm-kubernetes-rightsizing-without-prometheus-history-on-your-laptop-4272).

## [0.1.0] - 2026-10-13

### Added

- Bootstrap operator repository: Docker notes, Kubernetes manifests (CronJob + Deployment + PVC + RBAC), standalone linux/macos/bsd paths, and example YAML profiles.
- Docs gate: `make release-check` (VERSION, README badge, CHANGELOG) with CI on pull requests and pushes to `develop` / `main`.
- Default application image pin: `ghcr.io/hrodrig/kpm:v0.6.0`.
- README aligned with the hrodrig selfhosted family (TOC, pick-a-path sections, layout, community policies/standards, gghstats clones badge).

[Unreleased]: https://github.com/hrodrig/kpm-selfhosted/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/hrodrig/kpm-selfhosted/releases/tag/v0.1.0
