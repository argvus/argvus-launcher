---
title: Application launcher
description: Launch applications and ARGVUS utility menus.
---

`argvus-launcher` supplies the Rofi configuration and utility menus used by ARGVUS. The `argvus` dispatcher also provides shortcuts for integrated tools such as the terminal, file managers and system monitor.

## Project switcher

`argvus-projects` (`SUPER + O`) lists the projects you added and opens the selected one in its own Hyprland workspace, with an `argvus-terminal` in its directory. Selecting a project whose workspace already exists only switches to it.

For keyboard-only access, `SUPER + ALT + 1` to `SUPER + ALT + 9` open the project in that position of the list, without the menu. The positions are the numbers shown in the menu. They follow the list order, so adding or removing a project can change them. `argvus-projects open <number or directory name>` does the same from a terminal, and failures are shown as a notification.

The effective project list is capped at 9, since that is all `SUPER + ALT + 1..9` can address. `argvus-projects add` (and the Control Center's Projects page, which calls it) refuses to add a project or root that would push the total past 9, and reports the error instead.

A project comes from two places in the `projects` section of `argvus-config`:

- `paths`: individual project directories.
- `roots`: directories whose immediate subdirectories are projects. A root that does not exist is ignored.

No root or path is configured by default; add at least one before `SUPER + O` has anything to list.

Manage them from a terminal:

```sh
argvus-projects add ~/Work/api          # one project
argvus-projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus-projects remove ~/Work/api       # removes it from paths and roots
argvus-projects list                    # prints the roots and paths
```

If no root or path exists, `SUPER + O` reports that no projects were found. An optional editor command, `/projects/editor`, starts in the same workspace when the workspace is created.

The entries are read from the effective configuration; the launcher keeps no copy of them.

Opening a project also records its path as the active project for the session, which the Dev Dashboard telemetry block (`argvus-widget-telemetry`) reads to report that project's git, listening ports and containers.

The launcher configuration is packaged separately from the shell. `argvus-config` projects the Rofi themes, mode and configuration into `data/generated/rofi/`, so every theme change keeps the menus visually consistent; the launcher itself owns no theme output.

## SSH (`SUPER + ALT + S`)

`SUPER + ALT + S` opens a picker with the hosts defined in `~/.ssh/config`. The selected host opens in a new ARGVUS terminal running `ssh <host>`, in the current workspace.

### Setup

Add a `Host` entry for each server to `~/.ssh/config`:

```sshconfig
Host gitea
    HostName gitea.local
    User boss
    IdentityFile ~/.ssh/gitea_williamcanin
    IdentitiesOnly yes
```

Confirm that `ssh gitea` works in a normal terminal first. The launcher only runs `ssh`; authentication, keys and host verification are handled by OpenSSH.

### Use

1. Press `SUPER + ALT + S`.
2. Type part of the host name, or use the arrow keys.
3. Press `Enter`. The terminal opens and runs `ssh <host>`.

When the session ends, the window stays open and shows the exit status, for example `ssh exited with status 0. Press Enter to close.` Press `Enter` to close it. This matters for forges such as GitHub, GitLab and Gitea: they authenticate you and close the connection right away because they do not provide a shell. The window keeps their message on screen instead of disappearing.

### Rules

- Wildcard entries (`Host *`, `Host *.internal`) are match blocks, not targets, and are never listed.
- Every alias on a `Host` line is listed separately (`Host a b` lists `a` and `b`). Duplicates are removed.
- Hosts defined only in files loaded with `Include` are not listed; the picker reads the main file only.
- Only aliases made of letters, digits, `.`, `-` and `_` are launched. Any other name is refused with a notification.
- Windows line endings (CRLF) in the config are accepted.
- `ARGVUS_SSH_CONFIG` replaces the path of the config file, which is useful for testing.

### Commands

```sh
argvus-ssh list          # prints the configured hosts, one per line
argvus-ssh open gitea    # opens a specific host without the picker
```

### Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| Notification "no hosts found in ~/.ssh/config" | The file is missing or has no `Host` lines. Run `argvus-ssh list` to check. |
| A host is missing from the picker | It is a wildcard, comes from an `Include` file, or has characters outside the allowed set. Put it in the main file with a plain alias. |
| The window shows an error status right away | Run `ssh <host>` in a normal terminal to see the full message (unreachable host, wrong key, and so on). |
| The window shows `message.ssh_session_ended` instead of text | The installed `argvus-i18n` catalog is older than this version. Reinstall `argvus-i18n`. |

Requires `openssh` and `argvus-terminal`.

## Snippets (`SUPER + ALT + N`)

`SUPER + ALT + N` opens a picker with your snippets. The selected snippet is typed into the focused window, at the cursor, instead of going through the clipboard.

### Setup

Add a snippet with a name and its text:

```sh
argvus-snippets add "email" "you@example.com"
```

Check that it was stored:

```sh
argvus-snippets list
```

Snippets are kept in the `snippets` section of `argvus-config`, as `{name, content}` entries. You can read them with `argvus-config get /snippets/items`.

### Use

1. Click into the text field of the application that should receive the text.
2. Press `SUPER + ALT + N`.
3. Select the snippet by name and press `Enter`. The text is typed where the cursor is.

### Commands

```sh
argvus-snippets add "NAME" "CONTENT"   # adds a snippet, or replaces the one with the same name
argvus-snippets remove NAME            # removes a snippet
argvus-snippets list                   # prints index and name, one per line
argvus-snippets open NAME              # types a snippet by name
argvus-snippets open 2                 # types the snippet at position 2 of `list`
argvus-snippets                        # opens the picker (same as the shortcut)
```

### Rules

- Names are unique and case-sensitive. Adding a snippet with an existing name replaces its content.
- The content cannot be empty: an empty snippet is reported as not found.
- `open` treats a name made only of digits as a position. Use names with letters, such as `code2`, to avoid ambiguity.
- A position refers to the order shown by `list`. Removing a snippet shifts the positions of the ones after it.

### Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| Notification "no snippets" when pressing the shortcut | No snippet was added yet. Run `argvus-snippets add` first. |
| `open` reports the snippet was not found | The name does not match exactly. Compare with `argvus-snippets list`. |
| Nothing appears in the application | The focused window is not a text field, or it is an X11 application running under XWayland, which may ignore this kind of input. Test with a native Wayland application. |

Requires `wtype`, `rofi`, `jq` and `argvus-config`.

`wtype` simulates key presses at the Wayland input level. Some X11 applications running under XWayland ignore these events, so the text may not appear there even though the snippet was found.
