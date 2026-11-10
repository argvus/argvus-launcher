---
title: 应用启动器
description: 通过 ARGVUS Rofi 菜单启动应用程序、打开项目、SSH 主机和代码片段、选择表情符号、进行计算以及阅读速查表。
---
`argvus-launcher` 提供了 ARGVUS 用于从键盘打开内容的 Rofi 配置、主题和菜单。它包含：

- 应用启动器（`SUPER + D`）；
- 每个 ARGVUS Rofi 菜单共享的 Rofi 配置和主题；
- 项目切换器、SSH 选择器和代码片段选择器（`argvus projects`、`argvus ssh`、`argvus snippets`）；
- SSH 密钥管理器（`argvus keys`），用于创建、列出、加载和删除密钥对；
- GPG 密钥管理器（`argvus gpg`），用于列出、创建和导出密钥，并为 gpg-agent 设置 pinentry-gtk；
- 表情符号选择器、备忘单查看器和计算器菜单。

快捷键由 `argvus-hyprland` 声明。该软件包提供这些命令及其背后的菜单。

## 快捷键

| 快捷键 | 操作 | 命令 | 部分 |
| --- | --- | --- | --- |
| `SUPER + D` | 应用启动器 | `argvus launcher` | 应用启动器 |
| `SUPER + O` | 项目切换器 | `argvus projects` | 项目切换器 |
| `SUPER + ALT + 1` 到 `9` | 打开该位置的项目 | `argvus projects open N` | 项目切换器 |
| `SUPER + ALT + S` | SSH 主机选择器 | `argvus ssh` | SSH |
| `SUPER + ALT + N` | 代码片段选择器 | `argvus snippets` | 代码片段 |
| `SUPER + ALT + G` | 项目选择器，然后使用 git TUI | `argvus git` | Git |
| `SUPER + .` | 表情符号选择器 | `emoji-picker.sh` | 表情符号选择器 |
| `SUPER + C` | 计算器 | `rofi -show calc` | 计算器 |
| `SUPER + SHIFT + /` | Hyprland 速查表 | `cheatsheets.sh hypr` | 速查表 |
| `SUPER + CTRL + /` | Kitty 速查表 | `cheatsheets.sh kitty` | 速查表 |

## 应用启动器 (`SUPER + D`)

`SUPER + D` 运行 `argvus launcher`，它以 `drun` 模式打开 Rofi。它列出了使用桌面条目安装的图形应用程序，按下 `Enter` 时会启动所选的应用程序。

1. 按下 `SUPER + D`。
2. 输入应用程序名称的一部分。列表会排序，筛选器不区分大小写。
3. 按下 `Enter` 启动应用程序，或按 `Esc` 关闭菜单。

```sh
argvus launcher                  # opens the application menu
argvus launcher --config PATH    # uses another Rofi configuration file
```
任何其他参数都会传递给 `rofi`。`--config` 如果没有值则会报错。

当默认启动器是 rofi（默认设置）时，Hyprland 会运行 `argvus launcher --config <Rofi configuration>`。如果默认应用中的默认  `rofi` `launcher` 被设置为其他程序，则 Hyprland 会运行 `<program> --show drun`。请在控制中心的默认应用中设置，它会将值存储在 `argvus-config` 中。

只有具有桌面条目的应用才会出现在列表中。未安装 `.desktop` 文件的应用无法在此处找到。

## Rofi 配置和主题

该软件包将 Rofi 配置安装在 `/usr/share/argvus/launcher/config/` 下：

| 文件 | 角色 |
| --- | --- |
| `config.rasi` | 每个 ARGVUS 菜单使用的入口点。设置 Rofi `configuration`（字体，无图标，排序列表，大小写不敏感匹配）并导入 `theme.rasi`。 |
| `theme.rasi` | 窗口、输入栏和列表的颜色和布局。导入一个主题和模式文件。 |
| `mode.rasi` | 模式覆盖。打包文件没有覆盖，保持暗模式。 |
| `themes/<family>/theme.rasi` | 主题家族的调色板，例如 `argvus-dark` 或 `tokyo-night`。 |
| `themes/<family>-spaced/theme.rasi` | 同一主题家族的间距变体。 |

该软件包提供 22 个家族，每个家族都有一个 `-spaced` 变体。打包的 `theme.rasi` 导入 `argvus-dark`。

### 活跃配置存放位置

