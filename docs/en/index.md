---
title: Application launcher
description: Launch applications, open projects, SSH hosts and snippets, pick emoji, calculate, and read cheatsheets through the ARGVUS Rofi menus.
---

`argvus-launcher` provides the Rofi configuration, themes and menus that ARGVUS uses to open things from the keyboard. It contains:

- the application launcher (`SUPER + D`);
- the Rofi configuration and themes shared by every ARGVUS Rofi menu;
- the project switcher, SSH picker and snippet picker (`argvus projects`, `argvus ssh`, `argvus snippets`);
- the SSH key manager (`argvus keys`), which creates, lists, loads and deletes key pairs;
- the GPG key manager (`argvus gpg`), which lists, creates and exports keys and selects the pinentry;
- the emoji picker, the cheatsheet viewer and the calculator menu.

The shortcuts are declared by `argvus-hyprland`. This package provides the commands and the menus behind them.

## Shortcuts

| Shortcut | Action | Command | Section |
| --- | --- | --- | --- |
| `SUPER + D` | Application launcher | `argvus launcher` | Application launcher |
| `SUPER + O` | Project switcher | `argvus projects` | Project switcher |
| `SUPER + ALT + 1` to `9` | Open the project in that position | `argvus projects open N` | Project switcher |
| `SUPER + ALT + S` | SSH host picker | `argvus ssh` | SSH |
| `SUPER + ALT + N` | Snippet picker | `argvus snippets` | Snippets |
| `SUPER + ALT + G` | Project picker, then git TUI | `argvus git` | Git |
| `SUPER + .` | Emoji picker | `emoji-picker.sh` | Emoji picker |
| `SUPER + C` | Calculator | `rofi -show calc` | Calculator |
| `SUPER + SHIFT + /` | Hyprland cheatsheet | `cheatsheets.sh hypr` | Cheatsheets |
| `SUPER + CTRL + /` | Kitty cheatsheet | `cheatsheets.sh kitty` | Cheatsheets |

## Application launcher (`SUPER + D`)

`SUPER + D` runs `argvus launcher`, which opens Rofi in `drun` mode. It lists the graphical applications installed with a desktop entry, and the selected one starts when you press `Enter`.

1. Press `SUPER + D`.
2. Type part of the application name. The list is sorted and the filter ignores case.
3. Press `Enter` to start the application, or `Esc` to close the menu.

```sh
argvus launcher                  # opens the application menu
argvus launcher --config PATH    # uses another Rofi configuration file
```

Any other argument is passed to `rofi`. `--config` without a value stops with an error.

Hyprland runs `argvus launcher --config <Rofi configuration>` when the default launcher is `rofi`, which is the default. If the default `launcher` in the default applications is set to another program, Hyprland runs `<program> --show drun` instead. Set it in the default applications of the Control Center, which stores the value in `argvus-config`.

Only applications with a desktop entry appear in the list. An application that installs no `.desktop` file cannot be found here.

## Rofi configuration and themes

The package installs the Rofi configuration under `/usr/share/argvus/launcher/config/`:

| File | Role |
| --- | --- |
| `config.rasi` | Entry point used by every ARGVUS menu. Sets the Rofi `configuration` (font, no icons, sorted list, case-insensitive matching) and imports `theme.rasi`. |
| `theme.rasi` | Colors and layout of the window, input bar and list. Imports one theme and the mode file. |
| `mode.rasi` | Mode override. The packaged file has no overrides and keeps the Dark mode. |
| `themes/<family>/theme.rasi` | Palette of a theme family, for example `argvus-dark` or `tokyo-night`. |
| `themes/<family>-float/theme.rasi` | Float variant of the same family. |

The package provides 22 families, and each has a `-float` variant. The packaged `theme.rasi` imports `argvus-dark`.

### Where the active configuration lives

