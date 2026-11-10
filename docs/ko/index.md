---
title: 응용 프로그램 실행기
description: ARGVUS Rofi 메뉴를 통해 애플리케이션을 실행하고, 프로젝트를 열고, SSH 호스트와 스니펫을 열고, 이모지를 선택하고, 계산하고, 치트시트를 읽으세요.
---
`argvus-launcher`은 ARGVUS가 키보드로 항목을 열 때 사용하는 Rofi 설정, 테마 및 메뉴를 제공합니다. 이 패키지에는 다음이 포함되어 있습니다:

- 애플리케이션 실행기(`SUPER + D`);
- 모든 ARGVUS Rofi 메뉴에서 공유되는 Rofi 설정 및 테마;
- 프로젝트 전환기, SSH 선택기 및 스니펫 선택기(`argvus projects`, `argvus ssh`, `argvus snippets`);
- SSH 키 관리자(`argvus keys`), 키 쌍 생성, 목록, 로드 및 삭제 기능 제공;
- GPG 키 관리자(`argvus gpg`), 키 목록, 생성 및 내보내기 기능과 gpg-agent용 pinentry-gtk 설정;
- 이모지 선택기, 치트시트 뷰어 및 계산기 메뉴.

단축키는 `argvus-hyprland`에서 선언됩니다. 이 패키지는 명령어와 그에 따른 메뉴를 제공합니다.

## 단축키

| 바로가기 | 동작 | 명령 | 섹션 |
| --- | --- | --- | --- |
| `SUPER + D` | 애플리케이션 실행기 | `argvus launcher` | 애플리케이션 실행기 |
| `SUPER + O` | 프로젝트 전환기 | `argvus projects` | 프로젝트 전환기 |
| `SUPER + ALT + 1` ~ `9` | 해당 위치의 프로젝트 열기 | `argvus projects open N` | 프로젝트 전환기 |
| `SUPER + ALT + S` | SSH 호스트 선택기 | `argvus ssh` | SSH |
| `SUPER + ALT + N` | 스니펫 선택기 | `argvus snippets` | 스니펫 |
| `SUPER + ALT + G` | 프로젝트 선택기, 그 다음 git TUI | `argvus git` | Git |
| `SUPER + .` | 이모지 선택기 | `emoji-picker.sh` | 이모지 선택기 |
| `SUPER + C` | 계산기 | `rofi -show calc` | 계산기 |
| `SUPER + SHIFT + /` | Hyprland 치트시트 | `cheatsheets.sh hypr` | 치트시트 |
| `SUPER + CTRL + /` | Kitty 치트시트 | `cheatsheets.sh kitty` | 치트시트 |

## 애플리케이션 실행기 (`SUPER + D`)

`SUPER + D`은 `argvus launcher`를 실행하며, 이는 `drun` 모드에서 Rofi를 엽니다. 설치된 그래픽 애플리케이션을 데스크탑 항목과 함께 나열하며, 선택된 항목은 `Enter`를 누르면 시작됩니다.

1. `SUPER + D`를 누르세요.
2. 애플리케이션 이름의 일부를 입력하세요. 목록은 정렬되며 필터는 대소문자를 구분하지 않습니다.
3. 애플리케이션을 시작하려면 `Enter`를 누르고, 메뉴를 닫으려면 `Esc`를 누르세요.

```sh
argvus launcher                  # opens the application menu
argvus launcher --config PATH    # uses another Rofi configuration file
```
다른 모든 인수는 `rofi`로 전달됩니다. 값 없이 `--config`를 실행하면 오류와 함께 중단됩니다.

Hyprland는 기본 실행기가 rofi(기본값)일 때 `argvus launcher --config <Rofi configuration>`를 실행합니다. 기본 애플리케이션에서 기본  `rofi` `launcher`가 다른 프로그램으로 설정되어 있으면, Hyprland는 대신 `<program> --show drun`를 실행합니다. 제어 센터의 기본 애플리케이션에서 설정할 수 있으며, 이 값은 `argvus-config`에 저장됩니다.

데스크탑 엔트리가 있는 애플리케이션만 목록에 나타납니다. `.desktop` 파일을 설치하지 않는 애플리케이션은 여기에서 찾을 수 없습니다.

## Rofi 구성 및 테마

패키지는 `/usr/share/argvus/launcher/config/`에 Rofi 구성을 설치합니다:

| 파일 | 역할 |
| --- | --- |
| `config.rasi` | 모든 ARGVUS 메뉴에서 사용하는 진입점입니다. Rofi `configuration`(폰트, 아이콘 없음, 정렬된 목록, 대소문자 구분 없는 매칭)을 설정하고 `theme.rasi`를 가져옵니다. |
| `theme.rasi` | 창, 입력 바 및 목록의 색상과 레이아웃을 설정합니다. 하나의 테마와 모드 파일을 가져옵니다. |
| `mode.rasi` | 모드 재정의입니다. 패키지된 파일에는 재정의가 없으며 다크 모드를 유지합니다. |
| `themes/<family>/theme.rasi` | 테마 패밀리의 팔레트, 예를 들어 `argvus-dark` 또는 `tokyo-night`. |
| `themes/<family>-spaced/theme.rasi` | 동일한 패밀리의 간격 변형입니다. |

패키지는 22개의 패밀리를 제공하며, 각 패밀리는 `-spaced` 변형을 가지고 있습니다. 패키지된 `theme.rasi`는 `argvus-dark`를 가져옵니다.

### 활성 구성 파일 위치

ARGVUS는 각 Rofi 파일을 `paths_config`을 통해 해결합니다. 사용자 오버라이드, 사용자 복사본, 레거시 위치 및 생성된 트리 중 첫 번째로 존재하는 파일이 선택됩니다. 그렇지 않으면 `/usr/share/argvus/launcher/config/`에 있는 패키지 파일이 사용됩니다. 파일의 사용자 복사본은 `$XDG_CONFIG_HOME/argvus/data/rofi/<file>`이며, `launcher/config/` 접두사는 `rofi/`에 저장됩니다.

ARGVUS는 ARGVUS 스크립트가 해당 파일을 처음 변경할 때 사용자 복사본을 생성합니다. `argvus-appearance`은 테마, 강조 및 모드 변경에 대해 이를 수행합니다. 한 번도 변경되지 않은 파일은 계속해서 패키지에서 읽히며, 사용자 복사본이 패키지 파일보다 우선합니다.

`argvus-session`가 세션 시작 시 폰트를 적용하면, ARGVUS 폰트 설정에서 config.rasi의 `font:` 줄을 다시 씁니다. 그 편집은 사용자 사본에만 적용됩니다. 사본이 존재할 때까지는 패키지된 파일이 사용되며, 사용자는 해당 파일에 쓸 수 없기 때문에, 첫 번째 외관 변경이 사본을 생성한 후에야 폰트 변경이 적용됩니다.

### 테마 변경

 `config.rasi` `argvus-appearance`는 테마 변경을 소유합니다. 테마가 변경되면, 사용자 복사본을 다시 작성하여 `config.rasi`가 새로운 `theme.rasi`를 가리키도록 하고, `theme.rasi`는 테마 빌드(`~/.config/argvus/data/generated/theme/current/launcher/theme.rasi`)의 런처 팔레트를 가져오며, 여기에는 활성 패밀리, 레이아웃 및 하이라이트 색상이 포함됩니다. 테마 빌드가 없으면 패밀리 복사본을 가져오고, Spaced 레이아웃은 활성 패밀리의 `-spaced` 변형을 선택합니다. 테마 메뉴와 레이아웃 메뉴와 같은 테마 선택기는 동일한 `config.rasi`를 읽으므로 활성 스타일도 사용합니다.

`/usr/share/argvus/launcher/` 아래의 파일은 편집하지 마십시오; 이는 패키지 업그레이드 시 교체됩니다. 변경 사항은 `$XDG_CONFIG_HOME/argvus/data/rofi/` 아래의 사용자 복사본에서 하십시오.

## 프로젝트 전환기 (`SUPER + O`)

`argvus projects` (`SUPER + O`)는 추가한 프로젝트를 나열하고 선택한 프로젝트를 자체 Hyprland 작업 공간에서 열며, 해당 디렉토리에 `argvus terminal`가 있습니다. 프로젝트의 작업 공간이 이미 존재하는 경우, 스위처는 단지 해당 작업 공간에 초점을 맞춥니다.

키보드만 사용하여 접근하려면 `SUPER + ALT + 1`에서 `SUPER + ALT + 9`까지 목록의 해당 위치에서 프로젝트를 메뉴 없이 엽니다. 위치는 메뉴에 표시된 숫자입니다. 목록 순서를 따르므로 프로젝트를 추가하거나 제거하면 위치가 바뀔 수 있습니다. `argvus projects open <number or directory name>`는 터미널에서 동일하게 수행되며, 실패는 알림으로 표시됩니다.

실제 프로젝트 목록은 최대 9개로 제한되며, 이는 `SUPER + ALT + 1..9`가 처리할 수 있는 수가 전부이기 때문입니다. `argvus projects add`(및 이를 호출하는 컨트롤 센터의 프로젝트 페이지)는 총합이 9를 초과하도록 만드는 프로젝트나 루트를 추가하지 않으며, 대신 오류를 보고합니다.