ARGVUS 通过 `paths_config` 解析每个 Rofi 文件。在用户覆盖、用户副本、旧有位置和生成的树中，第一个存在的文件优先；否则使用 `/usr/share/argvus/launcher/config/` 下的打包文件。文件的用户副本是 `$XDG_CONFIG_HOME/argvus/data/rofi/<file>`：`launcher/config/` 前缀存储在 `rofi/` 下。

ARGVUS 在 ARGVUS 脚本第一次更改该文件时创建用户副本；`argvus-appearance` 处理主题、强调色和模式的更改。未被更改的文件继续从包中读取，而用户副本优先于打包文件。

当 `argvus-session` 在会话开始时应用字体时，它会根据 ARGVUS 字体设置重写 config.rasi 的 `font:` 行。该编辑仅影响用户副本。在副本存在之前，找到的是打包文件，用户无法写入，因此字体更改在首次外观更改创建副本后才生效。

### 更改主题

 `config.rasi` `argvus-appearance` 拥有主题更改功能。当主题更改时，它会重写用户副本，使 `config.rasi` 指向新的 `theme.rasi`，并且 `theme.rasi` 导入主题构建（`~/.config/argvus/data/generated/theme/current/launcher/theme.rasi`）的启动器调色板，该调色板包含活动的字体、布局和高亮颜色。如果没有主题构建，它会导入字体副本，而间隔布局会选择活动字体的 `-spaced` 变体。主题选择器，例如主题菜单和布局菜单，读取相同的 `config.rasi`，因此它们也使用活动样式。

不要编辑 `/usr/share/argvus/launcher/` 下的文件；它们会在软件包升级时被替换。在用户副本中进行更改，路径为 `$XDG_CONFIG_HOME/argvus/data/rofi/`。

## 项目切换器（`SUPER + O`）

`argvus projects`（`SUPER + O`）列出你添加的项目，并在它自己的 Hyprland 工作区中打开所选项目，其目录中有一个 `argvus terminal`。如果项目的工作区已存在，切换器只会将其聚焦。

对于仅使用键盘访问，`SUPER + ALT + 1` 到 `SUPER + ALT + 9` 可以在列表中的该位置打开项目，而无需菜单。位置是菜单中显示的数字。它们遵循列表顺序，因此添加或删除项目可能会改变这些位置。`argvus projects open <number or directory name>` 可从终端执行相同操作，失败会显示为通知。

实际的项目列表上限为 9，因为 `SUPER + ALT + 1..9` 只能处理这么多。`argvus projects add`（以及调用它的控制中心的项目页面）会拒绝添加会使总数超过 9 的项目或根，并报告错误。

一个项目来自 argvus-config 的 `projects` 部分的两个位置：

-  `argvus-config` `paths`：单个项目目录。
- `roots`：其直接子目录是项目的目录。不存在的根目录将被忽略。

默认情况下没有配置任何根目录或路径；在 `SUPER + O` 可以列出任何内容之前，至少添加一个。

可以通过终端进行管理：

```sh
argvus projects add ~/Work/api          # one project
argvus projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus projects remove ~/Work/api       # removes it from paths and roots
argvus projects list                    # prints the roots and paths
```
`argvus projects pick` 显示相同的列表并打印所选路径，而不是打开它。其他工具可以使用它，就像 `argvus git` 一样。取消不会打印任何内容。

如果没有根目录或路径存在，`SUPER + O` 会报告未找到项目。一个可选的编辑器命令 `/projects/editor` 会在创建工作区时在相同的工作区中启动。

这些条目是从有效配置中读取的；启动器不会保留它们的副本。

打开一个项目也会将其路径记录为该会话的活动项目，Dev Dashboard 遥测模块 (`argvus widget-telemetry`) 会读取它以报告该项目的 git、监听端口和容器。

## SSH (`SUPER + ALT + S`)

`SUPER + ALT + S` 会打开一个选择器，显示在 `~/.ssh/config` 中定义的主机。所选主机会在当前工作区中以运行 `ssh <host>` 的新 ARGVUS 终端中打开。

### 设置

为每个服务器在 ~/.ssh/config 中添加一个 `Host` 条目:

```ini
Host myhost
    HostName myhost.local
    User boss
    IdentityFile ~/.ssh/myhost
    IdentitiesOnly yes
```
首先确认  `~/.ssh/config` `ssh myhost` 可以在普通终端中工作。启动器只运行 `ssh`；认证、密钥和主机验证由 OpenSSH 处理。

