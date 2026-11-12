---
title: アプリケーションランチャー
description: ARGVUSのRofiメニューを通じて、アプリケーションの起動、プロジェクトの開閉、SSHホストやスニペットの操作、絵文字の選択、計算、チートシートの閲覧を行います。
---
`argvus-launcher`は、ARGVUSがキーボードから物事を開くために使用するRofiの設定、テーマ、およびメニューを提供します。これには以下が含まれます：

- アプリケーションランチャー（`SUPER + D`）；
- すべてのARGVUS Rofiメニューで共有されるRofiの設定およびテーマ；
- プロジェクトスイッチャー、SSHピッカー、およびスニペットピッカー（`argvus projects`、`argvus ssh`、`argvus snippets`）；
- SSHキー管理者（`argvus keys`）、キー ペアの作成、リスト、ロード、削除を行う；
- GPGキー管理者（`argvus gpg`）、キーのリスト作成、エクスポートを行い、gpg-agentのためにpinentry-gtkを設定する；
- 絵文字ピッカー、チートシートビューア、および計算機メニュー。

ショートカットは`argvus-hyprland`によって宣言されています。このパッケージは、コマンドおよびその背後にあるメニューを提供します。

## ショートカット

| ショートカット | アクション | コマンド | セクション |
| --- | --- | --- | --- |
| `SUPER + D` | アプリケーションランチャー | `argvus launcher` | アプリケーションランチャー |
| `SUPER + O` | プロジェクト切り替え | `argvus projects` | プロジェクト切り替え |
| `SUPER + ALT + 1` から `9` | その位置のプロジェクトを開く | `argvus projects open N` | プロジェクト切り替え |
| `SUPER + ALT + S` | SSHホストピッカー | `argvus ssh` | SSH |
| `SUPER + ALT + N` | スニペットピッカー | `argvus snippets` | スニペット |
| `SUPER + ALT + G` | プロジェクトピッカー、その後 git TUI | `argvus git` | Git |
| `SUPER + .` | 絵文字ピッカー | `emoji-picker.sh` | 絵文字ピッカー |
| `SUPER + C` | 電卓 | `rofi -show calc` | 電卓 |
| `SUPER + SHIFT + /` | Hyprland チートシート | `cheatsheets.sh hypr` | チートシート |
| `SUPER + CTRL + /` | Kitty チートシート | `cheatsheets.sh kitty` | チートシート |

## アプリケーションランチャー (`SUPER + D`)

`SUPER + D`は`argvus launcher`を実行し、`drun`モードでRofiを開きます。これはデスクトップエントリーを使用してインストールされたグラフィカルアプリケーションを一覧表示し、選択されたものは`Enter`を押すと起動します。

1. `SUPER + D`を押します。
2. アプリケーション名の一部を入力します。リストはソートされ、フィルターは大文字小文字を区別しません。
3. `Enter`を押してアプリケーションを起動するか、`Esc`を押してメニューを閉じます。

```sh
argvus launcher                  # opens the application menu
argvus launcher --config PATH    # uses another Rofi configuration file
```
他の引数はすべて`rofi`に渡されます。`--config`は値がない場合、エラーで終了します。

Hyprlandはデフォルトランチャーがrofi（デフォルト）である場合、`argvus launcher --config <Rofi configuration>`を実行します。デフォルトアプリケーションのデフォルト `rofi` `launcher`が別のプログラムに設定されている場合、Hyprlandは代わりに`<program> --show drun`を実行します。値はコントロールセンターのデフォルトアプリケーションで設定してください。ここで値は`argvus-config`に保存されます。

デスクトップエントリを持つアプリケーションのみがリストに表示されます。`.desktop`ファイルをインストールしないアプリケーションは、ここで見つけることができません。

## Rofiの設定とテーマ

パッケージは`/usr/share/argvus/launcher/config/`の下にRofiの設定をインストールします:

