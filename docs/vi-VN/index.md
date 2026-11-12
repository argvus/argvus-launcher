---
title: Trình khởi chạy ứng dụng
description: Khởi chạy ứng dụng, mở dự án, máy chủ SSH và đoạn mã, chọn emoji, tính toán và đọc danh sách mẹo thông qua các menu Rofi của ARGVUS.
---

`argvus-launcher` cung cấp cấu hình Rofi, các chủ đề và menu mà ARGVUS sử dụng để mở các thứ từ bàn phím. Nó bao gồm:

- trình khởi chạy ứng dụng (`SUPER + D`);
- cấu hình Rofi và các chủ đề được chia sẻ bởi mọi menu Rofi của ARGVUS;
- trình chuyển đổi dự án, trình chọn SSH và trình chọn đoạn mã (`argvus projects`, `argvus ssh`, `argvus snippets`);
- trình quản lý khóa SSH (`argvus keys`), tạo, liệt kê, tải và xóa các cặp khóa;
- trình quản lý khóa GPG (`argvus gpg`), liệt kê, tạo và xuất khóa và thiết lập pinentry-gtk cho gpg-agent;
- trình chọn emoji, trình xem bảng tóm tắt mẹo và menu máy tính.

Các phím tắt được khai báo bởi `argvus-hyprland`. Gói này cung cấp các lệnh và các menu đứng sau chúng.

## Phím tắt

| Phím tắt | Hành động | Lệnh | Phần |
| --- | --- | --- | --- |
| `SUPER + D` | Trình khởi chạy ứng dụng | `argvus launcher` | Trình khởi chạy ứng dụng |
| `SUPER + O` | Chuyển đổi dự án | `argvus projects` | Chuyển đổi dự án |
| `SUPER + ALT + 1` to `9` | Mở dự án ở vị trí đó | `argvus projects open N` | Project switcher |
| `SUPER + ALT + S` | Bộ chọn máy chủ SSH | `argvus ssh` | SSH |
| `SUPER + ALT + N` | Bộ chọn đoạn trích | `argvus snippets` | Đoạn trích |
| `SUPER + ALT + G` | Bộ chọn dự án, sau đó git TUI | `argvus git` | Git |
| `SUPER + .` | Bộ chọn biểu tượng cảm xúc | `emoji-picker.sh` | Bộ chọn biểu tượng cảm xúc |
| `SUPER + C` | Máy tính | `rofi -show calc` | Máy tính |
| `SUPER + SHIFT + /` | Bảng cheat Hyprland | `cheatsheets.sh hypr` | Cheatsheet |
| `SUPER + CTRL + /` | Áo khoác Kitty | `cheatsheets.sh kitty` | Cheatsheet |

## Trình khởi chạy ứng dụng (`SUPER + D`)

`SUPER + D` chạy `argvus launcher`, mở Rofi ở chế độ `drun`. Nó liệt kê các ứng dụng đồ họa đã cài đặt với một mục trình đơn, và ứng dụng được chọn sẽ khởi chạy khi bạn nhấn `Enter`.

1. Nhấn `SUPER + D`.
2. Gõ một phần của tên ứng dụng. Danh sách được sắp xếp và bộ lọc không phân biệt chữ hoa chữ thường.
3. Nhấn `Enter` để khởi động ứng dụng, hoặc `Esc` để đóng menu.

```sh
argvus launcher                  # opens the application menu
argvus launcher --config PATH    # uses another Rofi configuration file
```

Bất kỳ đối số nào khác sẽ được chuyển cho `rofi`. `--config` không có giá trị sẽ dừng với lỗi.

Hyprland chạy `argvus launcher --config <Rofi configuration>` khi trình khởi chạy mặc định là `rofi`, đây là mặc định. Nếu `launcher` mặc định trong các ứng dụng mặc định được đặt thành một chương trình khác, Hyprland sẽ chạy `<program> --show drun` thay thế. Đặt nó trong các ứng dụng mặc định của Trung tâm Điều khiển, nơi lưu giá trị trong `argvus-config`.

Chỉ những ứng dụng có mục nhập trên máy tính để bàn mới xuất hiện trong danh sách. Một ứng dụng không cài đặt tệp `.desktop` sẽ không thể tìm thấy ở đây.

## Cấu hình và giao diện của Rofi

Gói cài đặt cấu hình Rofi dưới `/usr/share/argvus/launcher/config/`:

