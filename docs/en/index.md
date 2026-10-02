---
title: Application launcher
description: Launch applications and ARGVUS utility menus.
---

`argvus-launcher` supplies the Rofi configuration and utility menus used by ARGVUS. The `argvus` dispatcher also provides shortcuts for integrated tools such as the terminal, file managers and system monitor.

The launcher configuration is packaged separately from the shell. `argvus-config` projects the Rofi themes, mode and configuration into `data/generated/rofi/`, so every theme change keeps the menus visually consistent; the launcher itself owns no theme output.