| ファイル | 役割 |
| --- | --- |
| `config.rasi` | すべてのARGVUSメニューで使用されるエントリーポイント。Rofi `configuration`（フォント、アイコンなし、ソート済みリスト、大文字小文字を区別しない一致）を設定し、`theme.rasi`をインポートします。 |
| `theme.rasi` | ウィンドウ、入力バー、リストの色とレイアウト。1つのテーマとモードファイルをインポートします。 |
| `mode.rasi` | モードの上書き。パッケージ化されたファイルには上書きがなく、ダークモードを維持します。 |
| `themes/<family>/theme.rasi` | テーマファミリーのパレット。例えば、`argvus-dark`や`tokyo-night`など。 |
| `themes/<family>-spaced/theme.rasi` | 同じファミリーのスペース付きバリエーション。 |

このパッケージには22のファミリーがあり、それぞれに`-spaced`のバリアントがあります。パッケージ化された`theme.rasi`は`argvus-dark`をインポートします。

### アクティブな設定が存在する場所

ARGVUSは各Rofiファイルを`paths_config`を通じて解決します。ユーザーオーバーライド、ユーザーコピー、レガシーの場所、生成されたツリーの中で最初に存在するファイルが優先されます。それ以外の場合は、`/usr/share/argvus/launcher/config/`配下のパッケージファイルが使用されます。ファイルのユーザーコピーは`$XDG_CONFIG_HOME/argvus/data/rofi/<file>`であり、`launcher/config/`プレフィックスは`rofi/`に格納されます。

ARGVUSは初めてARGVUSスクリプトがそのファイルを変更するときにユーザーコピーを作成します。`argvus-appearance`はテーマ、アクセント、モードの変更に対応します。一度も変更されなかったファイルは引き続きパッケージから読み込まれ、ユーザーコピーはパッケージファイルよりも優先されます。

`argvus-session` がセッション開始時にフォントを適用すると、ARGVUS フォント設定から config.rasi の `font:` 行を書き換えます。その編集はユーザーコピーにのみ反映されます。コピーが存在するまでは、パッケージ化されたファイルが使用され、ユーザーはそれに書き込むことができないため、最初の外観変更でコピーが作成された後にフォントの変更が有効になります。

### テーマの変更

 `config.rasi` `argvus-appearance` はテーマの変更を管理します。テーマが変更されると、ユーザーコピーを書き換えて `config.rasi` が新しい `theme.rasi` を指すようにし、`theme.rasi` はテーマビルド（`~/.config/argvus/data/generated/theme/current/launcher/theme.rasi`）のランチャーパレットをインポートします。このランチャーパレットにはアクティブなファミリー、レイアウト、ハイライトカラーが含まれています。テーマビルドがない場合は、ファミリーのコピーをインポートし、Spaced レイアウトはアクティブファミリーの `-spaced` バリアントを選択します。テーマメニューやレイアウトメニューなどのテーマピッカーも同じ `config.rasi` を読み取るため、アクティブスタイルが使用されます。

`/usr/share/argvus/launcher/` の下のファイルは編集しないでください。これらはパッケージアップグレード時に置き換えられます。変更は `$XDG_CONFIG_HOME/argvus/data/rofi/` のユーザーコピーで行ってください。

## プロジェクトスイッチャー (`SUPER + O`)

`argvus projects`（`SUPER + O`）は、追加したプロジェクトを一覧表示し、選択したプロジェクトを独自のHyprlandワークスペースで開き、そのディレクトリ内に`argvus terminal`があります。プロジェクトのワークスペースが既に存在する場合、スイッチャーはそれにフォーカスするだけです。

キーボードのみでアクセスするには、`SUPER + ALT + 1`から`SUPER + ALT + 9`を使用して、メニューなしでリスト内のその位置のプロジェクトを開きます。位置はメニューに表示されている番号です。リストの順序に従うため、プロジェクトの追加や削除により変わることがあります。`argvus projects open <number or directory name>`はターミナルから同じことを行い、失敗した場合は通知として表示されます。

実際のプロジェクトリストは9件に制限されています。これは`SUPER + ALT + 1..9`が対応できる数がそれだけだからです。`argvus projects add`（およびそれを呼び出すコントロールセンターのプロジェクトページ）は、合計が9を超えるプロジェクトまたはルートを追加することを拒否し、代わりにエラーを報告します。

