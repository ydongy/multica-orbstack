# AGENTS.md

## What it is

A Makefile and config template for running the official self-hosted Multica images on OrbStack (macOS). The
upstream repository is cloned into `upstream/` at runtime and is not part of this repository.

## Layout

```
Makefile             all commands (help, check, init, start, stop, restart, status, logs, health, update, backup, client-config, open)
desktop.json.example Multica Desktop connection template installed by `make client-config`
README.md            English guide; README.zh-CN.md is the Chinese counterpart (keep both in sync)
```

## Commands

```bash
make help
shellcheck $(git ls-files '*.sh')      # only if shell scripts exist
python3 -m json.tool desktop.json.example
```

`make start`, `update` and `backup` need Docker and a running OrbStack; do not run them in automation.

## Conventions

- Makefile messages are Chinese; documentation is bilingual (README.md and README.zh-CN.md).
- Never overwrite user config: `client-config` refuses to replace a different existing file.
- Never commit `upstream/`, `backups/`, `.env` or real secrets; secrets are generated locally by `make start`.
- Update `CHANGELOG.md` under `[Unreleased]` for user-visible changes.
- Commit messages and PR titles: `feat|fix|docs|refactor|perf|test|build|ci|chore|revert(scope)!: subject`.
  Branches: `<type>/<issue>-<slug>`.

## Red lines

No credentials, personal paths or private data in the repository.
