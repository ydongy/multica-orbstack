<div align="center">

# multica-orbstack

在 OrbStack 上运行 Multica 官方自托管镜像。

[![CI](https://github.com/ydongy/multica-orbstack/actions/workflows/ci.yml/badge.svg)](https://github.com/ydongy/multica-orbstack/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)](#环境要求)

[English](README.md) · **简体中文**

</div>

通过 OrbStack 运行 [Multica](https://github.com/multica-ai/multica) 官方自托管镜像。Multica 服务和数据库在容器中运行，Multica Desktop、守护进程、Codex 和项目文件仍在 macOS 上。

## 功能特性

- 一条命令启动：`make start` 会克隆官方仓库、生成随机凭据并启动官方镜像。
- 提供状态、日志和健康检查命令。
- 生成带时间戳的压缩 PostgreSQL 备份。
- 安全更新：先快进同步官方仓库，再部署当前发布的镜像。
- 安装 Multica Desktop 的连接配置，且不会覆盖内容不同的现有配置。

## 环境要求

macOS、OrbStack（Docker Compose v2），以及 `git`、`curl`、`openssl` 和 `make`。运行 `make check` 可检查依赖。

## 快速开始

1. 启动 OrbStack。
2. 运行 `make start`。它会把官方仓库克隆到 `upstream/`，用随机生成的凭据创建 `upstream/.env`，拉取官方镜像并启动。
3. 用 `make status` 和 `make health` 检查服务状态。
4. 打开 `http://localhost:3000`（或运行 `make open`）并申请登录验证码，然后运行 `make logs` 查看验证码。
5. 完全退出 Multica Desktop，运行 `make client-config`，再重新打开 Desktop。

## 使用方法

在仓库根目录运行。`make help` 会列出全部目标（输出为中文）。

| 命令 | 用途 |
|---|---|
| `make check` | 检查 OrbStack、Docker 和本机依赖 |
| `make init` | 缺少官方仓库时自动克隆 |
| `make start` / `make stop` / `make restart` | 启动、停止（保留数据卷）或重启全部服务 |
| `make status` | 查看容器和健康状态 |
| `make logs` | 持续查看日志；用 `SERVICE=frontend` 指定其他服务（默认 `backend`） |
| `make health` | 请求 `http://localhost:8080/readyz` |
| `make update` | 快进同步官方仓库并部署当前发布版本 |
| `make backup` | 把 PostgreSQL 备份到 `backups/` |
| `make client-config` | 把 Desktop 配置安装到 `~/.multica/desktop.json` |
| `make open` | 用默认浏览器打开 `http://localhost:3000` |

```bash
make logs SERVICE=frontend
```

**Desktop 和 CLI。** Desktop 使用独立的守护进程配置。除非确实需要第二个运行时，否则不要同时启动默认配置的守护进程。配置模板是 `desktop.json.example`；`make client-config` 不会覆盖内容不同的现有配置。

**数据和备份。** `make stop` 会保留 PostgreSQL 和上传文件的数据卷。除非准备清空实例，否则不要运行 `docker compose down -v`。`make backup` 会在 `backups/` 中生成带时间戳的压缩数据库备份，该目录已被 Git 忽略。

**更新。** 先执行 `make backup`，再运行 `make update`。后端启动时会自动执行数据库迁移，可用 `make health` 检查迁移结果。

## 开发

```bash
make help                          # 列出所有目标
shellcheck $(git ls-files '*.sh')  # 仓库新增 shell 脚本时运行
python3 -m json.tool desktop.json.example
```

CI 运行同样的检查。Compose 文件属于官方仓库，不保存在本仓库中。

## 参与贡献

见 [CONTRIBUTING.md](CONTRIBUTING.md)。提交信息和 Pull Request 标题遵循 [Conventional Commits](https://www.conventionalcommits.org/)。请保持 `README.md` 与 `README.zh-CN.md` 同步。

## 安全

请通过 GitHub Security 的 “Report a vulnerability” 私下报告漏洞：[提交安全公告](https://github.com/ydongy/multica-orbstack/security/advisories/new)。

## 许可证

[MIT](LICENSE)，Copyright (c) 2026 ydongy。Multica 本身由其上游项目 [multica-ai/multica](https://github.com/multica-ai/multica) 按其自身许可证提供，不包含在本仓库中。