argvus-config의 `projects` 섹션에서 프로젝트는 두 곳에서 가져옵니다:

-  `argvus-config` `paths`: 개별 프로젝트 디렉토리.
- `roots`: 즉시 하위 디렉토리가 프로젝트인 디렉토리. 존재하지 않는 루트는 무시됩니다.

기본적으로 구성된 루트나 경로는 없으므로, `SUPER + O`가 항목을 나열하기 전에 최소 하나 이상 추가해야 합니다.

터미널에서 이를 관리하세요:

```sh
argvus projects add ~/Work/api          # one project
argvus projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus projects remove ~/Work/api       # removes it from paths and roots
argvus projects list                    # prints the roots and paths
```
`argvus projects pick`은 동일한 목록을 보여주고 선택한 경로를 열지 않고 출력합니다. 다른 도구들은 `argvus git`처럼 이를 사용할 수 있습니다. 취소하면 아무것도 출력하지 않습니다.

루트나 경로가 존재하지 않으면, `SUPER + O`는 프로젝트를 찾을 수 없다고 보고합니다. 선택적 편집기 명령 `/projects/editor`는 워크스페이스가 생성될 때 동일한 워크스페이스에서 시작됩니다.

항목들은 유효한 구성에서 읽히며; 런처는 그 사본을 유지하지 않습니다.

프로젝트를 열면 해당 경로가 세션의 활성 프로젝트로 기록되며, Dev Dashboard 텔레메트리 블록(`argvus widget-telemetry`)이 해당 프로젝트의 git, 리스닝 포트 및 컨테이너를 보고하는 데 읽습니다.

## SSH (`SUPER + ALT + S`)

`SUPER + ALT + S`은 `~/.ssh/config`에 정의된 호스트와 함께 선택기를 엽니다. 선택된 호스트는 현재 워크스페이스에서 `ssh <host>`을 실행하는 새로운 ARGVUS 터미널에서 열립니다.

### 설정

각 서버에 대해 `Host` 항목을 `~/.ssh/config`에 추가하십시오:

```ini
Host myhost
    HostName myhost.local
    User boss
    IdentityFile ~/.ssh/myhost
    IdentitiesOnly yes
```
먼저 일반 터미널에서 `ssh myhost`이 작동하는지 확인하십시오. 런처는 `ssh`만 실행합니다. 인증, 키 및 호스트 확인은 OpenSSH가 처리합니다.

### 사용법

1. `SUPER + ALT + S`를 누릅니다.
2. 호스트 이름의 일부를 입력하거나 화살표 키를 사용합니다.
3. `Enter`를 누릅니다. 터미널이 열리고 `ssh <host>`가 실행됩니다.

세션이 종료되면 창은 열려 있으며 종료 상태를 표시합니다. 예: `ssh exited with status 0. Press Enter to close.` `Enter`를 눌러 닫습니다. 이는 GitHub, GitLab, Gitea 같은 포지에서 중요합니다. 이들은 당신을 인증하고 곧바로 연결을 종료하기 때문에 셸을 제공하지 않습니다. 창은 사라지는 대신 그들의 메시지를 화면에 유지합니다.

### 규칙

- 와일드카드 항목(`Host *`, `Host *.internal`)은 대상이 아니라 매치 블록이며, 절대 목록에 표시되지 않습니다.
- `Host` 행의 모든 별칭은 각각 목록에 표시됩니다(`Host a b`은 `a`과 `b`을 목록에 표시). 중복 항목은 제거됩니다.
- `Include`로 로드된 파일에만 정의된 호스트는 목록에 표시되지 않으며, 선택기는 메인 파일만 읽습니다.
- 문자, 숫자, `.`, `-`, `_`로 이루어진 별칭만 실행됩니다. 다른 이름은 알림과 함께 거부됩니다.
- 구성 파일의 Windows 줄 끝(CRLF)이 허용됩니다.
- `ARGVUS_SSH_CONFIG`는 구성 파일 경로를 대체하며, 테스트에 유용합니다.

### 명령어

```sh
argvus ssh list          # prints the configured hosts, one per line
argvus ssh open myhost   # opens a specific host without the picker
```
### 문제 해결

