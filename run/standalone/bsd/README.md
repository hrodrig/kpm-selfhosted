# FreeBSD / OpenBSD (standalone)

← [Back to run/standalone](../README.md).

Upstream **kpm** ships **port skeletons** (not yet in the official ports trees):

- FreeBSD: [contrib/freebsd/](https://github.com/hrodrig/kpm/tree/main/contrib/freebsd)
- OpenBSD: [contrib/openbsd/port/](https://github.com/hrodrig/kpm/tree/main/contrib/openbsd/port)

Or download **freebsd** / **openbsd** tarballs from **[kpm Releases](https://github.com/hrodrig/kpm/releases)** when published for that OS.

Operator shape is the same as Linux: cron + `sample.interval_seconds: 0`, or a long-running process with `interval_seconds > 0`. Example profiles: [run/examples/](../examples/README.md).
