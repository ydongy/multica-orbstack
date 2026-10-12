<div align="center">

# multica-orbstack

Run the official self-hosted Multica images on OrbStack.

[![CI](https://github.com/ydongy/multica-orbstack/actions/workflows/ci.yml/badge.svg)](https://github.com/ydongy/multica-orbstack/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)](#requirements)

**English** · [简体中文](README.zh-CN.md)

</div>

Runs the official self-hosted [Multica](https://github.com/multica-ai/multica) images on OrbStack. The Multica
services and database run in containers; Multica Desktop, the daemon, Codex and your project files stay on macOS.

## Features

- One-command start: `make start` clones the upstream repository, generates random secrets and starts the official images.
- Status, log and health targets for the running services.
- Compressed, timestamped PostgreSQL backups.
- Safe updates: fast-forward the upstream checkout, then redeploy the released images.
- Installs the Multica Desktop connection config without overwriting a different existing one.

## Requirements

macOS, OrbStack (Docker Compose v2), and `git`, `curl`, `openssl` and `make`. `make check` verifies them.

## Quick start

1. Start OrbStack.
2. Run `make start`. It clones the upstream repository into `upstream/`, creates `upstream/.env` with randomly
   generated secrets, pulls the official images and starts them.
3. Check the services with `make status` and `make health`.
4. Open `http://localhost:3000` (or run `make open`), request a login code, then run `make logs` to read the code.
5. Fully quit Multica Desktop, run `make client-config`, and reopen Desktop.

## Usage

Run these in the repository root. `make help` lists every target (its output is in Chinese).

| Command | Purpose |
|---|---|
| `make check` | Check OrbStack, Docker and local tools |
| `make init` | Clone the upstream repository if it is missing |
| `make start` / `make stop` / `make restart` | Start, stop (keeping data volumes) or restart all services |
| `make status` | Show containers and health |
| `make logs` | Follow logs; `SERVICE=frontend` selects another service (default `backend`) |
| `make health` | Query `http://localhost:8080/readyz` |
| `make update` | Fast-forward the upstream checkout and deploy the current release |
| `make backup` | Dump PostgreSQL to `backups/` |
| `make client-config` | Install the Desktop config to `~/.multica/desktop.json` |
| `make open` | Open `http://localhost:3000` in the default browser |

```bash
make logs SERVICE=frontend
```

**Desktop and CLI.** Desktop uses its own daemon profile. Do not also start a default-profile daemon unless you
really need a second runtime. `desktop.json.example` is the template; `make client-config` never overwrites an
existing file with different content.

**Data and backups.** `make stop` keeps the PostgreSQL and upload volumes. Do not run `docker compose down -v`
unless you mean to wipe the instance. `make backup` writes a timestamped, compressed database dump to
`backups/`, which is git-ignored.

**Updating.** Run `make backup` first, then `make update`. The backend applies database migrations on startup;
check them with `make health`.

## Development

```bash
make help                           # list targets
shellcheck $(git ls-files '*.sh')   # when shell scripts are added
python3 -m json.tool desktop.json.example
```

CI runs the same checks. The Compose file belongs to the upstream repository and is not stored here.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Commit messages and pull request titles follow
[Conventional Commits](https://www.conventionalcommits.org/). Keep `README.md` and `README.zh-CN.md` in sync.

## Security

Report vulnerabilities privately via GitHub Security, "Report a vulnerability":
[open an advisory](https://github.com/ydongy/multica-orbstack/security/advisories/new).

## License

[MIT](LICENSE), copyright (c) 2026 ydongy. Multica itself comes from the upstream project
[multica-ai/multica](https://github.com/multica-ai/multica) under its own license and is not included here.
