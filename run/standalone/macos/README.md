# macOS (standalone binary)

← [Back to run/standalone](../README.md).

1. Download a **darwin** tarball from **[kpm Releases](https://github.com/hrodrig/kpm/releases)** (`amd64` or `arm64`).
2. Extract **`kpm`** onto your `PATH`.
3. Use a profile from [run/examples/](../../examples/README.md); point `KUBECONFIG` at your kubeconfig and `store.path` at a durable file under `$HOME`.

**One-shot / cron:** `crontab -e` with `kpm sample --config …` and `sample.interval_seconds: 0`.

**Daemon:** run under `launchd` or a terminal multiplexer with `interval_seconds > 0`. Homebrew tap for **kpm** is not published yet — use the release binary or `go install github.com/hrodrig/kpm/cmd/kpm@v0.6.0`.