| Tập tin | Vai trò |
| --- | --- |
| `config.rasi` | Điểm vào được mọi menu ARGVUS sử dụng. Đặt Rofi `configuration` (phông chữ, không có biểu tượng, danh sách được sắp xếp, khớp không phân biệt chữ hoa chữ thường) và nhập `theme.rasi`. |
| `theme.rasi` | Màu sắc và bố cục của cửa sổ, thanh nhập liệu và danh sách. Nhập một chủ đề và tệp chế độ. |
| `mode.rasi` | Ghi đè chế độ. Tệp được đóng gói không có ghi đè và giữ chế độ Tối. |
| `themes/<family>/theme.rasi` | Bảng màu của nhóm chủ đề, ví dụ `argvus-dark` hoặc `tokyo-night`. |
| `themes/<family>-spaced/theme.rasi` | Biến thể cách nhau của cùng một gia đình. |

Gói cung cấp 22 họ, và mỗi họ có một biến thể `-spaced`. Gói `theme.rasi` nhập `argvus-dark`.

### Nơi cấu hình đang hoạt động tồn tại

ARGVUS giải quyết từng tệp Rofi thông qua `paths_config`. Tệp tồn tại đầu tiên trong số các ghi đè của người dùng, bản sao của người dùng, các vị trí cũ và cây được tạo sẽ thắng; nếu không, tệp được đóng gói dưới `/usr/share/argvus/launcher/config/` sẽ được sử dụng. Bản sao của người dùng của một tệp là `$XDG_CONFIG_HOME/argvus/data/rofi/<file>`: tiền tố `launcher/config/` được lưu dưới `rofi/`.

ARGVUS tạo một bản sao cho người dùng lần đầu tiên một script ARGVUS thay đổi tệp đó; `argvus-appearance` thực hiện điều này cho các thay đổi về chủ đề, màu sắc và chế độ. Các tệp chưa bao giờ bị thay đổi tiếp tục được đọc từ gói, và bản sao của người dùng được ưu tiên hơn tệp trong gói.

Khi `argvus-session` áp dụng phông chữ vào lúc bắt đầu phiên, nó sẽ ghi lại dòng `font:` của `config.rasi` từ cài đặt phông chữ ARGVUS. Việc chỉnh sửa đó chỉ ảnh hưởng đến bản sao của người dùng. Cho đến khi bản sao tồn tại, tệp đã đóng gói là tệp được tìm thấy, và người dùng không thể ghi vào nó, vì vậy thay đổi phông chữ có hiệu lực khi thay đổi xuất hiện đầu tiên đã tạo ra bản sao.

### Thay đổi chủ đề

`argvus-appearance` sở hữu các thay đổi giao diện. Khi giao diện thay đổi, nó viết lại các bản sao người dùng để `config.rasi` trỏ tới `theme.rasi` mới, và `theme.rasi` nhập bảng màu trình khởi chạy của bản dựng giao diện (`~/.config/argvus/data/generated/theme/current/launcher/theme.rasi`), bao gồm gia đình, bố cục và màu nổi bật đang hoạt động. Nếu không có bản dựng giao diện, nó nhập bản sao gia đình, và bố cục Spaced chọn biến thể `-spaced` của gia đình đang hoạt động. Các trình chọn giao diện như menu giao diện và menu bố cục đọc cùng `config.rasi`, nên chúng cũng sử dụng kiểu đang hoạt động.

Không chỉnh sửa các tệp dưới `/usr/share/argvus/launcher/`; chúng sẽ bị thay thế khi nâng cấp gói. Thực hiện các thay đổi trong bản sao người dùng, dưới `$XDG_CONFIG_HOME/argvus/data/rofi/`.

## Bộ chuyển đổi dự án (`SUPER + O`)

`argvus projects` (`SUPER + O`) liệt kê các dự án bạn đã thêm và mở dự án được chọn trong không gian làm việc Hyprland riêng của nó, với một `argvus terminal` trong thư mục của nó. Nếu không gian làm việc của dự án đã tồn tại, công cụ chuyển chỉ tập trung vào nó.

Để truy cập chỉ bằng bàn phím, `SUPER + ALT + 1` đến `SUPER + ALT + 9` mở dự án ở vị trí đó trong danh sách, mà không cần menu. Các vị trí là các số hiển thị trong menu. Chúng theo thứ tự danh sách, vì vậy thêm hoặc bỏ bớt một dự án có thể thay đổi chúng. `argvus projects open <number or directory name>` làm tương tự từ terminal, và các lỗi sẽ được hiển thị dưới dạng thông báo.

Danh sách dự án hiệu quả bị giới hạn ở 9, vì đó là tất cả những gì `SUPER + ALT + 1..9` có thể xử lý. `argvus projects add` (và trang Dự án của Trung tâm Điều khiển, nơi gọi nó) từ chối thêm một dự án hoặc gốc nếu việc đó làm tổng số vượt quá 9, và thay vào đó báo lỗi.