| 증상 | 원인 및 해결 방법 |
| --- | --- |
| "~/.ssh/config에서 호스트를 찾을 수 없음" 알림 | 파일이 없거나 `Host` 줄이 없습니다. `argvus ssh list`을 실행하여 확인하십시오. |
| 선택기에서 호스트가 누락됨 | 이것은 와일드카드이거나 `Include` 파일에서 왔거나 허용된 문자 집합 외의 문자를 포함하고 있습니다. 일반 별칭으로 메인 파일에 넣으십시오. |
| 창이 즉시 오류 상태를 표시함 | 일반 터미널에서 `ssh <host>`을 실행하여 전체 메시지를 확인하십시오(도달할 수 없는 호스트, 잘못된 키 등). |
| 창에 텍스트 대신 `message.ssh_session_ended` 표시됨 | 설치된 `argvus` 패키지가 이 버전보다 오래되었습니다. `argvus`을 업데이트하십시오. |

`openssh` 및 `argvus`(`argvus terminal` 명령 필요)

## SSH 키 (`argvus keys`)

`argvus keys`는 `~/.ssh`의 키 쌍과 ssh-agent가 보유한 키를 관리합니다. 단축키는 없습니다. 제어 센터(응용 프로그램)의 **SSH 키** 페이지는 동일한 명령을 사용합니다.

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
모든 명령에 적용되는 규칙:

- 키 이름은 `~/.ssh` 아래의 파일 이름이 되므로 문자, 숫자, 점, 하이픈 및 밑줄만 포함할 수 있습니다. 점으로 시작하거나 `.pub`로 끝날 수 없습니다. 기존 쌍은 결코 덮어쓰지 않습니다.
- 공개 파일(`NAME.pub`)이 있는 쌍만 목록에 표시되며, 그런 파일만 로드, 언로드 또는 삭제할 수 있습니다.
- 암호 문구는 절대 명령 인수로 전달되거나 로그에 기록되거나 제어 센터에 표시되지 않습니다. `load` 및 `generate --passphrase`는 ARGVUS 터미널을 열고 OpenSSH는 해당 터미널에서 비밀을 읽습니다.
- `list`는 에이전트에 접근할 수 없을 때 loaded 열에서 `unknown`를 보고합니다. 결코 추측하지 않습니다.
-  `loaded` `delete`는 개인 키를 영구적으로 제거합니다. 여전히 필요한 키는 복사본을 유지하십시오.
- `ARGVUS_SSH_DIR`는 `~/.ssh`를 대체하며, 테스트에 유용합니다.

에이전트는 argvus-session에 의해 시작된 `argvus-ssh-agent.service` 사용자 서비스입니다.  `argvus-session` `SSH_AUTH_SOCK`는 세션에서 그것을 가리킵니다.

`openssh`(`ssh-keygen` 및 `ssh-add`)와 `argvus`(`argvus terminal` 명령)을 필요로 합니다.

| 증상 | 원인과 해결 방법 |
| --- | --- |
| `load`가 터미널을 열지만 키가 로드되지 않음 | 해당 터미널에 비밀번호를 입력하세요. 요청되지 않았다면 `ssh-add -l`를 실행하여 에이전트가 보유한 내용을 확인하세요. |
| 터미널에 `Could not open a connection to your authentication agent`가 표시됨 | 에이전트보다 먼저 Hyprland가 시작되어 터미널에 `SSH_AUTH_SOCK`가 없습니다. 런처는 `$XDG_RUNTIME_DIR/ssh-agent.socket`로 대체되므로 `argvus-launcher`를 업데이트하고 새 터미널을 열어주세요. |
| `list`가 loaded 열에서 `unknown`를 표시함 | 에이전트에 접근할 수 없습니다.  `loaded` `systemctl --user status argvus-ssh-agent.service`와 `SSH_AUTH_SOCK` 변수를 확인하세요. |
| `delete`가 키가 로드되었다고 보고함 | 먼저 `argvus keys unload NAME`를 실행한 후 다시 삭제하세요. |
| `generate`가 이미 이름이 존재한다고 보고함 | 다른 이름을 선택하세요. 기존 쌍은 절대 대체되지 않습니다. |

## GPG 키 (`argvus gpg`)

`argvus gpg`는 GPG 키를 나열, 생성 및 내보내고 공개 키를 가져옵니다. gpg-agent는 항상 `pinentry-gtk`를 사용합니다: ARGVUS는 키를 생성하기 전에 pinentry를 `gpg-agent.conf`에 기록합니다. 단축키가 없습니다. 제어 센터의 **GPG 키** 페이지는 동일한 명령을 사용합니다.

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
`generate`는 다음 옵션을 사용합니다:

- `--algo rsa|dsa`는 키 알고리즘을 선택합니다. 기본값은 `rsa`입니다.
- `--bits`는 키 크기를 선택합니다. RSA는 `1024`, `2048`, `3072` 및 `4096`를 허용하며 기본값은 `4096`입니다. DSA는 `1024`, `2048` 및 `3072`를 허용하며 기본값은 `2048`입니다; gpg는 더 큰 DSA 키를 생성할 수 없으므로 `4096`는 gpg 실행 전에 거부됩니다.
- `--expire`는 만료 없음으로 `0`를 사용하고, `d`, `w`, `m` 또는 `y`가 붙은 숫자(예: `2y`), 또는 실제 날짜여야 하는 ISO 날짜 `YYYY-MM-DD`를 사용합니다.
- `--passphrase-stdin`는 표준 입력의 첫 번째 줄에서 암호를 읽습니다. 제어 센터에서 사용합니다. 빈 줄은 거부됩니다.
- `--no-passphrase --yes`는 보호되지 않은 키를 생성합니다. 두 가지 암호 모드는 결합할 수 없습니다.

각 키는 하나의 인증 및 서명용 기본 키와 하나의 암호화 하위 키를 받아 파일을 암호화하고 커밋 및 패키지에 서명할 수 있습니다. 하위 키는 기본 키와 일치합니다: RSA의 경우 동일한 크기의 `rsa`, DSA의 경우 DSA 표준이 요구하는 페어링을 가진 동일한 크기의 `elg`입니다.

모든 명령에 적용되는 규칙:

- 암호 구문(passphrase)은 명령 인수로 전달되지 않으며, 로그에 기록되거나 제어 센터에 표시되지 않습니다. `--passphrase-stdin` 옵션이 있으면 암호 구문이 파이프를 통해 파일 디스크립터 0으로 gpg에 전달됩니다. 해당 옵션이 없으면 gpg는 `gpg-agent`가 여는 pinentry 창을 통해 암호를 묻습니다.
- `--no-passphrase`는 보호되지 않은 상태로 개인 키를 저장합니다. `--yes`도 제공되지 않으면 거부됩니다.
- `import`는 ASCII 또는 바이너리 형식의 비밀 키 패킷이 포함된 파일은 모두 거부합니다. 개인 키는 `export-private`를 통해서만 키링에서 나가며, 이때 `--yes`가 필요하고 `600` 모드로 기록됩니다; `import-private`는 이를 다시 가져옵니다.
- 키를 변경하거나 게시하는 명령(`export-private`, `delete`, `edit sign`, `edit revoke`, `keyserver send`)은 `--yes`가 필요합니다. 컨트롤 센터는 자체 확인 후에만 이를 전달합니다.
- 비밀 키를 사용하는 명령은 `--no-tty`와 함께 gpg를 실행하므로 gpg는 터미널을 열려고 하지 않습니다. 암호 문구는 `generate --passphrase-stdin`를 제외하고 pinentry 창에서 가져옵니다.
- `generate`는 gpg-agent가 `pinentry-gtk`를 사용하도록 합니다. 이 줄은 `# BEGIN argvus-managed pinentry`와 `# END argvus-managed pinentry` 마커 사이에 작성되며, 나머지 `gpg-agent.conf`는 유지되고 이전 파일은 `gpg-agent.conf.bak`로 저장됩니다. 블록에 이미 `pinentry-gtk`가 명시되어 있는 경우, 파일과 gpg-agent는 그대로 유지됩니다. 명령은 `gpg-agent.conf`가 이미 해당 블록 외부에서 `pinentry-program`를 설정한 경우 실행을 거부하므로 두 값이 충돌하지 않습니다.
- 패키지를 설치해도 `~/.gnupg`에는 절대 기록되지 않습니다. 키가 생성될 때만 구성 변경이 이루어집니다.
- `GNUPGHOME`는 `~/.gnupg`를 대체하며, 테스트에 유용합니다.

`gnupg`와 `pinentry`는 필수 종속 항목입니다: 키 명령어는 gpg가 필요하며, 암호문 입력 창은 `pinentry-gtk`입니다.

| 증상 | 원인 및 해결 방법 |
| --- | --- |
| `generate`가 암호문 입력 창을 열지 않음 | `argvus gpg status`를 확인하세요. `pinentry-gtk`가 설치되어 있어야 하며, 세션이 `WAYLAND_DISPLAY` 또는 `DISPLAY`를 노출해야 합니다. |
| `generate`가 `pinentry-gtk`가 설치되어 있지 않다고 보고 | `pinentry` 패키지를 설치하세요. |
| `generate`가 ARGVUS 블록 외부에 `pinentry-program` 라인이 있다고 보고 | `~/.gnupg/gpg-agent.conf`에서 그 라인을 제거한 후 다시 명령어를 실행하세요. |
| `generate`가 키 크기를 지원하지 않는다고 보고 | 알고리즘 크기를 확인하세요: DSA는 3072 비트에서 멈춥니다. |
| `generate`는 암호화 하위 키를 추가할 수 없다고 보고합니다 | 키가 생성되었습니다. `gpg --quick-add-key FINGERPRINT cv25519 encr 2y`로 하위 키를 추가하거나, `gpg --delete-secret-and-public-key`로 키를 삭제하고 다시 생성하십시오. |
| `import`는 파일을 거부합니다 | 파일에 개인 키가 포함되어 있습니다. 다른 기기에서는 `argvus gpg export-public`로 공개 키만 내보내십시오. |
| `list`는 키가 없다고 표시합니다 | `GNUPGHOME`(또는 `~/.gnupg`)의 키링이 비어 있습니다. `argvus gpg generate`를 실행하여 키를 생성하십시오. |