プロジェクトは、argvus-config の `projects` セクションの 2 か所から来ます：

-  `argvus-config` `paths`: 個別のプロジェクトディレクトリ。
- `roots`: 直下のサブディレクトリがプロジェクトであるディレクトリ。存在しないルートは無視されます。

デフォルトではルートやパスは設定されていません。`SUPER + O` に何かを一覧表示させる前に、少なくとも1つ追加してください。

ターミナルから管理します:

```sh
argvus projects add ~/Work/api          # one project
argvus projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus projects remove ~/Work/api       # removes it from paths and roots
argvus projects list                    # prints the roots and paths
```
`argvus projects pick` は同じリストを表示し、選択したパスを開くのではなく印刷します。他のツールもそれを使用できます。`argvus git` のように使用可能です。キャンセルすると何も印刷されません。

ルートやパスが存在しない場合、`SUPER + O` はプロジェクトが見つからなかったと報告します。オプションのエディターコマンド `/projects/editor` は、ワークスペースが作成されたときに同じワークスペースで起動します。

エントリは有効な設定から読み取られます。ランチャーはそれらのコピーを保持しません。

プロジェクトを開くと、そのパスもセッションのアクティブプロジェクトとして記録されます。これを Dev Dashboard のテレメトリブロック（`argvus widget-telemetry`）が読み取り、そのプロジェクトの git、リッスンポート、およびコンテナを報告します。

## SSH (`SUPER + ALT + S`)

`SUPER + ALT + S` は、`~/.ssh/config` で定義されたホストを持つピッカーを開きます。選択されたホストは、現在のワークスペースで `ssh <host>` を実行する新しい ARGVUS ターミナルで開きます。

### 設定

各サーバーのために `Host` エントリを `~/.ssh/config` に追加します:

```ini
Host myhost
    HostName myhost.local
    User boss
    IdentityFile ~/.ssh/myhost
    IdentitiesOnly yes
```
まず、`ssh myhost` が通常のターミナルで動作することを確認してください。ランチャーは `ssh` のみを実行します。認証、鍵、およびホスト検証は OpenSSH によって処理されます。

### 使用方法

1. `SUPER + ALT + S` を押します。
2. ホスト名の一部を入力するか、矢印キーを使用します。
3. `Enter` を押します。ターミナルが開き、`ssh <host>` が実行されます。

セッションが終了すると、ウィンドウは開いたままで終了ステータス（例えば `ssh exited with status 0. Press Enter to close.`）が表示されます。閉じるには `Enter` を押します。これは GitHub、GitLab、Gitea などのフォージで重要です。これらは即座に認証して接続を閉じるため、シェルを提供しません。ウィンドウはメッセージを画面上に保持し、消えません。

### ルール

- ワイルドカードのエントリ（`Host *`、`Host *.internal`）はマッチブロックであり、ターゲットではないため、決してリストには表示されません。
- `Host`行の各エイリアスは個別にリストされます（`Host a b`は`a`と`b`をリストします）。重複は削除されます。
- `Include`で読み込まれたファイルのみで定義されたホストはリストに表示されません。ピッカーはメインファイルのみを読みます。
- 文字、数字、`.`、`-`、`_`で構成されたエイリアスのみ起動されます。それ以外の名前は、通知とともに拒否されます。
- 設定ファイル内のWindowsの改行（CRLF）は受け入れられます。
- `ARGVUS_SSH_CONFIG`は設定ファイルのパスを置き換えます。これはテスト時に便利です。

### コマンド

```sh
argvus ssh list          # prints the configured hosts, one per line
argvus ssh open myhost   # opens a specific host without the picker
```
### トラブルシューティング