Một dự án xuất phát từ hai nơi trong phần `projects` của `argvus-config`:

- `paths`: các thư mục dự án cá nhân.
- `roots`: các thư mục mà các thư mục con trực tiếp của chúng là dự án. Một thư mục gốc không tồn tại sẽ bị bỏ qua.

Mặc định không có thư mục gốc hoặc đường dẫn nào được cấu hình; hãy thêm ít nhất một thư mục trước khi `SUPER + O` có thể liệt kê bất cứ điều gì.

Quản lý chúng từ terminal:

```sh
argvus projects add ~/Work/api          # one project
argvus projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus projects remove ~/Work/api       # removes it from paths and roots
argvus projects list                    # prints the roots and paths
```

`argvus projects pick` hiển thị cùng một danh sách và in ra đường dẫn đã chọn thay vì mở nó. Các công cụ khác có thể sử dụng nó, như `argvus git` làm. Hủy bỏ sẽ không in ra gì.

Nếu không có gốc hoặc đường dẫn, `SUPER + O` báo rằng không tìm thấy dự án nào. Một lệnh trình soạn thảo tùy chọn, `/projects/editor`, sẽ khởi động trong cùng một không gian làm việc khi không gian làm việc được tạo.

Các mục được đọc từ cấu hình hiệu lực; trình khởi chạy không giữ bản sao nào của chúng.

Mở một dự án cũng ghi lại đường dẫn của nó như dự án hoạt động cho phiên, mà khối thu thập dữ liệu telemetry của Dev Dashboard (`argvus widget-telemetry`) đọc để báo cáo git, cổng lắng nghe và các container của dự án đó.

## SSH (`SIÊU + ALT + S`)

`SUPER + ALT + S` mở một trình chọn với các máy chủ được định nghĩa trong `~/.ssh/config`. Máy chủ được chọn sẽ mở trong một terminal ARGVUS mới chạy `ssh <host>`, trong không gian làm việc hiện tại.

### thiết lập

Thêm một mục `Host` cho mỗi máy chủ vào `~/.ssh/config`:

```ini
Host myhost
    HostName myhost.local
    User boss
    IdentityFile ~/.ssh/myhost
    IdentitiesOnly yes
```

Xác nhận rằng `ssh myhost` hoạt động trong một terminal bình thường trước. Trình khởi chạy chỉ chạy `ssh`; xác thực, khóa và xác minh máy chủ được xử lý bởi OpenSSH.

### sử dụng

1. Nhấn `SUPER + ALT + S`.
2. Gõ một phần tên máy chủ, hoặc sử dụng các phím mũi tên.
3. Nhấn `Enter`. Terminal sẽ mở và chạy `ssh <host>`.

Khi phiên làm việc kết thúc, cửa sổ vẫn mở và hiển thị trạng thái thoát, ví dụ `ssh exited with status 0. Press Enter to close.` Nhấn `Enter` để đóng nó. Điều này quan trọng đối với các dịch vụ như GitHub, GitLab và Gitea: chúng xác thực bạn và đóng kết nối ngay lập tức vì chúng không cung cấp shell. Cửa sổ giữ thông báo của họ trên màn hình thay vì biến mất.

### Quy tắc

- Các mục wildcard (`Host *`, `Host *.internal`) là các khối khớp, không phải mục tiêu, và không bao giờ được liệt kê.
- Mỗi bí danh trên một dòng `Host` được liệt kê riêng biệt (`Host a b` liệt kê `a` và `b`). Các mục trùng lặp được loại bỏ.
- Các máy chủ chỉ được định nghĩa trong các tệp được tải với `Include` sẽ không được liệt kê; bộ chọn chỉ đọc tệp chính.
- Chỉ các bí danh được tạo từ chữ cái, chữ số, `.`, `-` và `_` mới được khởi chạy. Bất kỳ tên nào khác sẽ bị từ chối kèm theo thông báo.
- Kết thúc dòng của Windows (CRLF) trong cấu hình được chấp nhận.
- `ARGVUS_SSH_CONFIG` thay thế đường dẫn của tệp cấu hình, điều này hữu ích cho việc kiểm tra.

### Lệnh

```sh
argvus ssh list          # prints the configured hosts, one per line
argvus ssh open myhost   # opens a specific host without the picker
```

### Khắc phục sự cố

