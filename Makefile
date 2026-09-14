PREFIX ?= /usr
DESTDIR ?=

.DEFAULT_GOAL := help

.PHONY: help install uninstall validate build clean

help:
	@echo "Available targets:"
	@echo "  make build"
	@echo "  make install"
	@echo "  make uninstall"
	@echo "  make validate"

install:
	install -Dm755 src/bin/argvus-launcher "$(DESTDIR)$(PREFIX)/bin/argvus-launcher"
	install -dm755 "$(DESTDIR)$(PREFIX)/share/argvus/launcher"
	cp -R --no-preserve=ownership src/usr/share/argvus/launcher/. "$(DESTDIR)$(PREFIX)/share/argvus/launcher/"
	find "$(DESTDIR)$(PREFIX)/share/argvus/launcher/sh" -type f -name '*.sh' -exec chmod 755 {} \;
	install -Dm644 LICENSE "$(DESTDIR)$(PREFIX)/share/licenses/argvus-launcher/LICENSE"

uninstall:
	rm -f "$(DESTDIR)$(PREFIX)/bin/argvus-launcher"
	rm -rf "$(DESTDIR)$(PREFIX)/share/argvus/launcher"
	rm -f "$(DESTDIR)$(PREFIX)/share/licenses/argvus-launcher/LICENSE"

validate:
	@test -x src/bin/argvus-launcher
	@test -f src/usr/share/argvus/launcher/config/config.rasi
	@test -f src/usr/share/argvus/launcher/config/theme.rasi
	@for script in $$(find src -name '*.sh'); do sh -n "$$script"; done
	@if command -v shellcheck >/dev/null 2>&1; then for script in $$(find src -name '*.sh'); do shellcheck -e SC1090 -e SC2034 "$$script"; done; else echo "shellcheck not found; skipping shell lint"; fi
	@echo "argvus-launcher validation ok"

.PHONY: build

build:
	@tools/build-local-package.sh

clean:
	rm -rf dist
	rm -f packaging/arch/*.zst packaging/arch/*.tar.gz