### 使用方法

1. 按 `SUPER + ALT + S`。
2. 输入主机名的一部分，或使用箭头键。
3. 按 `Enter`。终端会打开并运行 `ssh <host>`。

当会话结束时，窗口保持打开状态并显示退出状态，例如 `ssh exited with status 0. Press Enter to close.`。按 `Enter` 以关闭它。这对于 GitHub、GitLab 和 Gitea 之类的代码托管平台很重要：它们会进行身份验证并立即关闭连接，因为它们不提供 shell。窗口会保留它们的消息在屏幕上，而不是消失。

### 规则

- 通配符条目（`Host *`, `Host *.internal`）是匹配块，而不是目标，并且从不列出。
- `Host` 行上的每个别名都单独列出（`Host a b` 列出 `a` 和 `b`）。重复项会被删除。
- 仅在通过 `Include` 加载的文件中定义的主机不会列出；选择器只读取主文件。
- 仅启动由字母、数字、`.`、`-` 和 `_` 组成的别名。任何其他名称都会被拒绝，并显示通知。
- 配置中的 Windows 行结尾（CRLF）被接受。
- `ARGVUS_SSH_CONFIG` 替换配置文件的路径，这对于测试很有用。

### 命令

```sh
argvus ssh list          # prints the configured hosts, one per line
argvus ssh open myhost   # opens a specific host without the picker
```
### 故障排除

| 症状 | 原因及解决方法 |
| --- | --- |
| 通知“在 ~/.ssh/config 中未找到主机” | 文件缺失或没有 `Host` 行。运行 `argvus ssh list` 检查。 |
| 选择器中缺少主机 | 它是通配符，来自 `Include` 文件，或包含不允许的字符。将其放入主文件中并使用普通别名。 |
| 窗口立即显示错误状态 | 在普通终端运行 `ssh <host>` 查看完整信息（不可访问的主机、错误的密钥等）。 |
| 窗口显示 `message.ssh_session_ended` 而不是文本 | 安装的 `argvus` 包版本比当前版本旧。更新 `argvus`。 |

需要 `openssh` 和 `argvus`（`argvus terminal` 命令）。

## SSH 密钥 (`argvus keys`)

`argvus keys` 管理 `~/.ssh` 中的密钥对以及 ssh-agent 持有的密钥。它没有快捷方式。控制中心（应用程序）的 **SSH 密钥** 页面使用相同命令。

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
适用于每个命令的规则：

- 键名会成为 `~/.ssh` 下的文件名，因此它只能包含字母、数字、点、连字符和下划线。它不能以点开头或以 `.pub` 结尾。已存在的键值对不会被覆盖。
- 只有拥有公共文件（`NAME.pub`）的键值对会被列出，且只有这些键值对可以被加载、卸载或删除。
- 密码短语从不作为命令参数传递，也不会写入日志或显示在控制中心。`load` 和 `generate --passphrase` 会打开一个 ARGVUS 终端，OpenSSH 会从该终端读取密钥。
- 当代理不可访问时，`list` 会在 loaded 列报告 `unknown`。它从不进行猜测。
-  `loaded` `delete` 会永久删除私钥。请保留任何仍需使用的密钥副本。
- `ARGVUS_SSH_DIR` 替换 `~/.ssh`，这对于测试非常有用。

代理是由 argvus-session 启动的 `argvus-ssh-agent.service` 用户服务。 `argvus-session` `SSH_AUTH_SOCK` 在会话中指向它。

需要 `openssh`（`ssh-keygen` 和 `ssh-add`）以及 `argvus`（`argvus terminal` 命令）。

| 症状 | 原因与解决方法 |
| --- | --- |
| `load` 打开终端，但密钥未加载 | 在该终端中输入密码短语。如果未提示，请运行 `ssh-add -l` 查看代理持有的内容。 |
| 终端显示 `Could not open a connection to your authentication agent` | Hyprland 在代理启动之前已启动，因此其终端缺少 `SSH_AUTH_SOCK`。启动器回退到 `$XDG_RUNTIME_DIR/ssh-agent.socket`，因此请更新 `argvus-launcher` 并打开新终端。 |
| `list` 在 loaded 列中显示 `unknown` | 代理无法访问。检查  `loaded` `systemctl --user status argvus-ssh-agent.service` 和 `SSH_AUTH_SOCK` 变量。 |
| `delete` 报告密钥已加载 | 先运行 `argvus keys unload NAME`，然后再次删除它。 |
| `generate` 报告名称已存在 | 选择另一个名称。现有密钥对永远不会被替换。 |