| Triệu chứng | Nguyên nhân và cách khắc phục |
| --- | --- |
| Thông báo "không tìm thấy máy chủ trong ~/.ssh/config" | Tệp tin bị thiếu hoặc không có`Host` lines. Run `argvus ssh list` to check. |
| A host is missing from the picker | It is a wildcard, comes from an `Include`tệp, hoặc có các ký tự nằm ngoài tập hợp cho phép. Đặt nó vào tệp chính với một bí danh đơn giản. |
| Cửa sổ hiển thị ngay trạng thái lỗi | Chạy `ssh <host>` trong một thiết bị đầu cuối bình thường để xem thông báo đầy đủ (máy chủ không thể truy cập, khóa sai, v.v.). |
| Cửa sổ hiển thị `message.ssh_session_ended` thay vì văn bản | Gói `argvus` đã cài đặt cũ hơn phiên bản này. Cập nhật `argvus`. |

Yêu cầu `openssh` và `argvus` (lệnh `argvus terminal`).

## Khóa SSH (`argvus keys`)

`argvus keys` quản lý các cặp khóa trong `~/.ssh` và các khóa do ssh-agent giữ. Nó không có phím tắt. Trang **SSH keys** của Trung tâm Điều khiển (Applications) sử dụng cùng các lệnh.

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

Quy tắc áp dụng cho mọi lệnh:

- Một tên khóa trở thành tên tập tin dưới `~/.ssh`, vì vậy nó chỉ có thể chứa chữ cái, chữ số, dấu chấm, dấu gạch ngang và dấu gạch dưới. Nó không thể bắt đầu bằng dấu chấm hoặc kết thúc bằng `.pub`. Một cặp hiện có sẽ không bao giờ bị ghi đè.
- Chỉ các cặp với tập tin công khai (`NAME.pub`) được liệt kê, và chỉ những cặp này có thể được tải, gỡ hoặc xóa.
- Các cụm mật khẩu không bao giờ được truyền dưới dạng đối số lệnh, ghi vào nhật ký hoặc hiển thị trong Trung tâm Điều khiển. `load` và `generate --passphrase` mở một terminal ARGVUS, và OpenSSH đọc thông tin bí mật từ terminal đó.
- `list` báo `unknown` trong cột `loaded` khi không thể kết nối với tác nhân. Nó không bao giờ đoán.
-

 removes the private key for good. Keep a copy of any key you still need.
-

 replaces

, which is useful for testing.

The agent is the

 user service started by

.

 points to it in the session.

Yêu cầu  SSH_AUTH_SOCK  argvus-session  argvus-ssh-agent.service  ~/.ssh  ARGVUS_SSH_DIR  `delete`  `ARGVUS_SSH_DIR`  `~/.ssh`  `argvus-ssh-agent.service`  `argvus-session`  `SSH_AUTH_SOCK` `openssh` (`ssh-keygen` và `ssh-add`) và `argvus` (lệnh `argvus terminal`). Khóa GPG

| Triệu chứng | Nguyên nhân và cách khắc phục |
| --- | --- |
| `load` mở terminal nhưng phím không được tải | Nhập cụm mật khẩu vào thiết bị đầu cuối đó. Nếu nó không được hỏi, hãy chạy `ssh-add -l` để xem tác nhân nắm giữ những gì. |
| Thiết bị đầu cuối hiển thị `Could not open a connection to your authentication agent` | Hyprland bắt đầu trước khi đại lý thực hiện, vì vậy thiết bị đầu cuối của nó thiếu `SSH_AUTH_SOCK`. Trình khởi chạy sẽ quay trở lại `$XDG_RUNTIME_DIR/ssh-agent.socket`, vì vậy hãy cập nhật`argvus-launcher` và mở một thiết bị đầu cuối mới. |
| `list` hiển thị `unknown` trong cột `loaded` | Các đại lý không thể truy cập được. Kiểm tra `systemctl --user status argvus-ssh-agent.service` và biến `SSH_AUTH_SOCK`. |
| `delete`báo cáo rằng chìa khóa đã được nạp | Chạy `argvus keys unload NAME` first, then delete it again. |
| `generate` báo cáo rằng tên đã tồn tại | Chọn một tên khác. Các cặp hiện có không bao giờ được thay thế. |

## (`argvus gpg`)

`argvus gpg` liệt kê, tạo và xuất các khóa GPG và nhập các khóa công khai. gpg-agent luôn sử dụng `pinentry-gtk`: ARGVUS ghi pinentry vào `gpg-agent.conf` trước khi nó tạo một khóa. Nó không có phím tắt. Trang **khóa GPG** của Trung tâm điều khiển sử dụng cùng các lệnh.

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

`generate` nhận các tùy chọn này:

- `--algo rsa|dsa` chọn thuật toán khóa. Mặc định là `rsa`.
- `--bits` chọn kích thước khóa. RSA chấp nhận `1024`, `2048`, `3072` và `4096`, với `4096` làm mặc định. DSA chấp nhận `1024`, `2048` và `3072`, với `2048` làm mặc định; gpg không thể tạo các khóa DSA lớn hơn, vì vậy `4096` bị từ chối trước khi gpg chạy.
- `--expire` lấy `0` mà không hết hạn, một số theo sau bởi `d`, `w`, `m` hoặc `y` (chẳng hạn như `2y`), hoặc một ngày theo chuẩn ISO `YYYY-MM-DD`, phải là một ngày thực.
- `--passphrase-stdin` đọc cụm mật khẩu từ dòng đầu tiên của đầu vào tiêu chuẩn. Trung tâm Điều khiển sử dụng nó. Một dòng trống sẽ bị từ chối.
- `--no-passphrase --yes` tạo một khóa không được bảo vệ. Hai chế độ mật khẩu không thể kết hợp.

Mỗi khóa nhận một khóa chính để chứng thực và ký và một khóa phụ để mã hóa, vì vậy nó có thể mã hóa các tệp cũng như ký các cam kết và gói. Khóa phụ khớp với khóa chính: `rsa` với cùng kích thước cho RSA, và `elg` với cùng kích thước cho DSA, đây là sự kết hợp mà tiêu chuẩn DSA yêu cầu.

Quy tắc áp dụng cho mọi lệnh:

- Cụm mật khẩu không bao giờ được truyền dưới dạng đối số lệnh, ghi vào nhật ký hoặc hiển thị trong Trung tâm Điều khiển. Với `--passphrase-stdin`, cụm mật khẩu sẽ đi tới gpg trên mô tả tệp 0 từ một ống. Nếu không có tùy chọn đó, gpg sẽ yêu cầu cửa sổ pinentry, mà `gpg-agent` mở ra.
- `--no-passphrase` lưu khóa riêng mà không có bảo vệ. Nó sẽ bị từ chối trừ khi `--yes` cũng được cung cấp.
- `import` từ chối bất kỳ tập tin nào chứa gói khóa bí mật, dưới dạng ASCII hoặc nhị phân. Khóa riêng chỉ rời khỏi khóa vòng thông qua `export-private`, điều này cần `--yes` và chế độ ghi `600`; `import-private` mang chúng trở lại.
- Các lệnh thay đổi hoặc xuất bản khóa (`export-private`, `delete`, `edit sign`, `edit revoke`, `keyserver send`) cần `--yes`. Trung tâm điều khiển chỉ truyền nó sau khi xác nhận của chính nó.
- Các lệnh sử dụng khóa bí mật chạy gpg với `--no-tty`, vì vậy gpg không bao giờ cố gắng mở một terminal. Mật khẩu đến từ cửa sổ pinentry, ngoại trừ trong `generate --passphrase-stdin`.
- `generate` làm cho gpg-agent sử dụng `pinentry-gtk`. Nó ghi dòng đó giữa các dấu `# BEGIN argvus-managed pinentry` và `# END argvus-managed pinentry`, giữ phần còn lại của `gpg-agent.conf`, và lưu tệp trước đó dưới tên `gpg-agent.conf.bak`. Khi khối đã đặt tên `pinentry-gtk`, tệp và gpg-agent được giữ nguyên như cũ. Lệnh từ chối thực hiện khi `gpg-agent.conf` đã đặt `pinentry-program` bên ngoài khối đó, để hai giá trị không bao giờ xung đột.
- Việc cài đặt gói chưa bao giờ ghi vào `~/.gnupg`. Cấu hình chỉ thay đổi khi một khóa được tạo ra.
- `GNUPGHOME` thay thế `~/.gnupg`, điều này hữu ích cho việc thử nghiệm.

`gnupg` và `pinentry` là các phụ thuộc cần thiết: các lệnh khóa cần gpg, và cửa sổ mật khẩu là `pinentry-gtk`.

