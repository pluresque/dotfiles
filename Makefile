.PHONY: help up down restart-bot restart-api restart logs dev-up dev-down dev-restart-bot dev-restart-api dev-restart dev-logs generate-proto proto-clean generate-proto-go run-with-proto setup-proto-tools test

# Include .env file if it exists
-include .env

help:
	@echo "Available commands:"
	@echo "  make                 - Show this list of commands"
	@echo "  make up              - Start all containers"
	@echo "  make down            - Stop all containers"
	@echo "  make restart-bot     - Restart the bot container"
	@echo "  make restart-api     - Restart the REST API container"
	@echo "  make restart         - Restart all containers"
	@echo "  make logs            - Show and follow logs (last 100 lines)"
	@echo "  make dev-up          - Start all dev containers"
	@echo "  make dev-down        - Stop all dev containers"
	@echo "  make dev-restart-bot - Restart the dev bot container"
	@echo "  make dev-restart-api - Restart the dev REST API container"
	@echo "  make dev-restart     - Restart all dev containers"
	@echo "  make dev-logs        - Show and follow dev logs (last 100 lines)"
	@echo "  make create-migration - Create a new migration"
	@echo "  make upgrade-db      - Upgrade the database"
	@echo "  make dev-create-migration - Create a new dev migration"
	@echo "  make dev-upgrade-db      - Upgrade the dev database"
	@echo "  make dev-build-golang    - Build golang images"
	@echo "  make upgrade-nats    - Upgrade the NATS configuration"
	@echo "  make dev-upgrade-nats  - Upgrade the dev NATS configuration"
	@echo "  make generate-proto  - Generate Python code from protobuf definitions"
	@echo "  make proto-clean     - Clean up generated protobuf files"
	@echo "  make generate-proto-go - Generate Go code from protobuf definitions"
	@echo "  make run-with-proto   - Generate proto files and run services"
	@echo "  make setup-proto-tools - Set up protobuf tools"
	@echo "  make test            - Run all tests"

up:
	docker-compose up --build -d

down:
	docker-compose down

build-golang:
	docker build -f golang/docker/aiservice.Dockerfile golang -t chatmoderator-aiservice:latest
	docker build -f golang/docker/mediaservice.Dockerfile golang -t chatmoderator-mediaservice:latest

rebuild: build-golang
	docker-compose down
	docker-compose up --build -d

rebuild-force: build-golang
	docker-compose down -v
	docker-compose up --build -d

restart-bot:
	docker-compose restart bot
	docker-compose logs -f --tail 100 bot

restart-api:
	docker-compose restart api

restart-imgprocessing:
	docker-compose restart imgprocessing
	docker-compose logs -f --tail 100 imgprocessing

logs:
	docker-compose logs -f --tail 100

restart:
	docker-compose restart
	docker-compose logs -f --tail 100

# Dev environment commands
dev-up:
	docker-compose -f docker-compose-dev.yml up --build -d

dev-down:
	docker-compose -f docker-compose-dev.yml down

dev-build-golang:
	docker build -f golang/docker/aiservice.Dockerfile golang -t chatmoderator-aiservice-dev:latest
	docker build -f golang/docker/mediaservice.Dockerfile golang -t chatmoderator-mediaservice-dev:latest

dev-rebuild: dev-build-golang
	docker-compose -f docker-compose-dev.yml down
	docker-compose -f docker-compose-dev.yml up --build -d

dev-rebuild-force: dev-build-golang
	docker-compose -f docker-compose-dev.yml down -v
	docker-compose -f docker-compose-dev.yml up --build -d

dev-restart-bot:
	docker-compose -f docker-compose-dev.yml restart bot
	docker-compose -f docker-compose-dev.yml logs -f --tail 100 bot

dev-restart-api:
	docker-compose -f docker-compose-dev.yml restart rest-api
	docker-compose -f docker-compose-dev.yml logs -f --tail 100 rest-api

dev-logs:
	docker-compose -f docker-compose-dev.yml logs -f --tail 100

dev-restart:
	docker-compose -f docker-compose-dev.yml restart
	docker-compose -f docker-compose-dev.yml logs -f --tail 100

dev-restart-detached:
	docker-compose -f docker-compose-dev.yml restart

dev-upgrade-nats:
	docker run --rm -t --network chatmoderator-dev_tg_bot \
		-v ./migrations/nats:/data/nats:ro \
		-e NATS_SERVER=nats://chatmoderator-nats-dev:4222 \
		natsio/nats-box:latest /data/nats/migrate

upgrade-nats:
	docker run --rm -t --network chatmoderator_tg_bot \
		-v ./migrations/nats:/data/nats:ro \
		-e NATS_SERVER=nats://nats-server:4222 \
		natsio/nats-box:latest /data/nats/migrate

create-migration:
	docker-compose exec api alembic revision --autogenerate -m "$(m)"

upgrade-db:
	docker-compose exec api alembic upgrade head

dev-create-migration:
	docker-compose -f docker-compose-dev.yml exec api alembic revision --autogenerate -m "$(m)"

dev-upgrade-db:
	docker-compose -f docker-compose-dev.yml exec api alembic upgrade head

dev-downgrade-db:
	docker-compose -f docker-compose-dev.yml exec api alembic downgrade -1

downgrade-db:
	docker-compose exec api alembic downgrade -1

generate-translations:
	@echo "Parsing translations..."
	fast-ftl-extract '.' './locales' -k 'i18n' -k 'I18NFormat' -l 'ar' -l 'de' -l 'en' -l 'es' -l 'pl' -l 'ru' -l 'uk' -l 'zh' --comment-junks --ignore-kwargs 'when' --verbose -p 'self' 
	@echo "Generating translation stubs..."
	i18n stub -i locales/uk/_default.ftl -o tgbot/locales/stub.pyi


gen-structure:
	python .cursor/scripts/project_structure.py --output .cursor/rules/project_structure.json 

SHELL := /bin/bash

generate-proto-python:
	bash -c '. ./.venv/bin/activate \
	&& python -m grpc_tools.protoc \
		--proto_path=proto \
		--python_out=application/proto \
		--grpc_python_out=application/proto \
		--mypy_out=application/proto \
		`find proto -name "*.proto"` \
	&& deactivate'

proto-clean-python:
	sudo rm -rf application/proto/*

proto-clean-go:
	sudo rm -rf golang/pkg/proto/*

proto-clean-all: proto-clean-python proto-clean-go

generate-proto-go:
	PATH=$$PATH:$${HOME}/go/bin buf generate proto/ --template=proto/buf.gen.go.yaml

generate-proto-all: generate-proto-python generate-proto-go

# Connect to NATS using CLI
.PHONY: nats-connect
nats-connect:
	nats context save nats-connection --server="$(NATS_LOCAL_CONNECT_PROD)"
	nats context select nats-connection
	nats server info


# Connect to NATS using CLI
.PHONY: nats-connect-dev
nats-connect-dev:
	nats context save nats-connection --server="$(NATS_LOCAL_CONNECT_DEV)"
	nats context select nats-connection
	nats server info

test:
	PYTHONPATH=. python -m pytest tests