| 症状 | 原因と解決方法 |
| --- | --- |
| 通知「~/.ssh/config にホストが見つかりません」 | ファイルが存在しないか、`Host` の行がありません。`argvus ssh list` を実行して確認してください。 |
| ピッカーにホストが表示されない | ワイルドカードで指定されている、`Include` ファイルから来ている、または許可されていない文字が含まれています。通常のエイリアスでメインファイルに追加してください。 |
| ウィンドウがすぐにエラー状態を表示する | 通常のターミナルで `ssh <host>` を実行して、完全なメッセージを確認してください（ホストに到達できない、キーが間違っているなど）。 |
| ウィンドウにテキストの代わりに `message.ssh_session_ended` が表示される | インストールされている `argvus` パッケージがこのバージョンより古いです。`argvus` を更新してください。 |

`openssh` と `argvus`（`argvus terminal` コマンド）が必要です。

## SSH キー（`argvus keys`）

`argvus keys` は `~/.ssh` のキーペアと ssh-agent が保持するキーを管理します。ショートカットはありません。コントロールセンター（アプリケーション）の **SSH キー** ページでも同じコマンドが使用されています。

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
すべてのコマンドに適用されるルール:

- キー名は`~/.ssh`下のファイル名となるため、英字、数字、ドット、ハイフン、アンダースコアのみを含めることができます。ドットで始まることも`.pub`で終わることもできません。既存のペアは上書きされません。
- 公開ファイル(`NAME.pub`)があるペアのみが一覧表示され、それのみがロード、アンロード、削除可能です。
- パスフレーズはコマンド引数として渡されることも、ログに書き込まれることも、コントロールセンターに表示されることもありません。`load`および`generate --passphrase`はARGVUSターミナルを開き、OpenSSHはそのターミナルから秘密を読み取ります。
- エージェントに接続できない場合、`list`はloaded列に`unknown`を報告します。推測は行いません。
-  `loaded` `delete`は秘密鍵を完全に削除します。まだ必要な鍵はコピーを保持してください。
- `ARGVUS_SSH_DIR`はテストに便利な`~/.ssh`の代わりとなります。

エージェントはargvus-sessionによって起動される`argvus-ssh-agent.service`ユーザーサービスです。 `argvus-session` `SSH_AUTH_SOCK`はセッション内でそれを指します。

`openssh`（`ssh-keygen` と `ssh-add`）および `argvus`（`argvus terminal` コマンド）が必要です。

| 症状 | 原因と修正 |
| --- | --- |
| `load` がターミナルを開くが、キーがロードされていない | そのターミナルでパスフレーズを入力してください。要求されなかった場合は、`ssh-add -l` を実行してエージェントが保持しているものを確認してください。 |
| ターミナルに `Could not open a connection to your authentication agent` が表示される | Hyprland がエージェントより先に起動したため、そのターミナルには `SSH_AUTH_SOCK` がありません。ランチャーは `$XDG_RUNTIME_DIR/ssh-agent.socket` にフォールバックするので、`argvus-launcher` を更新して新しいターミナルを開いてください。 |
| `list` が loaded 列に `unknown` を表示する | エージェントに接続できません。 `loaded` `systemctl --user status argvus-ssh-agent.service` と `SSH_AUTH_SOCK` 変数を確認してください。 |
| `delete` がキーがロードされていると報告する | まず `argvus keys unload NAME` を実行し、その後再度削除してください。 |
| `generate` が名前が既に存在すると報告する | 別の名前を選択してください。既存のペアは決して置き換えられません。 |

## GPG キー (`argvus gpg`)

`argvus gpg` は GPG キーの一覧表示、作成、エクスポート、および公開キーのインポートを行います。gpg-agent は常に `pinentry-gtk` を使用します：ARGVUS はキーを生成する前に pinentry を `gpg-agent.conf` に書き込みます。ショートカットはありません。コントロールセンターの **GPG キー** ページは同じコマンドを使用します。

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
`generate` はこれらのオプションを受け取ります:

- `--algo rsa|dsa` は鍵アルゴリズムを選択します。デフォルトは `rsa` です。
- `--bits` は鍵のサイズを選択します。RSA は `1024`、`2048`、`3072` および `4096` を受け入れ、デフォルトは `4096` です。DSA は `1024`、`2048` および `3072` を受け入れ、デフォルトは `2048` です。gpg はより大きな DSA 鍵を作成できないため、`4096` は gpg 実行前に拒否されます。
- `--expire` は有効期限なしの場合 `0` を取り、数字の後に `d`、`w`、`m` または `y`（例: `2y`）、または ISO 日付 `YYYY-MM-DD` を指定できます。この日付は有効な日付でなければなりません。
- `--passphrase-stdin` はパスフレーズを標準入力の最初の行から読み込みます。コントロールセンターがこれを使用します。空行は拒否されます。
- `--no-passphrase --yes` は保護されていない鍵を作成します。この 2 つのパスフレーズモードは併用できません。

すべての鍵には、1つの認証および署名用の主鍵と1つの暗号化用サブ鍵が割り当てられています。これにより、ファイルの暗号化だけでなく、コミットやパッケージの署名も可能です。サブ鍵は主鍵と一致します：RSAの場合は `rsa` と同じサイズで、DSAの場合は `elg` と同じサイズであり、これはDSA標準で要求されるペアです。

すべてのコマンドに適用されるルール：

- パスフレーズは決してコマンド引数として渡されたり、ログに書き込まれたり、コントロールセンターに表示されたりしません。`--passphrase-stdin` を使用すると、パスフレーズはパイプからファイルディスクリプタ0経由で gpg に渡されます。そのオプションがない場合、gpg は pinentry ウィンドウに尋ね、`gpg-agent` がそれを開きます。
- `--no-passphrase` は秘密鍵を保護なしで保存します。`--yes` が指定されない限り拒否されます。
- `import` は ASCII 形式またはバイナリ形式の秘密鍵パケットを含むファイルを拒否します。秘密鍵は `export-private` を通じてのみキーホイールを離れます。この際 `--yes` が必要で、`600` のモードで書き込みます。`import-private` は鍵を戻します。
- 鍵を変更または公開するコマンド（`export-private`、`delete`、`edit sign`、`edit revoke`、`keyserver send`）には`--yes`が必要です。コントロールセンターは自らの確認後にのみこれを渡します。
- 秘密鍵を使用するコマンドは`--no-tty`付きでgpgを実行するため、gpgは端末を開こうとしません。パスフレーズはpinentryウィンドウから取得されますが、`generate --passphrase-stdin`の場合を除きます。
- `generate`はgpg-agentに`pinentry-gtk`を使用させます。その行は`# BEGIN argvus-managed pinentry`と`# END argvus-managed pinentry`のマーカーの間に書き込み、残りの`gpg-agent.conf`は保持し、前のファイルを`gpg-agent.conf.bak`として保存します。ブロックですでに`pinentry-gtk`が指定されている場合、ファイルとgpg-agentはそのままにされます。`gpg-agent.conf`が既にそのブロック外で`pinentry-program`を設定している場合、コマンドは実行を拒否し、二つの値が競合しないようにします。
- パッケージをインストールしても、`~/.gnupg`には書き込まれません。構成はキーが生成されたときのみ変更されます。
- `GNUPGHOME`は`~/.gnupg`に置き換わり、テストに便利です。

`gnupg`と`pinentry`は必須の依存関係です：キーコマンドにはgpgが必要で、パスフレーズウィンドウは`pinentry-gtk`です。

| 症状 | 原因と修正 |
| --- | --- |
| `generate`がパスフレーズウィンドウを開かない | `argvus gpg status`を確認してください。`pinentry-gtk`がインストールされている必要があり、セッションは`WAYLAND_DISPLAY`または`DISPLAY`を露出する必要があります。 |
| `generate`が`pinentry-gtk`がインストールされていないと報告する | `pinentry`パッケージをインストールしてください。 |
| `generate`がARGVUSブロック外の`pinentry-program`行を報告する | その行を`~/.gnupg/gpg-agent.conf`から削除し、再度コマンドを実行してください。 |
| `generate`がキーサイズがサポートされていないと報告する | アルゴリズムのサイズを確認してください：DSAは3072ビットまでです。 |
| `generate` は、暗号化サブキーを追加できなかったと報告しています | キーは作成されました。`gpg --quick-add-key FINGERPRINT cv25519 encr 2y` でサブキーを追加するか、`gpg --delete-secret-and-public-key` でキーを削除して再度生成してください。 |
| `import` はファイルを拒否しました | ファイルには秘密鍵が含まれています。`argvus gpg export-public` を使用して、他のマシンで公開鍵のみをエクスポートしてください。 |
| `list` はキーが表示されません | `GNUPGHOME`（または `~/.gnupg`）のキーファイルが空です。`argvus gpg generate` を実行してキーを作成してください。 |

