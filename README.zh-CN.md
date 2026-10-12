[English](README.md) | 中文

# 在 OrbStack 上运行 Multica

[![CI](https://github.com/ydongy/multica-orbstack/actions/workflows/ci.yml/badge.svg)](https://github.com/ydongy/multica-orbstack/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

这个目录通过 OrbStack 运行 Multica 官方自托管镜像。Multica 服务和数据库在容器中运行，Multica Desktop、守护进程、Codex 和项目文件仍在 macOS 上。

## 快速开始

需要 macOS、OrbStack（Docker Compose v2）以及 `git`、`curl`、`openssl`。运行 `make check` 可检查依赖。

1. 启动 OrbStack。
2. 运行 `make start`。
3. 用 `make status` 和 `make health` 检查服务状态。
4. 打开 `http://localhost:3000` 并申请登录验证码，然后运行 `make logs` 查看验证码。
5. 完全退出 Multica Desktop，运行 `make client-config`，再重新打开 Desktop。

## 使用


在这个目录中可以运行 `make start`、`make stop`、`make restart`、`make status`、`make logs`、`make health`、`make update` 和 `make backup`。运行 `make help` 可以查看完整列表。

查看其他服务的日志时，通过 `SERVICE` 指定服务：

```bash
make logs SERVICE=frontend
```

## Desktop 和 CLI

Desktop 使用独立的守护进程配置。除非确实需要第二个运行时，否则不要同时启动默认配置的守护进程。配置模板是 `desktop.json.example`；`make client-config` 会安装该模板，但不会覆盖内容不同的现有配置。

## 数据和备份

`make stop` 会保留 PostgreSQL 和上传文件的数据卷。除非准备清空实例，否则不要运行 `docker compose down -v`。`make backup` 会在 `backups/` 中生成带时间戳的压缩数据库备份，该目录不会提交到 Git。

## 更新

运行 `make update` 前先执行 `make backup`。更新命令会以仅快进方式同步官方仓库，并启动当前发布的镜像。后端启动时会自动执行数据库迁移，可用 `make health` 检查迁移结果。

## 开发

```bash
make help                          # 列出所有目标
shellcheck $(git ls-files '*.sh')  # 仓库新增 shell 脚本时运行
python3 -m json.tool desktop.json.example
```

## 贡献

见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 许可证

[MIT](LICENSE)，Copyright (c) 2026 ydongy。Multica 本身由其上游项目 [multica-ai/multica](https://github.com/multica-ai/multica) 按其自身许可证提供，不包含在本仓库中。