## GPG 密钥 (`argvus gpg`)

`argvus gpg` 列出、创建并导出 GPG 密钥，并导入公钥。gpg-agent 总是使用 `pinentry-gtk`：ARGVUS 在生成密钥之前将 pinentry 写入 `gpg-agent.conf`。它没有快捷方式。控制中心的 **GPG 密钥** 页面使用相同的命令。

```sh
argvus gpg                                         # shows the options and an example
argvus gpg list                                    # one key per line: fingerprint, key id, type, expires, secret, validity, user ID
argvus gpg generate "Name <you@example.com>"       # RSA 4096 key, expires in 2 years, the pinentry asks for the passphrase
argvus gpg generate "Name <you@example.com>" --algo dsa --bits 2048 --expire 2031-06-30
argvus gpg generate "Name <you@example.com>" --expire 0                        # never expires
printf '%s\n' "$PASSPHRASE" | argvus gpg generate "Name <you@example.com>" --passphrase-stdin
argvus gpg generate "Name <you@example.com>" --no-passphrase --yes   # unprotected private key; --yes is required
argvus gpg export-public you@example.com ~/public.asc   # public key in ASCII armor, mode 600
argvus gpg export-public you@example.com ~/public.asc --force        # replaces an existing file
argvus gpg import ~/colleague.asc                  # imports public keys; private keys are refused
argvus gpg status                                  # gnupg installed, and the pinentry in use (argvus, user or default)
argvus gpg export-public you@example.com -          # prints the public key to standard output (used by the copy action)
argvus gpg export-private FINGERPRINT ~/private.asc --yes   # private key in ASCII armor, mode 600; --yes is required
argvus gpg import-private ~/private.asc            # imports a file that holds a private key
argvus gpg delete FINGERPRINT --yes               # deletes the key and its secret part; --yes is required
argvus gpg edit expire FINGERPRINT 2y              # new expiry for the key and each subkey (0, Nd/Nw/Nm/Ny or YYYY-MM-DD)
argvus gpg edit passwd FINGERPRINT                 # changes the passphrase; the pinentry asks for the old and the new one
argvus gpg edit sign FINGERPRINT SIGNER --yes     # certifies the key with the secret key of SIGNER
argvus gpg edit revoke FINGERPRINT --reason unused --yes   # revokes; reason none, compromised, superseded or unused
argvus gpg edit trust FINGERPRINT full            # trust none, marginal, full or ultimate
argvus gpg keyserver send FINGERPRINT --yes       # publishes the key to the keyserver set in gpg.conf
argvus gpg keyserver recv FINGERPRINT             # fetches the key from that keyserver
```
`generate` 接受以下选项：

- `--algo rsa|dsa` 选择密钥算法。默认值为 `rsa`。
- `--bits` 选择密钥长度。RSA 接受 `1024`、`2048`、`3072` 和 `4096`，默认值为 `4096`。DSA 接受 `1024`、`2048` 和 `3072`，默认值为 `2048`；gpg 无法创建更大的 DSA 密钥，因此 `4096` 在 gpg 运行前会被拒绝。
- `--expire` 取 `0` 表示无限期有效，或者一个数字后跟 `d`、`w`、`m` 或 `y`（例如 `2y`），或者一个 ISO 日期 `YYYY-MM-DD`，该日期必须是真实的日期。
- `--passphrase-stdin` 从标准输入的第一行读取密码短语。控制中心使用它。空行会被拒绝。
- `--no-passphrase --yes` 创建一个无保护的密钥。这两种密码短语模式不能组合使用。

每个密钥都有一个认证和签名的主密钥和一个加密子密钥，因此它可以加密文件，也可以签署提交和软件包。子密钥与主密钥匹配：RSA 的主密钥为 `rsa` 并且大小相同，DSA 的主密钥为 `elg` 并且大小相同，这是 DSA 标准要求的配对。

适用于每个命令的规则：