## 스니펫 (`SUPER + ALT + N`)

`SUPER + ALT + N`는 스니펫 선택기를 엽니다. 선택한 스니펫은 클립보드를 거치지 않고 커서 위치가 있는 포커스된 창에 입력됩니다.

### 설정

이름과 텍스트를 가진 스니펫을 추가하세요:

```sh
argvus snippets add "email" "you@example.com"
```
저장되었는지 확인하세요:

```sh
argvus snippets list
```
스니펫은 argvus config의 `snippets` 섹션에  `argvus config` `{name, content}` 항목으로 저장됩니다. `argvus config get /snippets/items`를 사용하여 읽을 수 있습니다.

### 사용법

1. 텍스트를 받을 애플리케이션의 텍스트 필드를 클릭합니다.
2. `SUPER + ALT + N`를 누릅니다.
3. 이름으로 스니펫을 선택하고 `Enter`를 누릅니다. 텍스트가 커서 위치에 입력됩니다.

### 명령

```sh
argvus snippets add "NAME" "CONTENT"   # adds a snippet, or replaces the one with the same name
argvus snippets remove NAME            # removes a snippet
argvus snippets list                   # prints index and name, one per line
argvus snippets open NAME              # types a snippet by name
argvus snippets open 2                 # types the snippet at position 2 of `list`
argvus snippets                        # opens the picker (same as the shortcut)
argvus snippets --help                 # shows the options and an example
```
### 규칙

- 이름은 고유하며 대소문자를 구분합니다. 기존 이름과 동일한 이름의 스니펫을 추가하면 해당 내용이 대체됩니다.
- 내용은 비워둘 수 없습니다: 빈 스니펫은 찾을 수 없는 것으로 보고됩니다.
- `open`는 숫자로만 된 이름을 위치로 간주합니다. 혼동을 피하기 위해 `code2`와 같이 문자가 포함된 이름을 사용하세요.
- 위치는 `list`에 표시된 순서를 나타냅니다. 스니펫을 삭제하면 그 이후 스니펫들의 위치가 이동합니다.

### 문제 해결

| 증상 | 원인 및 해결 방법 |
| --- | --- |
| 단축키를 눌렀을 때 "스니펫 없음" 알림 | 스니펫이 아직 추가되지 않았습니다. 먼저 `argvus snippets add`를 실행하세요. |
| `open`가 스니펫을 찾을 수 없다고 보고 | 이름이 정확히 일치하지 않습니다. `argvus snippets list`와 비교하세요. |
| 애플리케이션에 아무것도 나타나지 않음 | 포커스된 창이 텍스트 필드가 아니거나, XWayland 하에서 실행 중인 X11 애플리케이션일 수 있으며, 이러한 입력을 무시할 수 있습니다. 네이티브 Wayland 애플리케이션에서 테스트하세요. |

`wtype`, `rofi`, `jq` 및 `argvus`(`argvus config` 명령어)를 요구합니다.

`wtype`는 Wayland 입력 수준에서 키 입력을 시뮬레이션합니다. XWayland 하에서 실행되는 일부 X11 응용 프로그램은 이러한 이벤트를 무시할 수 있으므로, 스니펫이 발견되었더라도 해당 위치에 텍스트가 나타나지 않을 수 있습니다.

## Git (`SUPER + ALT + G`)

`SUPER + ALT + G`는 `SUPER + O`와 동일한 프로젝트 선택기를 엽니다. 프로젝트를 선택하면 `lazygit`(또는 `gitui`)가 현재 워크스페이스의 새로운 ARGVUS 터미널에서 바로 열립니다. 프로젝트를 먼저 선택하는 별도의 단계는 없습니다.

### 설정

두 도구 중 하나를 설치합니다. 두 도구 모두 이 패키지의 선택적 의존성입니다:

```sh
sudo pacman -S lazygit   # or: sudo pacman -S gitui
```
### 사용법

