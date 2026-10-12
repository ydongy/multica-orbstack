SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
UPSTREAM_DIR ?= $(ROOT_DIR)/upstream
COMPOSE_FILE := $(UPSTREAM_DIR)/docker-compose.selfhost.yml
DESKTOP_TEMPLATE := $(ROOT_DIR)/desktop.json.example
DESKTOP_CONFIG ?= $(HOME)/.multica/desktop.json
BACKUP_DIR ?= $(ROOT_DIR)/backups
SERVICE ?= backend
REPOSITORY ?= https://github.com/multica-ai/multica.git
COMPOSE = docker compose --project-directory "$(UPSTREAM_DIR)" --env-file "$(UPSTREAM_DIR)/.env" -f "$(COMPOSE_FILE)"

.PHONY: help check init ensure-env start stop restart status logs health update backup client-config open

help: ## 显示可用命令
	@awk 'BEGIN {FS = ":.*## "; printf "用法：make <目标>\n\n"} /^[a-zA-Z0-9_.-]+:.*## / {printf "  %-16s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@printf '\n'
	@printf '网页：      http://localhost:3000\n'
	@printf 'API：       http://localhost:8080\n'
	@printf '健康检查：  http://localhost:8080/readyz\n'

check: ## 检查 OrbStack、Docker 和本机依赖
	@command -v docker >/dev/null || { echo "未找到 docker 命令，请先启动 OrbStack"; exit 1; }
	@docker info >/dev/null || { echo "无法连接 Docker，请先启动 OrbStack"; exit 1; }
	@compose_version="$$(docker compose version --short 2>/dev/null)"; case "$$compose_version" in 1.*|v1.*|'') echo "需要 Docker Compose v2"; exit 1;; esac
	@for tool in git curl openssl; do command -v "$$tool" >/dev/null || { echo "缺少必要工具：$$tool"; exit 1; }; done
	@echo "Docker 和所需工具均可用。"

init: check ## 缺少官方 Multica 仓库时自动克隆
	@if [ -d "$(UPSTREAM_DIR)/.git" ]; then echo "官方仓库已存在：$(UPSTREAM_DIR)"; \
	elif [ -e "$(UPSTREAM_DIR)" ]; then echo "$(UPSTREAM_DIR) 已存在，但不是 Git 仓库"; exit 1; \
	else git clone --depth 1 "$(REPOSITORY)" "$(UPSTREAM_DIR)"; fi

ensure-env:
	@if [ ! -f "$(UPSTREAM_DIR)/.env" ]; then \
		cp "$(UPSTREAM_DIR)/.env.example" "$(UPSTREAM_DIR)/.env"; \
		jwt="$$(openssl rand -hex 32)"; \
		pgpass="$$(openssl rand -hex 24)"; \
		vcskey="$$(openssl rand -base64 32)"; \
		sed -i '' "s/^JWT_SECRET=.*/JWT_SECRET=$$jwt/" "$(UPSTREAM_DIR)/.env"; \
		sed -i '' "s/^POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$$pgpass/" "$(UPSTREAM_DIR)/.env"; \
		sed -i '' -E "s#^(DATABASE_URL=postgres://[^:]+:)[^@]*(@.*)#\1$$pgpass\2#" "$(UPSTREAM_DIR)/.env"; \
		sed -i '' "s#^MULTICA_VCS_SECRET_KEY=.*#MULTICA_VCS_SECRET_KEY=$$vcskey#" "$(UPSTREAM_DIR)/.env"; \
		echo "已创建 upstream/.env，并生成随机凭证"; \
	fi

start: init ## 拉取官方镜像并启动 Multica
	@$(MAKE) ensure-env
	@$(MAKE) -C "$(UPSTREAM_DIR)" selfhost

stop: ## 停止 Multica 并保留数据卷
	@test -f "$(COMPOSE_FILE)" || { echo "请先运行 make init"; exit 1; }
	@$(MAKE) -C "$(UPSTREAM_DIR)" selfhost-stop

restart: stop start ## 重启全部 Multica 服务

status: ## 查看容器和健康状态
	@test -f "$(UPSTREAM_DIR)/.env" || { echo "请先运行 make start"; exit 1; }
	@$(COMPOSE) ps

logs: ## 持续查看日志，可用 SERVICE=frontend 指定服务
	@test -f "$(UPSTREAM_DIR)/.env" || { echo "请先运行 make start"; exit 1; }
	@$(COMPOSE) logs -f --tail=200 "$(SERVICE)"

health: ## 检查 API、数据库和迁移状态
	@curl -fsS http://localhost:8080/readyz
	@printf '\n'

update: init ## 同步官方仓库并部署当前发布镜像
	@git -C "$(UPSTREAM_DIR)" pull --ff-only
	@$(MAKE) -C "$(UPSTREAM_DIR)" selfhost

backup: ## 将 PostgreSQL 备份并压缩到 backups/
	@test -f "$(UPSTREAM_DIR)/.env" || { echo "请先运行 make start"; exit 1; }
	@mkdir -p "$(BACKUP_DIR)"
	@stamp="$$(date +%Y%m%d-%H%M%S)"; output="$(BACKUP_DIR)/multica-$$stamp.sql"; \
	$(COMPOSE) exec -T postgres sh -eu -c 'pg_dump -U "$$POSTGRES_USER" "$$POSTGRES_DB"' > "$$output"; \
	gzip "$$output"; echo "备份已写入：$$output.gz"

client-config: ## 安装 Multica Desktop 的本机连接配置
	@mkdir -p "$$(dirname "$(DESKTOP_CONFIG)")"
	@if [ ! -e "$(DESKTOP_CONFIG)" ]; then cp "$(DESKTOP_TEMPLATE)" "$(DESKTOP_CONFIG)"; echo "已安装：$(DESKTOP_CONFIG)"; \
	elif cmp -s "$(DESKTOP_TEMPLATE)" "$(DESKTOP_CONFIG)"; then echo "Desktop 配置已是最新状态"; \
	else echo "拒绝覆盖现有配置：$(DESKTOP_CONFIG)"; echo "请与模板比较：$(DESKTOP_TEMPLATE)"; exit 1; fi

open: ## 用 macOS 默认浏览器打开 Multica
	@open http://localhost:3000