- 密码短语从不作为命令参数传递，也不会写入日志或显示在控制中心。使用 `--passphrase-stdin` 时，密码短语通过管道传递给文件描述符 0 上的 gpg。没有该选项时，gpg 会调用 pinentry 窗口，`gpg-agent` 会打开该窗口。
- `--no-passphrase` 存储私钥时不进行保护。除非同时提供 `--yes`，否则将被拒绝。
- `import` 会拒绝包含秘密密钥包的任何文件，无论是 ASCII 还是二进制格式。私钥只通过 `export-private` 离开密钥环，这需要 `--yes` 并使用写模式 `600`；`import-private` 可以将它们导入回来。
- 修改或发布密钥的命令（`export-private`、`delete`、`edit sign`、`edit revoke`、`keyserver send`）需要 `--yes`。控制中心仅在自身确认后传递它。 
- 使用密钥的命令运行 gpg 时附带 `--no-tty`，因此 gpg 从不尝试打开终端。密码短语来自 pinentry 窗口，除非在 `generate --passphrase-stdin` 中。 
- `generate` 使 gpg-agent 使用 `pinentry-gtk`。它在 `# BEGIN argvus-managed pinentry` 和 `# END argvus-managed pinentry` 标记之间写入该行，保留 `gpg-agent.conf` 的其余部分，并将之前的文件保存为 `gpg-agent.conf.bak`。当该块已经命名为 `pinentry-gtk` 时，文件和 gpg-agent 保持原样。当 `gpg-agent.conf` 已经在该块外设置了 `pinentry-program` 时，该命令拒绝运行，以确保两个值永不冲突。
- 安装该软件包从不会写入 `~/.gnupg`。配置只会在生成密钥时更改。
- `GNUPGHOME` 替代 `~/.gnupg`，这对于测试很有用。

`gnupg` 和 `pinentry` 是必要的依赖项：密钥命令需要 gpg，并且密码短语窗口是 `pinentry-gtk`。

| 症状 | 原因与解决方法 |
| --- | --- |
| `generate` 无法打开密码短语窗口 | 检查 `argvus gpg status`。`pinentry-gtk` 必须已安装，并且会话必须暴露 `WAYLAND_DISPLAY` 或 `DISPLAY`。 |
| `generate` 报告 `pinentry-gtk` 未安装 | 安装 `pinentry` 软件包。 |
| `generate` 报告在 ARGVUS 块外有一行 `pinentry-program` | 从 `~/.gnupg/gpg-agent.conf` 中删除该行，然后再次运行命令。 |
| `generate` 报告密钥大小不受支持 | 检查算法的大小：DSA 最大为 3072 位。 |
| `generate` 报告加密子密钥无法添加 | 密钥已创建。使用 `gpg --quick-add-key FINGERPRINT cv25519 encr 2y` 添加子密钥，或使用 `gpg --delete-secret-and-public-key` 删除密钥并重新生成。 |
| `import` 拒绝一个文件 | 该文件包含私钥。在另一台机器上仅使用 `argvus gpg export-public` 导出公钥。 |
| `list` 没有显示任何密钥 | `GNUPGHOME`（或 `~/.gnupg`）中的密钥环为空。运行 `argvus gpg generate` 来创建密钥。 |

## 片段 (`SUPER + ALT + N`)

`SUPER + ALT + N` 打开一个带有你的片段的选择器。选中的片段会在光标处输入到聚焦的窗口中，而不是通过剪贴板。 

### 设置

添加一个具有名称及文本的片段：

```sh
argvus snippets add "email" "you@example.com"
```
检查它是否已被存储：

```sh
argvus snippets list
```
代码片段保存在 `snippets` 部分的 `argvus config` 中，作为 `{name, content}` 条目。您可以使用 `argvus config get /snippets/items` 来读取它们。

### 使用方法

1. 点击应用程序中应接收文本的文本字段。
2. 按下 `SUPER + ALT + N`。
3. 按名称选择代码片段并按 `Enter`。文本会在光标处输入。

### 命令

```sh
argvus snippets add "NAME" "CONTENT"   # adds a snippet, or replaces the one with the same name
argvus snippets remove NAME            # removes a snippet
argvus snippets list                   # prints index and name, one per line
argvus snippets open NAME              # types a snippet by name
argvus snippets open 2                 # types the snippet at position 2 of `list`
argvus snippets                        # opens the picker (same as the shortcut)
argvus snippets --help                 # shows the options and an example
```
### 规则