| Triệu chứng | Nguyên nhân và cách khắc phục |
| --- | --- |
| `generate` không mở cửa sổ cụm mật khẩu | Kiểm tra `argvus gpg status`. `pinentry-gtk` phải được cài đặt và phiên phải hiển thị `WAYLAND_DISPLAY` hoặc `DISPLAY`. |
| `generate` báo cáo rằng `pinentry-gtk` chưa được cài đặt | Cài đặt gói `pinentry`. |
| `generate` báo cáo dòng `pinentry-program` bên ngoài khối ARGVUS | Xóa dòng đó khỏi `~/.gnupg/gpg-agent.conf`, sau đó chạy lại lệnh. |
| `generate` báo cáo rằng kích thước khóa không được hỗ trợ | Kiểm tra kích thước cho thuật toán: DSA dừng ở 3072 bit. |
| `generate` báo cáo rằng không thể thêm khóa con mã hóa | Chìa khóa đã được tạo. Thêm khóa con bằng `gpg --quick-add-key FINGERPRINT cv25519 encr 2y` hoặc xóa khóa bằng `gpg --delete-secret-and-public-key` và tạo lại. |
| `import` từ chối một tập tin | Tệp chứa khóa riêng. Chỉ xuất khóa chung trên máy khác có `argvus gpg export-public`. |
| `list` shows no keys | The keyring in `GNUPGHOME` (or `~/.gnupg`) is empty. Run `argvus gpg generate`tạo một chìa khóa. |

## Đoạn trích (`SUPER + ALT + N`)

`SUPER + ALT + N` mở một trình chọn với các đoạn trích của bạn. Đoạn trích đã chọn sẽ được nhập vào cửa sổ đang được tập trung, tại con trỏ, thay vì đi qua khay nhớ tạm.

### thiết lập

Thêm một đoạn trích với tên và văn bản của nó:

```sh
argvus snippets add "email" "you@example.com"
```

Kiểm tra xem nó đã được lưu chưa:

```sh
argvus snippets list
```

Các đoạn trích được giữ trong phần `snippets` của `argvus config`, dưới dạng các mục `{name, content}`. Bạn có thể đọc chúng bằng `argvus config get /snippets/items`.

### sử dụng

1. Nhấp vào trường văn bản của ứng dụng mà nên nhận văn bản.
2. Nhấn `SUPER + ALT + N`.
3. Chọn đoạn trích theo tên và nhấn `Enter`. Văn bản sẽ được gõ vào nơi con trỏ đang ở.

### Lệnh

```sh
argvus snippets add "NAME" "CONTENT"   # adds a snippet, or replaces the one with the same name
argvus snippets remove NAME            # removes a snippet
argvus snippets list                   # prints index and name, one per line
argvus snippets open NAME              # types a snippet by name
argvus snippets open 2                 # types the snippet at position 2 of `list`
argvus snippets                        # opens the picker (same as the shortcut)
argvus snippets --help                 # shows the options and an example
```

### Quy tắc

- Tên là duy nhất và phân biệt chữ hoa chữ thường. Thêm một đoạn mã với tên đã tồn tại sẽ thay thế nội dung của nó.
- Nội dung không được để trống: một đoạn mã trống sẽ được báo cáo là không tìm thấy.
- `open` coi một tên chỉ gồm các chữ số như một vị trí. Sử dụng tên có chữ cái, chẳng hạn như `code2`, để tránh sự mơ hồ.
- Một vị trí đề cập đến thứ tự được hiển thị bởi `list`. Việc loại bỏ một đoạn làm thay đổi vị trí của những đoạn sau nó.

### Khắc phục sự cố

| Triệu chứng | Nguyên nhân và cách khắc phục |
| --- | --- |
| Thông báo "không có đoạn trích" khi nhấn phím tắt | Chưa có đoạn trích nào được thêm vào. Chạy `argvus snippets add` trước. |
| `open` báo cáo không tìm thấy đoạn trích | Tên không khớp chính xác. So sánh với `argvus snippets list`. |
| Không có gì xuất hiện trong ứng dụng | Cửa sổ tập trung không phải là trường văn bản hoặc là ứng dụng X11 chạy trong XWayland, có thể bỏ qua loại đầu vào này. Kiểm tra bằng ứng dụng Wayland gốc. |

Yêu cầu `wtype`, `rofi`, `jq` và `argvus` (lệnh `argvus config`).

`wtype` mô phỏng nhấn phím ở cấp độ đầu vào Wayland. Một số ứng dụng X11 chạy dưới XWayland bỏ qua các sự kiện này, vì vậy văn bản có thể không xuất hiện ở đó mặc dù đoạn mã đã được tìm thấy.

## Git (`SIÊU + ALT + G`)

`SUPER + ALT + G` mở cùng một bộ chọn dự án như `SUPER + O`. Chọn một dự án sẽ mở `lazygit` (hoặc `gitui`) trực tiếp trong đó, trong một terminal ARGVUS mới trên không gian làm việc hiện tại. Không có bước riêng để chọn dự án trước.

### thiết lập

Cài đặt một trong hai công cụ. Cả hai đều là phụ thuộc tùy chọn của gói này:

```sh
sudo pacman -S lazygit   # or: sudo pacman -S gitui
```

### sử dụng

