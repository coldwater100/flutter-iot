PYTHON := $(shell command -v python3 || command -v python)
VENV_DIR := .venv
VENV_ACTIVATE := . $(VENV_DIR)/bin/activate

ifeq ($(OS),Windows_NT)
    VENV_ACTIVATE := $(VENV_DIR)\Scripts\activate
endif

venv:
	$(PYTHON) -m venv $(VENV_DIR)

install: venv
	$(VENV_ACTIVATE) && pip install --upgrade pip && pip install -e .[dev]

run:
	$(VENV_ACTIVATE) && python src/main.py

test:
	$(VENV_ACTIVATE) && pytest

lint:
	$(VENV_ACTIVATE) && ruff check src tests

format:
	$(VENV_ACTIVATE) && black src tests

clean:
	rm -rf $(VENV_DIR) __pycache__ **/__pycache__ *.pyc *.pyo *.pyd .pytest_cache .ruff_cache .mypy_cache .coverage dist

.PHONY: venv install run test lint format clean