- 名称是唯一的且区分大小写。添加已有名称的代码片段会替换其内容。
- 内容不能为空：空的代码片段会被报告为未找到。
- `open` 将仅由数字组成的名称视为位置。请使用包含字母的名称，例如 `code2`，以避免歧义。
- 位置指 `list` 所显示的顺序。删除一个代码片段会使其后的代码片段位置发生变化。

### 疑难解答

| 症状 | 原因及解决方法 |
| --- | --- |
| 按下快捷键时显示“没有代码片段”通知 | 尚未添加任何代码片段。请先运行 `argvus snippets add`。 |
| `open` 报告未找到代码片段 | 名称不完全匹配。与 `argvus snippets list` 比对。 |
| 应用中没有显示任何内容 | 当前焦点窗口不是文本字段，或是在 XWayland 下运行的 X11 应用程序，它可能会忽略此类输入。请在原生 Wayland 应用中测试。 |

需要 `wtype`、`rofi`、`jq` 和 `argvus`（`argvus config` 命令）。

`wtype` 在 Wayland 输入级别模拟按键。一些在 XWayland 下运行的 X11 应用可能会忽略这些事件，因此即使找到了代码段，文本也可能不会显示在那里。

## Git（`SUPER + ALT + G`）

`SUPER + ALT + G` 打开与 `SUPER + O` 相同的项目选择器。选择项目会直接在当前工作区的新 ARGVUS 终端中打开 `lazygit`（或 `gitui`）。没有单独的步骤先选择项目。

### 设置

安装这两个工具中的一个。两者都是此包的可选依赖项：

```sh
sudo pacman -S lazygit   # or: sudo pacman -S gitui
```
### 使用方法

1. 按 `SUPER + ALT + G`。
2. 在列表中选择一个项目，或按 `Esc` 取消。取消不会打开任何内容。
3. 终端将在项目目录中打开并启动 TUI。

非 git 仓库的项目会显示通知并且不会打开任何内容。要跳过选择器，请传入一个目录：

```sh
argvus git ~/Projects/api
```
### 选择工具

`argvus-git` 在安装时使用 `lazygit`，否则使用 `gitui`。要优先使用 `gitui`，请为该命令设置 `ARGVUS_GIT_TUI`：

```sh
ARGVUS_GIT_TUI=gitui argvus git
```
该变量是从运行脚本的命令环境中读取的。它不会存储在 ARGVUS 配置中。

### 故障排除

| 现象 | 原因及解决方法 |
| --- | --- |
| 通知“不是 git 仓库” | 所选项目不是 git 仓库，或其目录已被移动。使用 `argvus projects remove` 删除或修复它。 |
| 通知“安装 lazygit 或 gitui” | `PATH` 上没有安装这两种工具。安装其中之一。 |
| 选择器未显示项目 | 没有添加任何项目。使用 `argvus projects add` 添加。 |

## 表情符号选择器 (`SUPER + .`)

`SUPER + .` 使用 ARGVUS Rofi 配置打开 `rofimoji`。通过名称搜索表情符号，按 `Enter`，然后表情符号将被复制到剪贴板。在需要的应用程序中使用 `Ctrl + V` 粘贴。

当选择器打开时，会话会忽略它本应显示的键盘布局通知。启动器会在 ARGVUS 缓存目录中写入一个短期存在的标记，并在选择器关闭约一秒后将其移除。

需要 `rofimoji` 和 `wl-clipboard`。

## 计算器 (`SUPER + C`)

`SUPER + C` 使用 ARGVUS Rofi 配置打开 Rofi 的 `calc` 模式。输入一个表达式，结果列表会在你输入时更新。根据 `rofi-calc` 模式选择一个结果。

启动器包提供了 Rofi 配置，并依赖于 `rofi-calc`。快捷方式本身由 `argvus-hyprland` 声明。

## 速查表 (`SUPER + SHIFT + /` 和 `SUPER + CTRL + /`)

`cheatsheets.sh` 在一个大型 Rofi 窗口中显示只读快捷方式列表。它将应用程序名称作为参数:

```sh
cheatsheets.sh hypr     # Hyprland shortcuts (SUPER + SHIFT + /)
cheatsheets.sh kitty    # terminal shortcuts (SUPER + CTRL + /)
cheatsheets.sh <name>   # any other application with a cheatsheet
```

- `hypr` 在该文件存在时使用用户的 ARGVUS 配置中的 `data/generated/hypr/keybindings.txt`。否则，它使用随 `argvus-hyprland` 提供的 Hyprland 备忘单。
- `kitty` 使用随 `argvus` 提供的终端备忘单。
- 任何其他名称都会读取 `<name>/docs/cheatsheets/<language>.txt`。如果该文件不存在，则不会打开窗口。

