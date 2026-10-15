# Contributing to multica-orbstack

Issues and pull requests may be written in English or Simplified Chinese. 欢迎用中文或英文提 issue 和 PR。

Open an issue before starting a large change. Small fixes can go straight to a pull request.

## Setup

macOS with OrbStack, `git`, `curl`, `openssl`, `make`. For linting, install
[shellcheck](https://www.shellcheck.net/) (`brew install shellcheck`).

```bash
git clone https://github.com/ydongy/multica-orbstack.git
cd multica-orbstack
make help
shellcheck $(git ls-files '*.sh')   # when shell scripts are added
python3 -m json.tool desktop.json.example
```

Never commit `upstream/`, `backups/` or any `.env` file, and keep secrets out of examples.

## Commits and pull requests

- Commit messages and pull request titles follow [Conventional Commits](https://www.conventionalcommits.org/):
  `feat|fix|docs|refactor|perf|test|build|ci|chore|revert(scope)!: subject`.
- Branch names: `<type>/<issue>-<slug>`, for example `fix/7-backup-path`.
- A maintainer squash-merges. No sign-off (DCO) is required.
- Update `CHANGELOG.md` under `[Unreleased]` for user-visible changes, and keep `README.md` and
  `README.zh-CN.md` in sync.
