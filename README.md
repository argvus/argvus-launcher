# argvus-launcher

Universal Quickshell launcher with a local Rust search engine, themes and specialized Rofi menus for the ARGVUS desktop.

[![CI](https://github.com/argvus/argvus-launcher/actions/workflows/ci.yml/badge.svg)](https://github.com/argvus/argvus-launcher/actions/workflows/ci.yml)
[![Release](https://github.com/argvus/argvus-launcher/actions/workflows/release.yml/badge.svg)](https://github.com/argvus/argvus-launcher/actions/workflows/release.yml)
[![License](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](LICENSE)
[![Language: Shell](https://img.shields.io/badge/Shell-POSIX-4EAA25?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Platform: Arch Linux | Wayland](https://img.shields.io/badge/platform-Arch%20Linux%20%7C%20Wayland-1793D1?logo=archlinux&logoColor=white)](https://archlinux.org/)
[![Pull requests](https://img.shields.io/github/issues-pr/argvus/argvus-launcher)](https://github.com/argvus/argvus-launcher/pulls)
[![Issues](https://img.shields.io/github/issues/argvus/argvus-launcher)](https://github.com/argvus/argvus-launcher/issues)
[![Last commit](https://img.shields.io/github/last-commit/argvus/argvus-launcher)](https://github.com/argvus/argvus-launcher/commits/main)
[![Docs](https://img.shields.io/badge/docs-project-blue)](./docs/)

This repository packages the launcher configuration, themes and menus. Its `src/`
tree is the payload; both PKGBUILDs (`packaging/arch/remote` and `packaging/arch/local`)
build it.

## Universal search

`argvus launcher` opens a central panel for applications, windows, settings,
actions, projects, SSH, files and shortcut help. Configure sources, priorities,
favorites and indexing with `argvus control-center launcher`. File indexing is
opt-in and stores names and paths only; recent files use the XDG registry.
Preferences belong to `argvus config`, while the index is rebuildable cache.
The engine ships in the `argvus` master package; this package supplies QML,
the launcher entry point, theme templates and the existing specialized Rofi menus.
Rasi `--config` overrides are no longer accepted by the main launcher.

The launcher uses a compact TUI layout: monospaced text, aligned search and category controls, compact favorites and a separate help footer. Border thickness and rounding follow the active ARGVUS layout settings.

## Build and install

On Arch Linux or a compatible distribution:

```sh
sudo pacman -S --needed base-devel git shellcheck
make validate
make build
make install
```

`make build` creates a deterministic local source archive in
`build/artifacts/` and a package in `build/dist/`. `make install` requires
`sudo` and installs the one package found in that directory without a blanket
`--overwrite` rule.

For package metadata only:

```sh
make validate
makepkg -p packaging/arch/remote/PKGBUILD --printsrcinfo
```

See [packaging/arch/README.md](packaging/arch/README.md) for the difference
between local and release builds.

## Documentation

- [DEVELOPMENT.md](DEVELOPMENT.md) — layout, checks, and releases
- [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) — contribution workflow
- [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) — private vulnerability reports
- [Code of Conduct](https://github.com/argvus/.github/blob/main/policies/CODE_OF_CONDUCT.md) — community standards
- [AI usage policy](https://github.com/argvus/.github/blob/main/policies/IA_USAGE.md) — rules for AI-assisted contributions

## License

SPDX: `GPL-3.0-only`. See [LICENSE](LICENSE).