ARGVUS resolves each Rofi file through `paths_config`. The first existing file among the user overrides, the user copy, the legacy locations and the generated tree wins; otherwise the packaged file under `/usr/share/argvus/launcher/config/` is used. The user copy of a file is `$XDG_CONFIG_HOME/argvus/data/rofi/<file>`: the `launcher/config/` prefix is stored under `rofi/`.

ARGVUS creates a user copy the first time an ARGVUS script changes that file; `argvus-appearance` does this for theme, accent and mode changes. Files that were never changed keep being read from the package, and a user copy takes precedence over the packaged file.

When `argvus-session` applies the font at session start, it rewrites the `font:` line of `config.rasi` from the ARGVUS font setting. That edit only reaches the user copy. Until the copy exists, the packaged file is the one found, and users cannot write to it, so the font change takes effect once the first appearance change has created the copy.

### Changing the theme

`argvus-appearance` owns theme changes. When the theme changes, it rewrites the user copies so that `config.rasi` points at the new `theme.rasi`, and `theme.rasi` imports the selected family. The Float layout selects the `-float` variant of the active family. Theme pickers such as the theme menu and the layout menu read the same `config.rasi`, so they use the active style too.

Do not edit the files under `/usr/share/argvus/launcher/`; they are replaced on package upgrade. Make changes in the user copy, under `$XDG_CONFIG_HOME/argvus/data/rofi/`.

## Project switcher (`SUPER + O`)

`argvus projects` (`SUPER + O`) lists the projects you added and opens the selected one in its own Hyprland workspace, with an `argvus terminal` in its directory. If the project's workspace already exists, the switcher only focuses it.

For keyboard-only access, `SUPER + ALT + 1` to `SUPER + ALT + 9` open the project in that position of the list, without the menu. The positions are the numbers shown in the menu. They follow the list order, so adding or removing a project can change them. `argvus projects open <number or directory name>` does the same from a terminal, and failures are shown as a notification.