## スニペット (`SUPER + ALT + N`)

`SUPER + ALT + N` は、スニペットを選択できるピッカーを開きます。選択したスニペットはクリップボードを経由せず、カーソル位置のフォーカスされたウィンドウに直接入力されます。

### 設定

名前とテキストを指定してスニペットを追加してください:

```sh
argvus snippets add "email" "you@example.com"
```
それが保存されたことを確認してください:

```sh
argvus snippets list
```
スニペットは argvus config の `snippets` セクションに  `argvus config` `{name, content}` エントリとして保存されています。`argvus config get /snippets/items` でそれらを読むことができます。

### 使用方法

1. テキストを受け取るアプリケーションのテキストフィールドをクリックします。
2. `SUPER + ALT + N` を押します。
3. 名前でスニペットを選択し、`Enter` を押します。テキストはカーソルの位置に入力されます。

### コマンド

```sh
argvus snippets add "NAME" "CONTENT"   # adds a snippet, or replaces the one with the same name
argvus snippets remove NAME            # removes a snippet
argvus snippets list                   # prints index and name, one per line
argvus snippets open NAME              # types a snippet by name
argvus snippets open 2                 # types the snippet at position 2 of `list`
argvus snippets                        # opens the picker (same as the shortcut)
argvus snippets --help                 # shows the options and an example
```
### ルール

- 名前は一意で大文字と小文字が区別されます。既存の名前でスニペットを追加すると、その内容が置き換えられます。
- 内容は空にできません：空のスニペットは見つからないと報告されます。
- `open` は、数字のみで作られた名前を位置として扱います。曖昧さを避けるには、`code2` のように文字を含む名前を使用してください。
- 位置は `list` によって示される順序を指します。スニペットを削除すると、その後のスニペットの位置がずれます。

### トラブルシューティング

| 症状 | 原因と対処法 |
| --- | --- |
| ショートカットを押したときに「スニペットなし」と表示される | まだスニペットが追加されていません。まず `argvus snippets add` を実行してください。 |
| `open` がスニペットが見つからないと報告する | 名前が正確に一致していません。`argvus snippets list` と比較してください。 |
| アプリケーションに何も表示されない | フォーカスされているウィンドウがテキストフィールドでないか、XWayland 上で動作している X11 アプリケーションの可能性があり、この種の入力を無視することがあります。ネイティブな Wayland アプリケーションでテストしてください。 |

`wtype`、`rofi`、`jq`、および`argvus`（`argvus config`コマンド）が必要です。

`wtype`はWayland入力レベルでキー入力をシミュレートします。一部のXWayland上で動作するX11アプリケーションはこれらのイベントを無視するため、スニペットが見つかってもテキストが表示されない場合があります。

## Git (`SUPER + ALT + G`)

`SUPER + ALT + G`は`SUPER + O`と同じプロジェクトピッカーを開きます。プロジェクトを選択すると、`lazygit`（または`gitui`）が直接そのプロジェクトで、現在のワークスペースの新しいARGVUSターミナルで開かれます。最初にプロジェクトを選択するための別の手順はありません。

### セットアップ

2つのツールのいずれかをインストールします。どちらもこのパッケージのオプションの依存関係です:

```sh
sudo pacman -S lazygit   # or: sudo pacman -S gitui
```
### 使用方法

