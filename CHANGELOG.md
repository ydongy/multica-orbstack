# Changelog

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- Makefile to run the official self-hosted Multica images on OrbStack: `start`, `stop`, `restart`, `status`,
  `logs`, `health`, `update`, `backup`, `client-config`, `open`.
- Automatic clone of the upstream repository and generation of random secrets in `upstream/.env`.
- `desktop.json.example` and `make client-config` that never overwrites a different existing config.
- English README and Chinese README (`README.zh-CN.md`).