The effective project list is capped at 9, since that is all `SUPER + ALT + 1..9` can address. `argvus projects add` (and the Control Center's Projects page, which calls it) refuses to add a project or root that would push the total past 9, and reports the error instead.

A project comes from two places in the `projects` section of `argvus-config`:

- `paths`: individual project directories.
- `roots`: directories whose immediate subdirectories are projects. A root that does not exist is ignored.

No root or path is configured by default; add at least one before `SUPER + O` has anything to list.

Manage them from a terminal:

```sh
argvus projects add ~/Work/api          # one project
argvus projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus projects remove ~/Work/api       # removes it from paths and roots
argvus projects list                    # prints the roots and paths
```

`argvus projects pick` shows the same list and prints the chosen path instead of opening it. Other tools can use it, as `argvus git` does. Cancelling prints nothing.

If no root or path exists, `SUPER + O` reports that no projects were found. An optional editor command, `/projects/editor`, starts in the same workspace when the workspace is created.

The entries are read from the effective configuration; the launcher keeps no copy of them.

Opening a project also records its path as the active project for the session, which the Dev Dashboard telemetry block (`argvus-widget-telemetry`) reads to report that project's git, listening ports and containers.

## SSH (`SUPER + ALT + S`)

`SUPER + ALT + S` opens a picker with the hosts defined in `~/.ssh/config`. The selected host opens in a new ARGVUS terminal running `ssh <host>`, in the current workspace.

### Setup

Add a `Host` entry for each server to `~/.ssh/config`:

```ini
Host myhost
    HostName myhost.local
    User boss
    IdentityFile ~/.ssh/myhost
    IdentitiesOnly yes
```

Confirm that `ssh myhost` works in a normal terminal first. The launcher only runs `ssh`; authentication, keys and host verification are handled by OpenSSH.

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
argvus ssh list          # prints the configured hosts, one per line
argvus ssh open myhost   # opens a specific host without the picker
```

### Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| Notification "no hosts found in ~/.ssh/config" | The file is missing or has no `Host` lines. Run `argvus ssh list` to check. |
| A host is missing from the picker | It is a wildcard, comes from an `Include` file, or has characters outside the allowed set. Put it in the main file with a plain alias. |
| The window shows an error status right away | Run `ssh <host>` in a normal terminal to see the full message (unreachable host, wrong key, and so on). |
| The window shows `message.ssh_session_ended` instead of text | The installed `argvus-i18n` catalog is older than this version. Reinstall `argvus-i18n`. |

Requires `openssh` and `argvus-terminal`.

## SSH keys (`argvus keys`)

`argvus keys` manages the key pairs in `~/.ssh` and the keys held by the ssh-agent. It has no shortcut. The **SSH keys** page of the Control Center (Applications) uses the same commands.

```sh
argvus keys                              # shows the options and an example
argvus keys list                         # one pair per line: name, type, fingerprint, comment, passphrase, loaded
argvus keys generate NAME                # creates ~/.ssh/NAME as ed25519, without a passphrase
argvus keys generate NAME --type rsa     # RSA with 4096 bits
argvus keys generate NAME --comment C    # comment: letters, digits and . _ @ + -
argvus keys generate NAME --passphrase   # ssh-keygen asks for the passphrase in an ARGVUS terminal
argvus keys load NAME                    # adds the key to the agent; opens an ARGVUS terminal only if it has a passphrase
argvus keys unload NAME                  # removes the key from the agent
argvus keys unload-all                   # removes every key from the agent
argvus keys delete NAME                  # deletes both files; refused while the key is loaded
```

Rules that apply to every command:

- A key name becomes a file name under `~/.ssh`, so it may contain only letters, digits, dot, hyphen and underscore. It cannot start with a dot or end with `.pub`. An existing pair is never overwritten.
- Only pairs with a public file (`NAME.pub`) are listed, and only those can be loaded, unloaded or deleted.
- Passphrases are never passed as command arguments, written to a log or shown in the Control Center. `load` and `generate --passphrase` open an ARGVUS terminal, and OpenSSH reads the secret from that terminal.
- `list` reports `unknown` in the `loaded` column when the agent cannot be reached. It never guesses.
- `delete` removes the private key for good. Keep a copy of any key you still need.
- `ARGVUS_SSH_DIR` replaces `~/.ssh`, which is useful for testing.

The agent is the `argvus-ssh-agent.service` user service started by `argvus-session`. `SSH_AUTH_SOCK` points to it in the session.

Requires `openssh` (`ssh-keygen` and `ssh-add`) and `argvus-terminal`.

| Symptom | Cause and fix |
| --- | --- |
| `load` opens a terminal, but the key is not loaded | Type the passphrase in that terminal. If it was not asked, run `ssh-add -l` to see what the agent holds. |
| The terminal shows `Could not open a connection to your authentication agent` | Hyprland started before the agent did, so its terminals lack `SSH_AUTH_SOCK`. The launcher falls back to `$XDG_RUNTIME_DIR/ssh-agent.socket`, so update `argvus-launcher` and open a new terminal. |
| `list` shows `unknown` in the `loaded` column | The agent is not reachable. Check `systemctl --user status argvus-ssh-agent.service` and the `SSH_AUTH_SOCK` variable. |
| `delete` reports that the key is loaded | Run `argvus keys unload NAME` first, then delete it again. |
| `generate` reports that the name already exists | Choose another name. Existing pairs are never replaced. |

## GPG keys (`argvus gpg`)

`argvus gpg` lists, creates and exports GPG keys, imports public keys and selects the pinentry that `gpg-agent` uses. It has no shortcut. The **GPG keys** page of the Control Center uses the same commands.

```sh
argvus gpg                                         # shows the options and an example
argvus gpg list                                    # one key per line: fingerprint, key id, type, expires, secret, validity, user ID
argvus gpg generate "Name <you@example.com>"       # ed25519 key, expires in 2 years, passphrase asked by the pinentry
argvus gpg generate "Name <you@example.com>" --algo rsa4096 --expire 0
argvus gpg generate "Name <you@example.com>" --no-passphrase --yes   # unprotected private key; --yes is required
argvus gpg export-public you@example.com ~/public.asc   # public key in ASCII armor, mode 600
argvus gpg export-public you@example.com ~/public.asc --force        # replaces an existing file
argvus gpg import ~/colleague.asc                  # imports public keys; private keys are refused
argvus gpg status                                  # gnupg installed, and the pinentry in use (argvus, user or default)
argvus gpg set-pinentry qt --yes                   # writes pinentry-program to gpg-agent.conf; gtk and curses are also accepted
```

Every key gets one certify-and-sign primary key and one encryption subkey, so it can encrypt files as well as sign commits and packages. The subkey uses `cv25519` with ed25519 keys and `rsa4096` with RSA keys.

Rules that apply to every command:

- Passphrases are never passed as command arguments, written to a log or shown in the Control Center. `generate` leaves the passphrase to the pinentry window, which `gpg-agent` opens.
- `--no-passphrase` stores the private key without protection. It is refused unless `--yes` is also given.
- Private keys are never exported. `import` refuses any file that contains a secret key packet, in ASCII or binary form.
- `set-pinentry` only changes the `pinentry-program` line between the `# BEGIN argvus-managed pinentry` and `# END argvus-managed pinentry` markers. The rest of `gpg-agent.conf` is kept. The previous file is saved as `gpg-agent.conf.bak`. The command refuses to run when `gpg-agent.conf` already sets `pinentry-program` outside that block, so you choose which one stays.
- Installing the package never writes to `~/.gnupg`. The configuration changes only when you run `set-pinentry --yes`.
- `GNUPGHOME` replaces `~/.gnupg`, which is useful for testing.

The pinentry choices map to these programs: `qt` to `pinentry-qt`, `gtk` to `pinentry-gtk-2` and `curses` to `pinentry-curses`. The programs must be installed; `set-pinentry` stops with an error when the chosen one is missing.

Requires `gnupg` for the key commands and `pinentry` for the passphrase window.

| Symptom | Cause and fix |
| --- | --- |
| `generate` does not open a passphrase window | Check `argvus gpg status`. The pinentry must be installed and selected with `set-pinentry`, and the session must expose `WAYLAND_DISPLAY` or `DISPLAY`. |
| `set-pinentry` reports a `pinentry-program` line outside the ARGVUS block | Remove that line from `~/.gnupg/gpg-agent.conf`, then run the command again. |
| `generate` reports that the encryption subkey could not be added | The key was created. Add the subkey with `gpg --quick-add-key FINGERPRINT cv25519 encr 2y`, or delete the key with `gpg --delete-secret-and-public-key` and generate it again. |
| `import` refuses a file | The file contains a private key. Export only the public key on the other machine with `argvus gpg export-public`. |
| `list` shows no keys | The keyring in `GNUPGHOME` (or `~/.gnupg`) is empty. Run `argvus gpg generate` to create a key. |

## Snippets (`SUPER + ALT + N`)

`SUPER + ALT + N` opens a picker with your snippets. The selected snippet is typed into the focused window, at the cursor, instead of going through the clipboard.

### Setup

Add a snippet with a name and its text:

```sh
argvus snippets add "email" "you@example.com"
```

Check that it was stored:

```sh
argvus snippets list
```

Snippets are kept in the `snippets` section of `argvus config`, as `{name, content}` entries. You can read them with `argvus config get /snippets/items`.

### Use

1. Click into the text field of the application that should receive the text.
2. Press `SUPER + ALT + N`.
3. Select the snippet by name and press `Enter`. The text is typed where the cursor is.

### Commands

```sh
argvus snippets add "NAME" "CONTENT"   # adds a snippet, or replaces the one with the same name
argvus snippets remove NAME            # removes a snippet
argvus snippets list                   # prints index and name, one per line
argvus snippets open NAME              # types a snippet by name
argvus snippets open 2                 # types the snippet at position 2 of `list`
argvus snippets                        # opens the picker (same as the shortcut)
argvus snippets --help                 # shows the options and an example
```

### Rules

- Names are unique and case-sensitive. Adding a snippet with an existing name replaces its content.
- The content cannot be empty: an empty snippet is reported as not found.
- `open` treats a name made only of digits as a position. Use names with letters, such as `code2`, to avoid ambiguity.
- A position refers to the order shown by `list`. Removing a snippet shifts the positions of the ones after it.

### Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| Notification "no snippets" when pressing the shortcut | No snippet was added yet. Run `argvus snippets add` first. |
| `open` reports the snippet was not found | The name does not match exactly. Compare with `argvus snippets list`. |
| Nothing appears in the application | The focused window is not a text field, or it is an X11 application running under XWayland, which may ignore this kind of input. Test with a native Wayland application. |

Requires `wtype`, `rofi`, `jq` and `argvus-config`.

`wtype` simulates key presses at the Wayland input level. Some X11 applications running under XWayland ignore these events, so the text may not appear there even though the snippet was found.

## Git (`SUPER + ALT + G`)

`SUPER + ALT + G` opens the same project picker as `SUPER + O`. Choosing a project opens `lazygit` (or `gitui`) directly in it, in a new ARGVUS terminal on the current workspace. There is no separate step to pick the project first.

### Setup

Install one of the two tools. Both are optional dependencies of this package:

```sh
sudo pacman -S lazygit   # or: sudo pacman -S gitui
```

### Use

1. Press `SUPER + ALT + G`.
2. Pick a project in the list, or press `Esc` to cancel. Cancelling opens nothing.
3. The terminal opens in the project directory and starts the TUI.

A project that is not a git repository shows a notification and opens nothing. To skip the picker, pass a directory:

```sh
argvus git ~/Projects/api
```

### Choosing the tool

`argvus-git` uses `lazygit` when it is installed, and `gitui` otherwise. To prefer `gitui`, set `ARGVUS_GIT_TUI` for the command:

```sh
ARGVUS_GIT_TUI=gitui argvus git
```

The variable is read from the environment of the command that runs the script. It is not stored in ARGVUS configuration.

### Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| Notification "not a git repository" | The chosen project is not a git repository, or its directory was moved. Remove or fix it with `argvus projects remove`. |
| Notification "install lazygit or gitui" | Neither tool is on the `PATH`. Install one of them. |
| Picker shows no projects | No project was added. Use `argvus projects add`. |

## Emoji picker (`SUPER + .`)

`SUPER + .` opens `rofimoji` with the ARGVUS Rofi configuration. Search for an emoji by name, press `Enter`, and the emoji is copied to the clipboard. Paste it with `Ctrl + V` in the application you want.

While the picker is open, the session ignores the keyboard-layout notifications it would otherwise show. The launcher writes a short-lived marker in the ARGVUS cache directory and removes it about one second after the picker closes.

Requires `rofimoji` and `wl-clipboard`.

## Calculator (`SUPER + C`)

`SUPER + C` opens the `calc` mode of Rofi with the ARGVUS Rofi configuration. Type an expression, and the result list updates as you type. Choose a result as the `rofi-calc` mode defines.

The launcher package provides the Rofi configuration and depends on `rofi-calc`. The shortcut itself is declared by `argvus-hyprland`.

## Cheatsheets (`SUPER + SHIFT + /` and `SUPER + CTRL + /`)

`cheatsheets.sh` shows a read-only list of shortcuts in a large Rofi window. It takes the application name as its argument:

```sh
cheatsheets.sh hypr     # Hyprland shortcuts (SUPER + SHIFT + /)
cheatsheets.sh kitty    # terminal shortcuts (SUPER + CTRL + /)
cheatsheets.sh <name>   # any other application with a cheatsheet
```

- `hypr` uses `data/generated/hypr/keybindings.txt` from the user's ARGVUS configuration when that file exists. Otherwise it uses the Hyprland cheatsheet shipped with `argvus-hyprland`.
- `kitty` uses the terminal cheatsheet shipped with `argvus-terminal`.
- Any other name reads `<name>/docs/cheatsheets/<language>.txt`. If that file does not exist, no window opens.

The language is Portuguese when the system locale is `pt-BR`, and English otherwise. `Esc` closes the window. Selecting a line only closes it; nothing is executed.

## Other menus that use the Rofi configuration

The launcher configuration is shared with components owned by other packages:

- Clipboard history (`SUPER + H`) and its clear shortcut (`SUPER + SHIFT + H`) are declared by `argvus-hyprland`. They pipe `cliphist` into Rofi with this configuration. `cliphist` comes from `argvus-session`, which runs the clipboard recorder that fills the history; the `argvus` meta-package depends on it too.
- Theme, accent and layout pickers in `argvus-appearance` open Rofi with `config.rasi`.
- The Hyprland window rules recognize the `argvus-launcher` and `rofi` namespaces, so the menus receive the launcher surface treatment.

## Packaging and dependencies

The package `argvus-launcher` is architecture-independent and installs:

- `/usr/lib/argvus/commands/argvus-launcher`, `argvus-projects`, `argvus-snippets`, `argvus-ssh`, `argvus-keys`, `argvus-gpg` and `argvus-git`, under the same directory;
- `/usr/share/argvus/launcher/config/`, with the Rofi configuration and themes;
- `/usr/share/argvus/launcher/sh/`, with `cheatsheets.sh` and `emoji-picker.sh`.

Required dependencies: `argvus-session`, `argvus-appearance`, `argvus-config`, `argvus-i18n`, `argvus-terminal`, `bash`, `jq`, `hyprland`, `libnotify`, `rofi`, `rofi-calc`, `rofimoji`, `wl-clipboard` and `wtype`. Optional dependencies: `openssh`, for the SSH picker and the SSH key manager; `gnupg` and `pinentry`, for the GPG key manager; `lazygit` and `gitui`, for the git TUI.

Installing the package does not write into `$HOME`. User configuration is created at session start, as described in [Rofi configuration and themes](#where-the-active-configuration-lives).

## Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| `SUPER + D` opens nothing | Check `argvus launcher` in a terminal. Confirm that `rofi` is installed and that the Rofi configuration exists. |
| `SUPER + D` lists no applications | The applications have no desktop entry. Only applications with a `.desktop` file are shown. |
| The menus use an old font | The `font:` line is rewritten at session start. Restart the session after changing the font. |
| A theme change does not reach the Rofi menus | Check whether the user copy of `config.rasi` in `$XDG_CONFIG_HOME/argvus/data/rofi/` still points to the packaged theme. Apply the theme from `argvus-appearance` again. |
| `SUPER + O` reports that no projects were found | No root or path is configured, or the directories no longer exist. Run `argvus projects list`. |
| `SUPER + C` or the emoji picker does not open | Install `rofi-calc` or `rofimoji` (both are required dependencies). |
| A cheatsheet does not open | The file for that name and language does not exist. Check the paths described in the Cheatsheets section. |
| `SUPER + H` shows nothing | The history is empty, or the clipboard recorder from `argvus-session` has not stored anything yet. |

## Related components

| Component | Responsibility |
| --- | --- |
| `argvus-hyprland` | Declares the shortcuts and the Hyprland window rules for the menus. |
| `argvus-appearance` | Changes the active theme, accent and layout, and rewrites the Rofi theme references. |
| `argvus-config` | Stores the projects, the snippets and the default launcher setting. |
| `argvus-session` | Copies the initial Rofi configuration and sets its font at session start. |
| `argvus-terminal` | Opens SSH sessions, project terminals and the passphrase prompts of `argvus keys`. |
| `argvus-widget-telemetry` | Reads the active project written by `argvus projects`. |
| `argvus-i18n` | Provides the translated messages used by the launcher scripts. |
| `argvus-control-center` | Edits the project list through `argvus projects`. |
