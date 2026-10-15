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

## Issues and pull requests

`gh issue create` and `gh pr create --body` skip the issue forms and the pull request template, so write their
structure yourself. Search open issues first; one issue is one problem.

- Issue title: one short sentence that says the problem or the outcome, in English or Simplified Chinese. No type
  prefix such as `[feat]`; the label carries the type.
- Bug, `--label bug`: `## What happened`, `## What you expected`, `## Steps to reproduce`,
  `## Version and environment`.
- Feature or improvement, `--label enhancement`: `## Problem`, `## Proposed solution`,
  `## Alternatives considered` (when there were any), `## Done when`.
- Documentation, `--label documentation`: `## Where`, `## What is missing, unclear or wrong`, `## Suggested change`.
- Pull request: the title is the Conventional Commits subject (it becomes the squash commit). The body has
  `## Summary` (what changes and why), `## Related issue` (`Closes #<n>`, or `None.`), `## How tested` (the
  commands run and their results, and what was not run) and `## Checklist`:
  `- [ ] PR title follows Conventional Commits`, `- [ ] Tests pass`,
  `- [ ] Documentation updated where behavior changed`, ticked only when true.

## Red lines

- Credentials (the generated secrets in `upstream/.env`, tokens, login codes) never appear in code, pull requests,
  issues, logs or chat.
- Releases and anything sent to an external service need the maintainer's confirmation.
- Review the staged file list before committing; no blind `git add -A` of unknown files.
- No personal paths or private data in the repository.