1. `SUPER + ALT + G` を押します。
2. リストからプロジェクトを選択するか、`Esc` を押してキャンセルします。キャンセルすると何も開きません。
3. ターミナルがプロジェクトディレクトリで開かれ、TUI が開始されます。

Git リポジトリでないプロジェクトは通知が表示され、何も開きません。ピッカーをスキップするには、ディレクトリを指定してください：

```sh
argvus git ~/Projects/api
```
### ツールの選択

`argvus-git`はインストール時に`lazygit`を使用し、そうでない場合は`gitui`を使用します。`gitui`を優先するには、コマンドに対して`ARGVUS_GIT_TUI`を設定してください:

```sh
ARGVUS_GIT_TUI=gitui argvus git
```
変数はスクリプトを実行するコマンドの環境から読み取られます。ARGVUS構成には保存されません。

### トラブルシューティング

| 症状 | 原因と対処方法 |
| --- | --- |
| 「not a git repository」という通知 | 選択されたプロジェクトがgitリポジトリではない、またはディレクトリが移動された。`argvus projects remove`で削除するか修正してください。 |
| 「install lazygit or gitui」という通知 | どちらのツールも`PATH`にありません。どちらか一方をインストールしてください。 |
| ピッカーにプロジェクトが表示されない | プロジェクトが追加されていません。`argvus projects add`を使用してください。 |

## 絵文字ピッカー (`SUPER + .`)

`SUPER + .`はARGVUS Rofi構成で`rofimoji`を開きます。名前で絵文字を検索し、`Enter`を押すと絵文字がクリップボードにコピーされます。`Ctrl + V`で使用したいアプリケーションに貼り付けてください。

ピッカーが開いている間、セッションは通常表示されるキーボードレイアウトの通知を無視します。ランチャーはARGVUSキャッシュディレクトリに短期間のマーカーを書き込み、ピッカーが閉じた約1秒後にそれを削除します。

`rofimoji`および`wl-clipboard`が必要です。

## 計算機 (`SUPER + C`)

`SUPER + C`はARGVUS Rofi構成で`calc`モードのRofiを開きます。式を入力すると、入力に応じて結果リストが更新されます。結果を`rofi-calc`モードの定義に従って選択します。

ランチャーパッケージはRofi構成を提供し、`rofi-calc`に依存します。ショートカット自体は`argvus-hyprland`によって宣言されます。

## チートシート (`SUPER + SHIFT + /`および`SUPER + CTRL + /`)

`cheatsheets.sh`は大きなRofiウィンドウでショートカットの読み取り専用リストを表示します。引数としてアプリケーション名を取ります:

```sh
cheatsheets.sh hypr     # Hyprland shortcuts (SUPER + SHIFT + /)
cheatsheets.sh kitty    # terminal shortcuts (SUPER + CTRL + /)
cheatsheets.sh <name>   # any other application with a cheatsheet
```

- `hypr` は、そのファイルが存在する場合にユーザーの ARGVUS 設定から `data/generated/hypr/keybindings.txt` を使用します。存在しない場合は、`argvus-hyprland` に付属の Hyprland チートシートを使用します。
- `kitty` は、`argvus` に付属のターミナルチートシートを使用します。
- その他の名前は `<name>/docs/cheatsheets/<language>.txt` を読み込みます。そのファイルが存在しない場合、ウィンドウは開きません。

言語は、システムロケールが `pt-BR` の場合はポルトガル語、それ以外の場合は英語です。`Esc` はウィンドウを閉じます。行を選択するだけで閉じるだけで、何も実行されません。

## Rofi 設定を使用する他のメニュー

ランチャー設定は、他のパッケージが所有するコンポーネントと共有されています：

- クリップボード履歴（`SUPER + H`）とそのクリアショートカット（`SUPER + SHIFT + H`）は、`argvus-hyprland`によって宣言されています。これらは`cliphist`をこの設定でRofiにパイプします。`cliphist`は`argvus-session`から来ており、これは履歴を埋めるクリップボードレコーダーを実行します。`argvus`メタパッケージもこれに依存しています。
- `argvus-appearance`のテーマ、アクセント、レイアウトピッカーは、`config.rasi`でRofiを開きます。
- Hyprlandのウィンドウルールは`argvus-launcher`と`rofi`の名前空間を認識するため、メニューはランチャーサーフェスの処理を受けます。