1. `SUPER + ALT + G`를 누르세요.
2. 목록에서 프로젝트를 선택하거나, 취소하려면 `Esc`를 누르세요. 취소하면 아무 것도 열리지 않습니다.
3. 터미널이 프로젝트 디렉토리에서 열리고 TUI가 시작됩니다.

Git 저장소가 아닌 프로젝트는 알림을 표시하고 아무 것도 열지 않습니다. 선택기를 건너뛰려면 디렉토리를 전달하세요:

```sh
argvus git ~/Projects/api
```
### 도구 선택

`argvus-git`는 설치되어 있을 때 `lazygit`를 사용하고, 그렇지 않은 경우 `gitui`를 사용합니다. `gitui`를 우선 사용하려면, 명령에 대해 `ARGVUS_GIT_TUI`를 설정하세요:

```sh
ARGVUS_GIT_TUI=gitui argvus git
```
변수는 스크립트를 실행하는 명령어의 환경에서 읽힙니다. ARGVUS 설정에는 저장되지 않습니다.

### 문제 해결

| 증상 | 원인 및 해결 방법 |
| --- | --- |
| "not a git repository" 알림 | 선택한 프로젝트가 git 저장소가 아니거나 디렉토리가 이동되었습니다. `argvus projects remove`으로 제거하거나 수정하세요. |
| "install lazygit or gitui" 알림 | 두 도구 모두 `PATH`에 없습니다. 둘 중 하나를 설치하세요. |
| 프로젝트 선택기에서 프로젝트가 보이지 않음 | 추가된 프로젝트가 없습니다. `argvus projects add`을 사용하세요. |

## 이모지 선택기 (`SUPER + .`)

`SUPER + .`는 ARGVUS Rofi 설정으로 `rofimoji`을 엽니다. 이름으로 이모지를 검색하고 `Enter`를 누르면 이모지가 클립보드에 복사됩니다. 원하는 애플리케이션에서 `Ctrl + V`로 붙여넣으세요.

선택기가 열려 있는 동안, 세션은 그렇지 않으면 표시될 키보드 레이아웃 알림을 무시합니다. 실행기(Launcher)는 ARGVUS 캐시 디렉터리에 단기 마커를 작성하고 선택기가 닫힌 약 1초 후에 제거합니다.

`rofimoji` 및 `wl-clipboard`가 필요합니다.

## 계산기 (`SUPER + C`)

`SUPER + C`는 ARGVUS Rofi 설정으로 Rofi의 `calc` 모드를 엽니다. 식을 입력하면 결과 목록이 입력 중에 업데이트됩니다. 결과를 선택할 때는 `rofi-calc` 모드가 정의한 방식에 따라 선택합니다.

실행기 패키지는 Rofi 설정을 제공하며 `rofi-calc`에 의존합니다. 바로가기는 `argvus-hyprland`에 의해 선언됩니다.

## 치트시트 (`SUPER + SHIFT + /` 및 `SUPER + CTRL + /`)

`cheatsheets.sh`는 큰 Rofi 창에서 단축키의 읽기 전용 목록을 표시합니다. 인수로 응용 프로그램 이름을 받습니다:

```sh
cheatsheets.sh hypr     # Hyprland shortcuts (SUPER + SHIFT + /)
cheatsheets.sh kitty    # terminal shortcuts (SUPER + CTRL + /)
cheatsheets.sh <name>   # any other application with a cheatsheet
```

- `hypr`는 파일이 존재할 경우 사용자의 ARGVUS 구성에서 `data/generated/hypr/keybindings.txt`를 사용합니다. 파일이 없으면 `argvus-hyprland`와 함께 제공되는 Hyprland 치트시트를 사용합니다.
- `kitty`는 `argvus`와 함께 제공되는 터미널 치트시트를 사용합니다.
- 다른 이름은 `<name>/docs/cheatsheets/<language>.txt`를 읽습니다. 해당 파일이 존재하지 않으면 창이 열리지 않습니다.

시스템 로케일이 `pt-BR`일 때 언어는 포르투갈어이고, 그 외에는 영어입니다. `Esc`는 창을 닫습니다. 줄을 선택하면 단지 닫기만 하고 아무 것도 실행되지 않습니다.

## Rofi 구성을 사용하는 다른 메뉴들

런처 구성은 다른 패키지가 소유한 구성 요소와 공유됩니다:

- 클립보드 기록(`SUPER + H`)과 그 지우기 단축키(`SUPER + SHIFT + H`)는 `argvus-hyprland`에 의해 선언됩니다. 이들은 이 설정과 함께 `cliphist`를 Rofi로 전달합니다. `cliphist`는 `argvus-session`에서 나오며, 이 프로그램은 기록을 채우는 클립보드 기록기를 실행합니다; `argvus` 메타 패키지도 이에 의존합니다.
- `argvus-appearance`의 테마, 강조 색상 및 레이아웃 선택기는 `config.rasi`와 함께 Rofi를 엽니다.
- Hyprland 창 규칙은 `argvus-launcher` 및 `rofi` 네임스페이스를 인식하므로 메뉴는 실행기 표면 처리를 받습니다.