1. Nhấn `SUPER + ALT + G`.
2. Chọn một dự án trong danh sách, hoặc nhấn `Esc` để hủy. Hủy không mở gì cả.
3. Terminal mở trong thư mục dự án và bắt đầu TUI.

Một dự án không phải là kho git sẽ hiển thị thông báo và không mở gì cả. Để bỏ qua bộ chọn, hãy truyền một thư mục:

```sh
argvus git ~/Projects/api
```

### Chọn công cụ

`argvus-git` sử dụng `lazygit` khi nó được cài đặt, và `gitui` trong các trường hợp khác. Để ưu tiên `gitui`, hãy đặt `ARGVUS_GIT_TUI` cho lệnh:

```sh
ARGVUS_GIT_TUI=gitui argvus git
```

Biến này được đọc từ môi trường của lệnh chạy tập lệnh. Nó không được lưu trong cấu hình ARGVUS.

### Khắc phục sự cố

| Triệu chứng | Nguyên nhân và cách khắc phục |
| --- | --- |
| Thông báo "không phải kho lưu trữ git" | Dự án được chọn không phải là kho lưu trữ git hoặc thư mục của nó đã bị di chuyển. Loại bỏ hoặc sửa nó bằng `argvus projects remove`. |
| Notification "install lazygit or gitui" | Neither tool is on the `PATH`. Cài đặt một trong số chúng. |
| Bộ chọn không hiển thị dự án nào | Chưa có dự án nào được thêm. Sử dụng `argvus projects add`. |

## Trình chọn biểu tượng cảm xúc (`SUPER + .`)

`SUPER + .` mở `rofimoji` với cấu hình ARGVUS Rofi. Tìm kiếm một biểu tượng cảm xúc theo tên, nhấn `Enter`, và biểu tượng cảm xúc sẽ được sao chép vào bảng tạm. Dán nó bằng `Ctrl + V` trong ứng dụng bạn muốn.

Khi bộ chọn đang mở, phiên làm việc sẽ bỏ qua các thông báo về bố cục bàn phím mà nó sẽ hiển thị. Trình khởi chạy ghi một đánh dấu ngắn hạn trong thư mục bộ nhớ đệm ARGVUS và xóa nó khoảng một giây sau khi bộ chọn đóng.

Yêu cầu `rofimoji` và `wl-clipboard`.

## Máy tính (`SUPER + C`)

`SUPER + C` mở chế độ `calc` của Rofi với cấu hình Rofi ARGVUS. Gõ một biểu thức, và danh sách kết quả sẽ được cập nhật khi bạn gõ. Chọn một kết quả như chế độ `rofi-calc` xác định.

Gói khởi chạy cung cấp cấu hình Rofi và phụ thuộc vào `rofi-calc`. Chính lối tắt được khai báo bởi `argvus-hyprland`.

## Bảng gian lận (`SUPER + SHIFT + /` và `SUPER + CTRL + /`)

`cheatsheets.sh` hiển thị danh sách chỉ đọc các phím tắt trong một cửa sổ Rofi lớn. Nó lấy tên ứng dụng làm đối số:

```sh
cheatsheets.sh hypr     # Hyprland shortcuts (SUPER + SHIFT + /)
cheatsheets.sh kitty    # terminal shortcuts (SUPER + CTRL + /)
cheatsheets.sh <name>   # any other application with a cheatsheet
```

- `hypr` sử dụng `data/generated/hypr/keybindings.txt` từ cấu hình ARGVUS của người dùng khi tệp đó tồn tại. Nếu không, nó sử dụng bảng gian lận Hyprland được cung cấp cùng với `argvus-hyprland`.
- `kitty` sử dụng bảng gian lận terminal đi kèm với `argvus`.
- Bất kỳ tên nào khác đọc `<name>/docs/cheatsheets/<language>.txt`. Nếu tệp đó không tồn tại, không cửa sổ nào mở ra.

Ngôn ngữ là tiếng Bồ Đào Nha khi vùng cài đặt hệ thống là `pt-BR`, và tiếng Anh trong các trường hợp khác. `Esc` đóng cửa sổ. Chọn một dòng chỉ đóng nó; không có gì được thực thi.

## Các menu khác sử dụng cấu hình Rofi

Cấu hình khởi chạy được chia sẻ với các thành phần thuộc sở hữu của các gói khác:

