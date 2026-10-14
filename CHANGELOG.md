# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- README hero: `assets/kpm-selfhosted-hero.jpg` (same family artwork as upstream `kpm` OSS hero).
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
