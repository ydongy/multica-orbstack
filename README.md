English | [中文](README.zh-CN.md)

# multica-orbstack

[![CI](https://github.com/ydongy/multica-orbstack/actions/workflows/ci.yml/badge.svg)](https://github.com/ydongy/multica-orbstack/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Run the official self-hosted [Multica](https://github.com/multica-ai/multica) images on OrbStack. The Multica
services and database run in containers; Multica Desktop, the daemon, Codex and your project files stay on macOS.

## Quick start

Requires macOS, OrbStack (Docker Compose v2), and `git`, `curl` and `openssl`. `make check` verifies them.

1. Start OrbStack.
2. Run `make start`. It clones the upstream repository into `upstream/`, creates `upstream/.env` with randomly
   generated secrets, pulls the official images and starts them.
3. Check the services with `make status` and `make health`.
4. Open `http://localhost:3000`, request a login code, then run `make logs` to read the code.
5. Fully quit Multica Desktop, run `make client-config`, and reopen Desktop.

## Usage

Run these in the repository root: `make start`, `make stop`, `make restart`, `make status`, `make logs`,
`make health`, `make update`, `make backup`. `make help` lists every target.

To read the logs of another service, pass `SERVICE`:

```bash
make logs SERVICE=frontend
```

**Desktop and CLI.** Desktop uses its own daemon profile. Do not also start a default-profile daemon unless you
really need a second runtime. `desktop.json.example` is the template; `make client-config` installs it to
`~/.multica/desktop.json` and never overwrites an existing file with different content.

**Data and backups.** `make stop` keeps the PostgreSQL and upload volumes. Do not run `docker compose down -v`
unless you mean to wipe the instance. `make backup` writes a timestamped, compressed database dump to
`backups/`, which is git-ignored.

**Updating.** Run `make backup` first, then `make update`. It fast-forwards the upstream checkout and starts the
currently released images. The backend applies database migrations on startup; check them with `make health`.

Note: the Makefile output is in Chinese.

## Development

```bash
make help                           # list targets
shellcheck $(git ls-files '*.sh')   # when shell scripts are added
python3 -m json.tool desktop.json.example
```

CI runs the same checks. The Compose file belongs to the upstream repository and is not stored here.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE), copyright (c) 2026 ydongy. Multica itself comes from the upstream project
[multica-ai/multica](https://github.com/multica-ai/multica) under its own license and is not included here.