## パッケージングと依存関係

パッケージ`argvus-launcher`はアーキテクチャに依存せず、以下をインストールします：

- 同じディレクトリに`argvus launcher`、`argvus-snippets`、`argvus-ssh`、`argvus-git`
- Rofiの設定とテーマを含む`/usr/share/argvus/launcher/config/`
-  `/usr/share/argvus/launcher/sh/` `cheatsheets.sh`と`emoji-picker.sh`を含む/usr/share/argvus/launcher/sh/

必要な依存関係: `argvus-session`、`argvus-appearance`、`argvus`、`bash`、`jq`、`hyprland`、`libnotify`、`rofi`、`rofi-calc`、`rofimoji`、`wl-clipboard`、`wtype`、`gnupg`、および`pinentry`（`pinentry-gtk`を提供）。オプションの依存関係: SSHピッカーおよびSSHキー管理用の`openssh`; git TUI用の`lazygit`および`gitui`。

パッケージをインストールしても`$HOME`には書き込まれません。ユーザー設定は[Rofi configuration and themes](#where-the-active-configuration-lives)に記載されているように、セッション開始時に作成されます。

## トラブルシューティング

| 症状 | 原因と解決方法 |
| --- | --- |
| `SUPER + D`が何も開かない | ターミナルで`argvus launcher`を確認してください。`rofi`がインストールされており、Rofiの設定が存在することを確認してください。 |
| `SUPER + D`がアプリケーションを表示しない | アプリケーションにデスクトップエントリがありません。`.desktop`ファイルを持つアプリケーションのみが表示されます。 |
| メニューが古いフォントを使用している | セッション開始時に`font:`行が書き換えられます。フォントを変更した後、セッションを再起動してください。 |
| テーマ変更がRofiメニューに反映されない | $XDG_CONFIG_HOME/argvus/data/rofi/内の`config.rasi`のユーザーコピーがまだパッケージ済みテーマを指しているか確認してください。 `$XDG_CONFIG_HOME/argvus/data/rofi/` `argvus-appearance`からテーマを再適用してください。 |
| `SUPER + O`がプロジェクトが見つからないと報告する | ルートやパスが設定されていないか、ディレクトリが存在しません。`argvus projects list`を実行してください。 |
| `SUPER + C`または絵文字ピッカーが開かない | `rofi-calc`または`rofimoji`をインストールしてください（両方とも必要な依存関係です）。 |
| チートシートが開かない | その名前と言語に対応するファイルが存在しません。チートシートのセクションに記載されているパスを確認してください。 |
| `SUPER + H`が何も表示しない | 履歴が空であるか、`argvus-session`のクリップボードレコーダーがまだ何も保存していません。 |

## 関連コンポーネント

| コンポーネント | 役割 |
| --- | --- |
| `argvus-hyprland` | メニュー用のショートカットとHyprlandウィンドウルールを宣言します。 |
| `argvus-appearance` | アクティブテーマ、アクセント、レイアウトを変更し、Rofiテーマの参照を書き換えます。 |
| `argvus` (`argvus config`) | プロジェクト、スニペット、デフォルトランチャー設定を保存します。 |
| `argvus-session` | 初期Rofi設定をコピーし、セッション開始時にフォントを設定します。 |
| `argvus` (`argvus terminal`) | SSHセッション、プロジェクトターミナル、`argvus keys`のパスフレーズプロンプトを開きます。 |
| `argvus` (`argvus widget-telemetry`) | `argvus projects`によって書き込まれたアクティブプロジェクトを読み取ります。 |
| `argvus` (`argvus i18n`) | ランチャースクリプトで使用される翻訳済みメッセージを提供します。 |
| `argvus` (`argvus control-center`) | `argvus projects`を通じてプロジェクトリストを編集します。 |
