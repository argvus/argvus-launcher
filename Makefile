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
	install -dm755 "$(DESTDIR)$(PREFIX)/share/argvus"
	cp -R --no-preserve=ownership config/. "$(DESTDIR)$(PREFIX)/share/argvus/"
	install -dm755 "$(DESTDIR)$(PREFIX)/share/argvus/scripts/argvus-launcher"
	install -Dm755 src/scripts/apps/cheatsheets.sh "$(DESTDIR)$(PREFIX)/share/argvus/scripts/argvus-launcher/cheatsheets.sh"
	install -Dm755 src/scripts/apps/emoji-picker.sh "$(DESTDIR)$(PREFIX)/share/argvus/scripts/argvus-launcher/emoji-picker.sh"
	install -Dm644 LICENSE "$(DESTDIR)$(PREFIX)/share/licenses/argvus-launcher/LICENSE"

uninstall:
	rm -f "$(DESTDIR)$(PREFIX)/bin/argvus-launcher"
	rm -rf "$(DESTDIR)$(PREFIX)/share/argvus/rofi"
	rm -rf "$(DESTDIR)$(PREFIX)/share/argvus/scripts/argvus-launcher"
	rm -f "$(DESTDIR)$(PREFIX)/share/licenses/argvus-launcher/LICENSE"

validate:
	@test -x src/bin/argvus-launcher
	@test -f config/rofi/config.rasi
	@test -f config/rofi/theme.rasi
	@for script in $$(find src -name '*.sh'); do sh -n "$$script"; done
	@if command -v shellcheck >/dev/null 2>&1; then for script in $$(find src -name '*.sh'); do shellcheck -e SC1090 -e SC2034 "$$script"; done; else echo "shellcheck not found; skipping shell lint"; fi
	@echo "argvus-launcher validation ok"

.PHONY: build

build:
	@tools/build-local-package.sh

clean:
	rm -rf dist
	rm -f packaging/arch/*.zst packaging/arch/*.tar.gz