当系统区域设置为 `pt-BR` 时，语言为葡萄牙语，否则为英语。`Esc` 关闭窗口。选择一行仅会关闭它；不会执行任何操作。

## 使用 Rofi 配置的其他菜单

启动器配置与其他软件包拥有的组件共享：

- 剪贴板历史记录 (`SUPER + H`) 及其清除快捷键 (`SUPER + SHIFT + H`) 由 `argvus-hyprland` 声明。它们将 `cliphist` 通过此配置传递给 Rofi。`cliphist` 来源于 `argvus-session`，该程序运行剪贴板记录器以填充历史记录；`argvus` 元包也依赖它。
- `argvus-appearance` 中的主题、强调色和布局选择器会使用 `config.rasi` 打开 Rofi。
- Hyprland 窗口规则识别 `argvus-launcher` 和 `rofi` 命名空间，因此菜单会获得启动器表面处理。

## 打包和依赖关系

包 `argvus-launcher` 与架构无关，并安装：

- `argvus launcher`、`argvus-snippets`、`argvus-ssh` 和 `argvus-git`，在同一目录下；
- `/usr/share/argvus/launcher/config/`，包含 Rofi 配置和主题；
- `/usr/share/argvus/launcher/sh/`，包含 `cheatsheets.sh` 和 `emoji-picker.sh`。

所需依赖项：`argvus-session`、`argvus-appearance`、`argvus`、`bash`、`jq`、`hyprland`、`libnotify`、`rofi`、`rofi-calc`、`rofimoji`、`wl-clipboard`、`wtype`、`gnupg` 和 `pinentry`（提供 `pinentry-gtk`）。可选依赖项：`openssh`，用于 SSH 选择器和 SSH 密钥管理器；`lazygit` 和 `gitui`，用于 git TUI。

安装此软件包不会写入 `$HOME`。用户配置会在会话开始时创建，如 [Rofi 配置和主题](#where-the-active-configuration-lives) 所述。

## 故障排解

| 症状 | 原因与解决方法 |
| --- | --- |
| `SUPER + D` 什么也没打开 | 在终端中检查 `argvus launcher`。确认 `rofi` 已安装，并且 Rofi 配置存在。 |
| `SUPER + D` 未列出应用程序 | 应用程序没有桌面条目。只有具有 `.desktop` 文件的应用程序会显示。 |
| 菜单使用了旧字体 | `font:` 行在会话开始时会被重写。更改字体后请重启会话。 |
| 主题更改没有应用到 Rofi 菜单 | 检查用户副本 `config.rasi` 在 `$XDG_CONFIG_HOME/argvus/data/rofi/` 中是否仍指向打包的主题。再次应用 `argvus-appearance` 中的主题。 |
| `SUPER + O` 报告未找到任何项目 | 没有配置根目录或路径，或者目录已不存在。运行 `argvus projects list`。 |
| `SUPER + C` 或表情符号选择器无法打开 | 安装 `rofi-calc` 或 `rofimoji`（两者都是必需依赖）。 |
| 快捷参考表无法打开 | 该名称和语言的文件不存在。检查快捷参考表部分描述的路径。 |
| `SUPER + H` 什么都不显示 | 历史记录为空，或者 `argvus-session` 的剪贴板记录器还没有存储任何内容。 |

## 相关组件

| 组件 | 职责 |
| --- | --- |
| `argvus-hyprland` | 声明菜单的快捷方式和 Hyprland 窗口规则。 |
| `argvus-appearance` | 更改活动主题、强调色和布局，并重写 Rofi 主题引用。 |
| `argvus` (`argvus config`) | 存储项目、代码片段和默认启动器设置。 |
| `argvus-session` | 复制初始 Rofi 配置并在会话开始时设置其字体。 |
| `argvus` (`argvus terminal`) | 打开 SSH 会话、项目终端以及 `argvus keys` 的密码提示。 |
| `argvus` (`argvus widget-telemetry`) | 读取由 `argvus projects` 写入的活动项目。 |
| `argvus` (`argvus i18n`) | 提供启动器脚本使用的已翻译消息。 |
| `argvus` (`argvus control-center`) | 通过 `argvus projects` 编辑项目列表。 |
