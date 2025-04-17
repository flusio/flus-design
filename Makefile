# This file is part of Flus Design.
# SPDX-License-Identifier: AGPL-3.0-or-later

.DEFAULT_GOAL := help

ifdef NODOCKER
	NPM = npm
else
	NPM = ./docker/bin/npm
endif

.PHONY: install
install: ## Install the dependencies
	$(NPM) install

.PHONY: watch
watch: ## Watch and build the assets
	rm -rf dev_build
	$(NPM) run watch

.PHONY: build
build: ## Build the dist assets
	rm -rf dist
	$(NPM) run build

.PHONY: lint
lint: LINTER ?= all
lint: ## Execute the linters (can take a LINTER argument)
ifeq ($(LINTER), $(filter $(LINTER), all biome))
	$(NPM) run lint
endif

.PHONY: release
release: ## Release a new version (take a VERSION argument)
ifndef VERSION
	$(error You need to provide a "VERSION" argument)
endif
	sed -i 's/"version": ".*"/"version": "$(VERSION)"/' package.json
	$(EDITOR) CHANGELOG.md
	git add .
	git commit -m "release: Publish version v$(VERSION)"
	git tag -a v$(VERSION) -m "Release version v$(VERSION)"

.PHONY: help
help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
