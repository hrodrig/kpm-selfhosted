# Contributing (kpm-selfhosted)

## Scope

- **This repo:** Operator docs, **`run/docker/`**, **`run/examples/`**, **`run/kubernetes/manifests/`**, and **`run/standalone/`**. **No** Docker Compose or Helm chart in v0.1.0.
- **[hrodrig/kpm](https://github.com/hrodrig/kpm):** Go application, **`make release-check`**, tests, and container images.

## Checks

- **This repo:** **`make release-check`** (VERSION, README badge, CHANGELOG section) — same gate as [CI](.github/workflows/ci.yml).
- **kpm application:** clone **[hrodrig/kpm](https://github.com/hrodrig/kpm)** and run **`make release-check`** there.

## Releases

1. Work on **`develop`**; merge to **`main`** when ready.
2. Bump **`VERSION`**, **`CHANGELOG.md`**, and the README **Version** badge together.
3. On **`main`**: **`git tag -a v0.1.0 -m "kpm-selfhosted 0.1.0"`** and **`git push origin v0.1.0`**. [**Release**](.github/workflows/release.yml) creates the GitHub Release from the matching **`CHANGELOG`** section.
4. To refresh notes for an existing tag: **Actions → Release → Run workflow** with the tag name.

## Pull requests

- Keep **English** in all committed text.
- When **`run/examples/*.yml`** change, confirm they still match **[SPECIFICATIONS.md](https://github.com/hrodrig/kpm/blob/main/SPECIFICATIONS.md)** in the **kpm** repo.
- Do not commit real kubeconfigs, webhook URLs, MCP/server tokens, or cluster credentials.

## Security

Report sensitive issues per **[SECURITY.md](SECURITY.md)**.

Community interaction: **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)**. Notable repo changes: **[CHANGELOG.md](CHANGELOG.md)**. AI agent scope and release policy: **[AGENTS.md](AGENTS.md)**.