## 패키징 및 의존성

패키지 `argvus-launcher`는 아키텍처 독립적이며 다음을 설치합니다:

- 동일한 디렉토리 아래의 `argvus launcher`, `argvus-snippets`, `argvus-ssh` 및 `argvus-git`;
- Rofi 구성과 테마가 포함된 `/usr/share/argvus/launcher/config/`;
-  `/usr/share/argvus/launcher/sh/` `cheatsheets.sh` 및 `emoji-picker.sh`가 포함된 /usr/share/argvus/launcher/sh/.

필수 종속성: `argvus-session`, `argvus-appearance`, `argvus`, `bash`, `jq`, `hyprland`, `libnotify`, `rofi`, `rofi-calc`, `rofimoji`, `wl-clipboard`, `wtype`, `gnupg` 및 `pinentry` (이것은 `pinentry-gtk`를 제공합니다). 선택적 종속성: `openssh`, SSH 선택기 및 SSH 키 관리자를 위해; `lazygit` 및 `gitui`, git TUI용.

패키지를 설치해도 `$HOME`에 쓰지 않습니다. 사용자 구성은 세션 시작 시 생성되며, [Rofi 구성 및 테마](#where-the-active-configuration-lives)]에 설명되어 있습니다.

## 문제 해결

| 증상 | 원인 및 해결 방법 |
| --- | --- |
| `SUPER + D`이 아무 것도 열지 않음 | 터미널에서 `argvus launcher`를 확인하십시오. `rofi`가 설치되어 있고 Rofi 구성이 존재하는지 확인하십시오. |
| `SUPER + D`이 애플리케이션을 표시하지 않음 | 애플리케이션에 데스크탑 항목이 없습니다. `.desktop` 파일이 있는 애플리케이션만 표시됩니다. |
| 메뉴에서 오래된 폰트를 사용함 | 세션 시작 시 `font:` 줄이 다시 작성됩니다. 폰트를 변경한 후 세션을 재시작하세요. |
| 테마 변경이 Rofi 메뉴에 적용되지 않음 | $XDG_CONFIG_HOME/argvus/data/rofi/에 있는 사용자 복사본 `config.rasi`가 여전히 패키지된 테마를 가리키는지 확인하세요.  `$XDG_CONFIG_HOME/argvus/data/rofi/` `argvus-appearance`에서 테마를 다시 적용하세요. |
| `SUPER + O`이 프로젝트를 찾지 못함 | 루트 또는 경로가 설정되지 않았거나, 디렉터리가 더 이상 존재하지 않습니다. `argvus projects list`를 실행하세요. |
| `SUPER + C` 또는 이모지 선택기가 열리지 않음 | `rofi-calc` 또는 `rofimoji`를 설치하세요(둘 다 필요 의존성입니다). |
| 치트시트가 열리지 않음 | 해당 이름과 언어에 대한 파일이 존재하지 않습니다. Cheatsheets 섹션에 설명된 경로를 확인하세요. |
| `SUPER + H`이 아무것도 표시하지 않음 | 기록이 비어 있거나 `argvus-session`의 클립보드 기록기가 아직 아무것도 저장하지 않았습니다. |

## 관련 구성 요소

| 구성 요소 | 책임 |
| --- | --- |
| `argvus-hyprland` | 메뉴용 단축키와 Hyprland 창 규칙을 선언합니다. |
| `argvus-appearance` | 활성 테마, 강조 색상 및 레이아웃을 변경하고 Rofi 테마 참조를 다시 작성합니다. |
| `argvus` (`argvus config`) | 프로젝트, 스니펫 및 기본 런처 설정을 저장합니다. |
| `argvus-session` | 초기 Rofi 구성을 복사하고 세션 시작 시 글꼴을 설정합니다. |
| `argvus` (`argvus terminal`) | SSH 세션, 프로젝트 터미널 및 `argvus keys`의 암호 입력창을 엽니다. |
| `argvus` (`argvus widget-telemetry`) | `argvus projects`에서 작성한 활성 프로젝트를 읽습니다. |
| `argvus` (`argvus i18n`) | 런처 스크립트에서 사용되는 번역된 메시지를 제공합니다. |
| `argvus` (`argvus control-center`) | `argvus projects`를 통해 프로젝트 목록을 편집합니다. |
