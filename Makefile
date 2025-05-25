FLUTTER=flutter/bin/flutter

# Prefer podman-compose if available; fallback to docker compose
ifeq (, $(shell command -v podman-compose 2>/dev/null))
	COMPOSE_CMD=docker compose
else
	COMPOSE_CMD=podman-compose
endif

# Flutter commands
flutter-run:
	cd flutter_app && ../$(FLUTTER) run

flutter-build:
	cd flutter_app && ../$(FLUTTER) build apk

flutter-clean:
	cd flutter_app && ../$(FLUTTER) clean

flutter-get:
	cd flutter_app && ../$(FLUTTER) pub get

# Docker/Podman Compose commands
up:
	$(COMPOSE_CMD) up --build

down:
	$(COMPOSE_CMD) down

build:
	$(COMPOSE_CMD) build

logs:
	$(COMPOSE_CMD) logs -f edge_client backend

restart:
	$(MAKE) down
	$(MAKE) up

# Optional: For macOS Podman Desktop
podman-start:
	podman machine start || true