- Lịch sử bảng tạm (`SUPER + H`) và phím tắt xóa của nó (`SUPER + SHIFT + H`) được khai báo bởi `argvus-hyprland`. Chúng đưa `cliphist` vào Rofi với cấu hình này. `cliphist` xuất phát từ `argvus-session`, chạy trình ghi bảng tạm để điền vào lịch sử; gói siêu `argvus` cũng phụ thuộc vào nó.
- Trình chọn chủ đề, giọng điệu và bố cục trong `argvus-appearance` mở Rofi với `config.rasi`.
- Các quy tắc cửa sổ của Hyprland nhận diện các không gian tên `argvus-launcher` và `rofi`, vì vậy các menu nhận được xử lý bề mặt trình khởi chạy.

## Đóng gói và các phụ thuộc

Gói `argvus-launcher` là không phụ thuộc kiến trúc và cài đặt:

- `argvus launcher`, `argvus-snippets`, `argvus-ssh` và `argvus-git`, trong cùng một thư mục;
- `/usr/share/argvus/launcher/config/`, với cấu hình và chủ đề Rofi;
- `/usr/share/argvus/launcher/sh/`, với `cheatsheets.sh` và `emoji-picker.sh`.

Các phụ thuộc bắt buộc: `argvus-session`, `argvus-appearance`, `argvus`, `bash`, `jq`, `hyprland`, `libnotify`, `rofi`, `rofi-calc`, `rofimoji`, `wl-clipboard`, `wtype`, `gnupg` và `pinentry` (cung cấp `pinentry-gtk`). Các phụ thuộc tùy chọn: `openssh`, cho trình chọn SSH và trình quản lý khóa SSH; `lazygit` và `gitui`, cho giao diện TUI của git.

Cài đặt gói không ghi vào `$HOME`. Cấu hình người dùng được tạo khi bắt đầu phiên, như được mô tả trong [Cấu hình và chủ đề Rofi](#where-the-active-configuration-lives).

## Khắc phục sự cố

| Triệu chứng | Nguyên nhân và cách khắc phục |
| --- | --- |
| `SUPER + D` không mở được gì | Kiểm tra `argvus launcher` trong thiết bị đầu cuối. Xác nhận rằng `rofi` đã được cài đặt và cấu hình Rofi tồn tại. |
| `SUPER + D`không liệt kê ứng dụng nào | Các ứng dụng không có mục nhập trên máy tính để bàn. Chỉ những ứng dụng có`.desktop` file are shown. |
| Các menu sử dụng phông chữ cũ | Dòng `font:` được viết lại khi bắt đầu phiên. Khởi động lại phiên sau khi thay đổi phông chữ. |
| Thay đổi chủ đề không ảnh hưởng đến các menu Rofi | Kiểm tra xem bản sao của người dùng có`config.rasi` in `$XDG_CONFIG_HOME/argvus/data/rofi/` still points to the packaged theme. Apply the theme from `argvus-appearance` again. |
| `SUPER + O` báo cáo không tìm thấy dự án nào | Không có gốc hoặc đường dẫn nào được định cấu hình hoặc các thư mục không còn tồn tại. Chạy `argvus projects list`. |
| `SUPER + C`hoặc bộ chọn biểu tượng cảm xúc không mở | Cài đặt`rofi-calc` or `rofimoji` (both are required dependencies). |
| Một chiếc áo choàng không mở được | Tệp cho tên và ngôn ngữ đó không tồn tại. Kiểm tra các đường dẫn được mô tả trong phần Cheatsheet. |
| `SUPER + H` không hiển thị gì | Lịch sử trống hoặc trình ghi clipboard từ `argvus-session` chưa lưu trữ bất cứ thứ gì. |

## Các thành phần liên quan

| Thành phần | Trách nhiệm |
| --- | --- |
| `argvus-hyprland` | Khai báo các phím tắt và quy tắc cửa sổ Hyprland cho các menu. |
| `argvus-appearance` | Thay đổi chủ đề đang hoạt động, điểm nhấn và bố cục, và viết lại các tham chiếu chủ đề Rofi. |
| `argvus` (`argvus config`) | Lưu trữ các dự án, đoạn mã và cài đặt trình khởi chạy mặc định. |
| `argvus-session` | Sao chép cấu hình Rofi ban đầu và đặt phông chữ của nó khi bắt đầu phiên. |
| `argvus` (`argvus terminal`) | Mở phiên SSH, thiết bị đầu cuối dự án và lời nhắc cụm mật khẩu của `argvus keys`. |
| `argvus` (`argvus widget-telemetry`) | Đọc dự án đang hoạt động được viết bởi `argvus projects`. |
| `argvus` (`argvus i18n`) | Cung cấp các thông báo đã dịch được sử dụng bởi tập lệnh khởi chạy. |
| `argvus` (`argvus control-center`) | Chỉnh sửa danh sách dự án thông qua `argvus projects`. |
