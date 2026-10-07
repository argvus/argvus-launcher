---
title: Application launcher
description: Launch applications and ARGVUS utility menus.
---

`argvus-launcher` supplies the Rofi configuration and utility menus used by ARGVUS. The `argvus` dispatcher also provides shortcuts for integrated tools such as the terminal, file managers and system monitor.

## Project switcher

`argvus-projects` (`SUPER + O`) lists the projects you added and opens the selected one in its own Hyprland workspace, with an `argvus-terminal` in its directory. Selecting a project whose workspace already exists only switches to it.

For keyboard-only access, `SUPER + ALT + 1` to `SUPER + ALT + 9` open the project in that position of the list, without the menu. The positions are the numbers shown in the menu. They follow the list order, so adding or removing a project can change them. `argvus-projects open <number or directory name>` does the same from a terminal, and failures are shown as a notification.

A project comes from two places in the `projects` section of `argvus-config`:

- `paths`: individual project directories.
- `roots`: directories whose immediate subdirectories are projects. The default is `~/Projects`. A root that does not exist is ignored.

Manage them from a terminal:

```sh
argvus-projects add ~/Work/api          # one project
argvus-projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus-projects remove ~/Work/api       # removes it from paths and roots
argvus-projects list                    # prints the roots and paths
```

If no root or path exists, `SUPER + O` reports that no projects were found. An optional editor command, `/projects/editor`, starts in the same workspace when the workspace is created.

The entries are read from the effective configuration; the launcher keeps no copy of them.

The launcher configuration is packaged separately from the shell. `argvus-config` projects the Rofi themes, mode and configuration into `data/generated/rofi/`, so every theme change keeps the menus visually consistent; the launcher itself owns no theme output.
