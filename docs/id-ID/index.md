---
title: Peluncur dan Pencarian
description: Peluncur dan Pencarian — Quickshell/QML + Rust.
---

Peluncur utama memakai Quickshell/QML dan mesin Rust lokal untuk aplikasi, jendela, pengaturan, tindakan, proyek, host SSH, berkas, dan pintasan. Pengindeksan awalnya nonaktif; pilih folder secara eksplisit. Hanya nama dan jalur yang diindeks, bukan isi dokumen. Berkas terbaru bergantung pada catatan XDG. Berkas tersembunyi dikecualikan secara bawaan dan symlink direktori tidak diikuti. Menu khusus Rofi tetap tersedia. Di Launcher and Search, pilih urutan A–Z atau Baru dibuka; Baru dibuka menjadi pilihan bawaan. Kategori tersimpan tetap memfilter hasil lainnya; nonaktifkan sumber Windows di pengaturan pencarian untuk menyembunyikan grup ini.

- peluncur aplikasi (`SUPER + D`);
- konfigurasi dan tema Rofi yang dibagikan oleh setiap menu Rofi ARGVUS;
- pengalih proyek, pemilih SSH dan pemilih snippet (`argvus projects`, `argvus ssh`, `argvus snippets`);
- pengelola kunci SSH (`argvus keys`), yang membuat, mencantumkan, memuat dan menghapus pasangan kunci;
- pengelola kunci GPG (`argvus gpg`), yang mencantumkan, membuat dan mengekspor kunci serta mengatur pinentry-gtk untuk gpg-agent;
- pemilih emoji dan menu kalkulator.

Pintasan dideklarasikan oleh `argvus-hyprland`. Paket ini menyediakan perintah-perintah dan menu di belakangnya.

## Jalan pintas

| Pintasan | Aksi | Perintah | Bagian |
| --- | --- | --- | --- |
| `SUPER + D` | ARGVUS Launcher | `argvus launcher` | Peluncur aplikasi |
| `SUPER + O` | Pengalih proyek | `argvus projects` | Pengalih proyek |
| `SUPER + ALT + 1` to `9` | Buka proyek di posisi itu | `argvus projects open N` | Pengalih proyek |
| `SUPER + ALT + S` | Pemilih host SSH | `argvus ssh` | SSH |
| `SUPER + ALT + N` | Pemilih cuplikan | `argvus snippets` | Cuplikan |
| `SUPER + ALT + G` | Pemilih proyek, lalu git TUI | `argvus git` | Git |
| `SUPER + .` | ARGVUS Emoji | `argvus emoji-picker` | ARGVUS Emoji |
| `SUPER + C` | Kalkulator | `argvus calculator` | Kalkulator |

## Peluncur dan Pencarian

Peluncur utama memakai Quickshell/QML dan mesin Rust lokal untuk aplikasi, jendela, pengaturan, tindakan, proyek, host SSH, berkas, dan pintasan. Pengindeksan awalnya nonaktif; pilih folder secara eksplisit. Hanya nama dan jalur yang diindeks, bukan isi dokumen. Berkas terbaru bergantung pada catatan XDG. Berkas tersembunyi dikecualikan secara bawaan dan symlink direktori tidak diikuti. Menu khusus Rofi tetap tersedia. Di Launcher and Search, pilih urutan A–Z atau Baru dibuka; Baru dibuka menjadi pilihan bawaan. **Sedang dibuka** nonaktif secara default; aktifkan di Control Center > Preferences > Launcher and Search untuk menampilkan jendela saat ini ketika kueri kosong. Riwayat penggunaan aplikasi dapat dihapus dari halaman yang sama.

Launcher memakai tata letak TUI ringkas: teks monospace, pencarian dan kategori sejajar, favorit ringkas serta bantuan terpisah di bawah. Ketebalan dan lengkungan bingkai mengikuti pengaturan ARGVUS aktif.

Peluncur menggunakan bahasa antarmuka ARGVUS yang dipilih di Pusat Kontrol.

`argvus launcher` · `argvus control-center launcher`

↑↓ Navigasi · Enter Buka · Esc Kembali · Ctrl+F Favorit

- Atur pencarian: Aplikasi, Jendela, Pengaturan, Aksi, Proyek, SSH, berkas, Bantuan.
- Tambah folder terindeks / Tambah pengecualian — Jalur absolut.
- Jeda pengindeksan / Hapus indeks dan jeda / Bangun ulang indeks.
- ↑↓ Navigasi · Enter Alih/Tambah · Delete Hapus · Ctrl+↑↓ Urutkan · F5 Segarkan · Esc Kembali

`argvus config get /launcher --effective`

`$XDG_CONFIG_HOME/argvus/config/launcher.json` → `$XDG_CACHE_HOME/argvus/launcher/index.json`

Quickshell: `launcher/Theme.qml` · Rofi: `launcher/theme.rasi`

`--config` / Rasi: Atur pencarian → `argvus control-center launcher`.

## Konfigurasi dan tema Rofi

Paket menginstal konfigurasi Rofi di bawah `/usr/share/argvus/launcher/config/`:

| Berkas | Peran |
| --- | --- |
| `config.rasi` | Titik masuk yang digunakan oleh setiap menu ARGVUS. Mengatur Rofi `configuration`(font, tanpa ikon, daftar yang diurutkan, pencocokan tanpa memperhatikan huruf besar/kecil) dan impor`theme.rasi`. |
| `theme.rasi`| Warna dan tata letak jendela, bilah input, dan daftar. Mengimpor satu tema dan file mode. |
| `mode.rasi` | Penggantian mode. File paket tidak memiliki penggantian dan tetap menggunakan mode Gelap. |
| `themes/<family>/theme.rasi` | Palet rangkaian tema, misalnya `argvus-dark` atau `tokyo-night`. |
| `themes/<family>-spaced/theme.rasi` | Varian spasi dari keluarga yang sama. |

Paket ini menyediakan 22 keluarga, dan masing-masing memiliki varian `-spaced`. `theme.rasi` yang dikemas mengimpor `argvus-dark`.

### Tempat konfigurasi aktif berada

ARGVUS menyelesaikan setiap file Rofi melalui `paths_config`. File pertama yang ada di antara penggantian pengguna, salinan pengguna, lokasi warisan, dan pohon yang dihasilkan yang menang; jika tidak, file yang dikemas di bawah `/usr/share/argvus/launcher/config/` digunakan. Salinan pengguna dari sebuah file adalah `$XDG_CONFIG_HOME/argvus/data/rofi/<file>`: prefix `launcher/config/` disimpan di bawah `rofi/`.

ARGVUS membuat salinan pengguna pertama kali sebuah skrip ARGVUS mengubah file itu; `argvus-appearance` melakukan ini untuk perubahan tema, aksen, dan mode. File yang tidak pernah diubah terus dibaca dari paket, dan salinan pengguna mendapatkan prioritas atas file yang dikemas.

Ketika `argvus-session` menerapkan font saat sesi dimulai, itu menulis ulang baris `font:` dari `config.rasi` dari pengaturan font ARGVUS. Suntingan itu hanya mencapai salinan pengguna. Sampai salinan itu ada, file yang dikemas adalah yang ditemukan, dan pengguna tidak dapat menulis ke file tersebut, jadi perubahan font berlaku setelah perubahan tampilan pertama membuat salinan.

### Mengubah tema

`argvus-appearance` memiliki perubahan tema. Ketika tema berubah, itu menulis ulang salinan pengguna sehingga `config.rasi` menunjuk ke `theme.rasi` yang baru, dan `theme.rasi` mengimpor palet peluncur dari build tema (`~/.config/argvus/data/generated/theme/current/launcher/theme.rasi`), yang memiliki keluarga aktif, tata letak dan warna sorot. Tanpa build tema, itu mengimpor salinan keluarga, dan tata letak Spaced memilih varian `-spaced` dari keluarga aktif. Pemilih tema seperti menu tema dan menu tata letak membaca `config.rasi` yang sama, jadi mereka juga menggunakan gaya aktif.

Jangan mengedit file di bawah `/usr/share/argvus/launcher/`; file tersebut akan diganti saat peningkatan paket. Lakukan perubahan pada salinan pengguna, di bawah `$XDG_CONFIG_HOME/argvus/data/rofi/`.

## Pengalih proyek (`SUPER + O`)

`argvus projects` (`SUPER + O`) mencantumkan proyek yang Anda tambahkan dan membuka proyek yang dipilih di workspace Hyprland-nya sendiri, dengan `argvus terminal` di direktori-nya. Jika workspace proyek sudah ada, switcher hanya memfokuskannya.

Untuk akses hanya dengan keyboard, `SUPER + ALT + 1` hingga `SUPER + ALT + 9` membuka proyek pada posisi itu dalam daftar, tanpa menu. Posisi adalah angka yang ditampilkan di menu. Mereka mengikuti urutan daftar, jadi menambah atau menghapus proyek dapat mengubahnya. `argvus projects open <number or directory name>` melakukan hal yang sama dari terminal, dan kegagalan ditampilkan sebagai notifikasi.

Daftar proyek yang efektif dibatasi hingga 9, karena itu adalah jumlah maksimum yang dapat diakses oleh `SUPER + ALT + 1..9`. `argvus projects add` (dan halaman Proyek di Pusat Kontrol, yang memanggilnya) menolak untuk menambahkan proyek atau akar yang akan membuat total melebihi 9, dan melaporkan kesalahan sebagai gantinya.

Sebuah proyek berasal dari dua tempat di bagian `projects` dari `argvus-config`:

- `paths`: direktori proyek individu.
- `roots`: direktori yang subdirektori langsungnya adalah proyek. Root yang tidak ada akan diabaikan.

Tidak ada root atau path yang dikonfigurasi secara default; tambahkan setidaknya satu sebelum `SUPER + O` memiliki sesuatu untuk ditampilkan.

Kelola mereka dari terminal:

```sh
argvus projects add ~/Work/api          # one project
argvus projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus projects remove ~/Work/api       # removes it from paths and roots
argvus projects list                    # prints the roots and paths
```

`argvus projects pick` menampilkan daftar yang sama dan mencetak jalur yang dipilih alih-alih membukanya. Alat lain dapat menggunakannya, seperti yang dilakukan `argvus git`. Membatalkan tidak mencetak apa pun.

Jika tidak ada root atau jalur, `SUPER + O` melaporkan bahwa tidak ada proyek yang ditemukan. Perintah editor opsional, `/projects/editor`, dimulai di workspace yang sama ketika workspace dibuat.

Entri dibaca dari konfigurasi yang efektif; peluncur tidak menyimpan salinannya.

Membuka sebuah proyek juga mencatat jalurnya sebagai proyek aktif untuk sesi tersebut, yang dibaca oleh blok telemetri Dev Dashboard (`argvus widget-telemetry`) untuk melaporkan git, port yang mendengarkan, dan kontainer proyek tersebut.

## SSH(`SUPER+ALT+S`)

**ARGVUS SSH** · GTK 4 / Wayland · `↑` `↓` `Enter` `Esc`

`SUPER + ALT + S` membuka pemilih dengan host yang ditentukan dalam `~/.ssh/config`. Host yang dipilih terbuka di terminal ARGVUS baru yang menjalankan `ssh <host>`, di ruang kerja saat ini.

### Pengaturan

Tambahkan entri `Host` untuk setiap server ke `~/.ssh/config`:

```ini
Host myhost
    HostName myhost.local
    User boss
    IdentityFile ~/.ssh/myhost
    IdentitiesOnly yes
```

Konfirmasi bahwa `ssh myhost` berfungsi di terminal normal terlebih dahulu. Peluncur hanya menjalankan `ssh`; autentikasi, kunci, dan verifikasi host ditangani oleh OpenSSH.

### Gunakan

1. Tekan `SUPER + ALT + S`.
2. Ketik sebagian nama host, atau gunakan tombol panah.
3. Tekan `Enter`. Terminal terbuka dan menjalankan `ssh <host>`.

Saat sesi berakhir, jendela tetap terbuka dan menampilkan status keluar, misalnya `ssh exited with status 0. Press Enter to close.` Tekan `Enter` untuk menutupnya. Hal ini penting untuk layanan seperti GitHub, GitLab, dan Gitea: mereka mengotentikasi Anda dan segera menutup koneksi karena mereka tidak menyediakan shell. Jendela tetap menampilkan pesan mereka di layar alih-alih menghilang.

### Aturan

- Entri wildcard (`Host *`, `Host *.internal`) adalah blok kecocokan, bukan target, dan tidak pernah dicantumkan.
- Setiap alias pada baris `Host` dicantumkan secara terpisah (`Host a b` mencantumkan `a` dan `b`). Duplikat dihapus.
- Host yang hanya didefinisikan dalam file yang dimuat dengan `Include` tidak dicantumkan; pemilih hanya membaca file utama.
- Hanya alias yang terdiri dari huruf, angka, `.`, `-`, dan `_` yang dijalankan. Nama lain ditolak dengan pemberitahuan.
- Akhiran baris Windows (CRLF) dalam konfigurasi diterima.
- `ARGVUS_SSH_CONFIG` menggantikan jalur file konfigurasi, yang berguna untuk pengujian.

### Perintah

```sh
argvus ssh list          # prints the configured hosts, one per line
argvus ssh open myhost   # opens a specific host without the picker
```

### Pemecahan masalah

| Gejala | Penyebab dan perbaikan |
| --- | --- |
| Notifikasi "tidak ada host yang ditemukan di ~/.ssh/config" | File tersebut hilang atau tidak memiliki`Host`baris. Jalankan`argvus ssh list`untuk memeriksa. |
| Seorang host hilang dari pemilih | Ini adalah karakter bebas, berasal dari sebuah `Include`file, atau memiliki karakter di luar set yang diperbolehkan. Letakkan di file utama dengan alias biasa. |
| Jendela menunjukkan status kesalahan segera | Jalankan `ssh <host>`di terminal normal untuk melihat pesan lengkap (host tidak dapat dijangkau, kunci salah, dan sebagainya). |
| Jendela menampilkan `message.ssh_session_ended`alih-alih teks | Yang terpasang`argvus`paket lebih lama daripada versi ini. Perbarui`argvus`. |

Memerlukan `openssh` dan `argvus` (perintah `argvus terminal`).

## Kunci SSH (`argvus keys`)

`argvus keys` mengelola pasangan kunci di `~/.ssh` dan kunci yang dipegang oleh ssh-agent. Tidak ada pintasan. Halaman **Kunci SSH** di Pusat Kontrol (Aplikasi) menggunakan perintah yang sama.

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

Aturan yang berlaku untuk setiap perintah:

- Nama kunci menjadi nama file di bawah `~/.ssh`, jadi hanya dapat berisi huruf, angka, titik, tanda hubung, dan garis bawah. Tidak boleh diawali dengan titik atau diakhiri dengan `.pub`. Pasangan yang sudah ada tidak pernah ditimpa.
- Hanya pasangan dengan file publik (`NAME.pub`) yang tercantum, dan hanya itu yang dapat dimuat, dibongkar, atau dihapus.
- Frasa sandi tidak pernah diteruskan sebagai argumen perintah, ditulis ke log, atau ditampilkan di Pusat Kontrol. `load` dan `generate --passphrase` membuka terminal ARGVUS, dan OpenSSH membaca rahasia dari terminal itu.
- `list` melaporkan `unknown` di kolom `loaded` ketika agen tidak dapat dijangkau. Ia tidak pernah menebak.
- `delete` menghapus kunci pribadi secara permanen. Simpan salinan dari kunci yang masih Anda butuhkan.
- `ARGVUS_SSH_DIR` menggantikan `~/.ssh`, yang berguna untuk pengujian.

Agen adalah layanan pengguna `argvus-ssh-agent.service` yang dimulai oleh `argvus-session`. `SSH_AUTH_SOCK` menunjuk ke itu dalam sesi.

Requires

 (

 and

) and

 (the

 command).

| Gejala | Penyebab dan perbaikan |
| --- | --- |
|  argvus terminal argvus ssh-add ssh-keygen `openssh` `ssh-keygen` `ssh-add` `argvus` `argvus terminal` `load` membuka terminal, tetapi kuncinya tidak dimuat | Ketikkan frasa sandi di terminal itu. Jika tidak diminta, jalankan `ssh-add -l` untuk melihat apa yang dimiliki agen. |
| Terminal menampilkan `Could not open a connection to your authentication agent` | Hyprland dimulai sebelum agen, jadi terminalnya tidak memiliki `SSH_AUTH_SOCK`. Peluncur kembali ke `$XDG_RUNTIME_DIR/ssh-agent.socket`, jadi perbarui `argvus-launcher`dan buka terminal baru. |
| `list` shows `unknown`di dalam`loaded` kolom | Agen tidak dapat dijangkau. Periksa `systemctl --user status argvus-ssh-agent.service` dan `SSH_AUTH_SOCK` variable. |
| `delete`melaporkan bahwa kunci telah dimuat | Jalankan `argvus keys unload NAME`pertama, kemudian hapus lagi. |
| `generate`melaporkan bahwa nama sudah ada | Pilih nama lain. Pasangan yang sudah ada tidak pernah diganti. |

## GPG keys (

)

 `argvus gpg` `argvus gpg` mencantumkan, membuat, dan mengekspor kunci GPG serta mengimpor kunci publik. gpg-agent selalu menggunakan `pinentry-gtk`: ARGVUS menulis pinentry ke dalam `gpg-agent.conf` sebelum menghasilkan kunci. Tidak memiliki pintasan. Halaman **kunci GPG** di Control Center menggunakan perintah yang sama.

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

`generate` mengambil opsi-opsi ini:

- `--algo rsa|dsa` memilih algoritma kunci. Default-nya adalah `rsa`.
- `--bits` memilih ukuran kunci. RSA menerima `1024`, `2048`, `3072`, dan `4096`, dengan `4096` sebagai default. DSA menerima `1024`, `2048`, dan `3072`, dengan `2048` sebagai default; gpg tidak dapat membuat kunci DSA yang lebih besar, sehingga `4096` ditolak sebelum gpg dijalankan.
- `--expire` mengambil `0` tanpa kedaluwarsa, sebuah angka diikuti oleh `d`, `w`, `m` atau `y` (seperti `2y`), atau tanggal ISO `YYYY-MM-DD`, yang harus merupakan tanggal yang sah.
- `--passphrase-stdin` membaca kata sandi dari baris pertama input standar. Pusat Kontrol menggunakannya. Baris kosong ditolak.
- `--no-passphrase --yes` membuat kunci yang tidak terlindungi. Dua mode frasa sandi tidak dapat digabungkan.

Setiap kunci mendapatkan satu kunci utama sertifikasi-dan-penandatanganan dan satu subkunci enkripsi, sehingga dapat mengenkripsi file serta menandatangani commit dan paket. Subkunci sesuai dengan kunci utama: `rsa` dengan ukuran yang sama untuk RSA, dan `elg` dengan ukuran yang sama untuk DSA, yang merupakan pasangan yang disyaratkan oleh standar DSA.

Aturan yang berlaku untuk setiap perintah:

- Frasa sandi tidak pernah diteruskan sebagai argumen perintah, ditulis ke log, atau ditampilkan di Pusat Kontrol. Dengan `--passphrase-stdin` frasa sandi dikirim ke gpg pada deskriptor file 0 dari sebuah pipa. Tanpa opsi itu, gpg meminta jendela pinentry, yang dibuka oleh `gpg-agent`.
- `--no-passphrase` menyimpan kunci privat tanpa perlindungan. Ini ditolak kecuali `--yes` juga diberikan.
- `import` menolak file apa pun yang berisi paket kunci rahasia, baik dalam bentuk ASCII maupun biner. Kunci pribadi hanya keluar dari keyring melalui `export-private`, yang membutuhkan `--yes` dan menulis dengan mode `600`; `import-private` mengembalikannya.
- Perintah yang mengubah atau menerbitkan kunci (`export-private`, `delete`, `edit sign`, `edit revoke`, `keyserver send`) memerlukan `--yes`. Pusat Kontrol hanya memberikannya setelah konfirmasi sendiri.
- Perintah yang menggunakan kunci rahasia menjalankan gpg dengan `--no-tty`, sehingga gpg tidak pernah mencoba membuka terminal. Frase sandi berasal dari jendela pinentry, kecuali dalam `generate --passphrase-stdin`.
- `generate` membuat gpg-agent menggunakan `pinentry-gtk`. Ini menulis baris tersebut di antara penanda `# BEGIN argvus-managed pinentry` dan `# END argvus-managed pinentry`, mempertahankan sisa `gpg-agent.conf`, dan menyimpan file sebelumnya sebagai `gpg-agent.conf.bak`. Ketika blok sudah menamai `pinentry-gtk`, file dan gpg-agent dibiarkan seperti apa adanya. Perintah menolak dijalankan ketika `gpg-agent.conf` sudah mengatur `pinentry-program` di luar blok itu, sehingga dua nilai tidak pernah bertentangan.
- Installing the package never writes to

. The configuration changes only when a key is generated.
-

 replaces

, which is useful for testing.

 and

 adalah ketergantungan yang diperlukan: perintah kunci memerlukan gpg, dan jendela frasa sandinya

.

| Gejala | Penyebab dan perbaikan |
| --- | --- |
|  pinentry-gtk pinentry gnupg `~/.gnupg` `GNUPGHOME` `~/.gnupg` `gnupg` `pinentry` `pinentry-gtk` `generate` tidak membuka jendela frasa sandi | Periksa `argvus gpg status`. `pinentry-gtk` harus diinstal, dan sesi harus mengekspos `WAYLAND_DISPLAY` atau `DISPLAY`. |
| `generate`melaporkan bahwa`pinentry-gtk`tidak terpasang | Pasang `pinentry` package. |
| `generate` reports a `pinentry-program`baris di luar blok ARGVUS | Hapus baris itu dari`~/.gnupg/gpg-agent.conf`, lalu jalankan perintahnya lagi. |
| `generate`melaporkan bahwa ukuran kunci tidak didukung | Periksa ukuran untuk algoritma: DSA berhenti pada 3072 bit. |
| `generate`melaporkan bahwa subkunci enkripsi tidak dapat ditambahkan | Kunci telah dibuat. Tambahkan subkunci dengan`gpg --quick-add-key FINGERPRINT cv25519 encr 2y`, atau hapus kunci dengan `gpg --delete-secret-and-public-key`dan hasilkan itu lagi. |
| `import`menolak sebuah berkas | Berkas tersebut mengandung kunci privat. Ekspor hanya kunci publik di mesin lain dengan`argvus gpg export-public`. |
| `list`menampilkan tidak ada kunci | Gantungan kunci di`GNUPGHOME` (or `~/.gnupg`) kosong. Jalankan `argvus gpg generate`untuk membuat sebuah kunci. |

## Potongan kode (`SUPER + ALT + N`)

**ARGVUS Cuplikan** · GTK 4 / Wayland · `↑` `↓` `Enter` `Esc`

`SUPER + ALT + N` membuka pemilih dengan potongan kode Anda. Potongan kode yang dipilih diketik ke dalam jendela yang sedang difokuskan, di posisi kursor, alih-alih melalui papan klip.

### Pengaturan

Tambahkan potongan kode dengan nama dan teksnya:

```sh
argvus snippets add "email" "you@example.com"
```

Periksa bahwa itu telah disimpan:

```sh
argvus snippets list
```

Cuplikan disimpan di bagian `snippets` dari `argvus config`, sebagai entri `{name, content}`. Anda dapat membacanya dengan `argvus config get /snippets/items`.

### Gunakan

1. Klik ke dalam bidang teks aplikasi yang seharusnya menerima teks.
2. Tekan `SUPER + ALT + N`.
3. Pilih cuplikan berdasarkan nama dan tekan `Enter`. Teks diketik di tempat kursor berada.

### Perintah

```sh
argvus snippets add "NAME" "CONTENT"   # adds a snippet, or replaces the one with the same name
argvus snippets remove NAME            # removes a snippet
argvus snippets list                   # prints index and name, one per line
argvus snippets open NAME              # types a snippet by name
argvus snippets open 2                 # types the snippet at position 2 of `list`
argvus snippets                        # opens the picker (same as the shortcut)
argvus snippets --help                 # shows the options and an example
```

### Aturan

- Nama bersifat unik dan peka terhadap huruf besar-kecil. Menambahkan cuplikan dengan nama yang sudah ada akan mengganti isinya.
- Konten tidak boleh kosong: cuplikan kosong dilaporkan sebagai tidak ditemukan.
- Perintah `open` memperlakukan nama yang hanya terdiri dari angka sebagai posisi. Gunakan nama yang mengandung huruf, seperti `code2`, agar tidak ambigu.
- Sebuah posisi merujuk pada urutan yang ditampilkan oleh  code2  `open`  `code2` `list`. Menghapus sebuah cuplikan menggeser posisi cuplikan setelahnya.

### Pemecahan masalah

| Gejala | Penyebab dan perbaikan |
| --- | --- |
| Pemberitahuan "tidak ada cuplikan" saat menekan pintasan | Belum ada cuplikan yang ditambahkan. Jalankan `argvus snippets add` first. |
| `open`melaporkan cuplikan tidak ditemukan | Nama tidak cocok persis. Bandingkan dengan `argvus snippets list`. |
| Tidak ada yang muncul di aplikasi | Jendela yang difokuskan bukan merupakan bidang teks, atau itu adalah aplikasi X11 yang berjalan di bawah XWayland, yang mungkin mengabaikan jenis input ini. Coba dengan aplikasi Wayland asli. |

Memerlukan `wtype`, `jq` dan `argvus` (perintah `argvus config`).

`wtype` mensimulasikan penekanan tombol pada tingkat input Wayland. Beberapa aplikasi X11 yang berjalan di bawah XWayland mengabaikan peristiwa ini, jadi teks mungkin tidak muncul di sana meskipun cuplikan tersebut ditemukan.

## Git (`SUPER + ALT + G`)

`SUPER + ALT + G` membuka pemilih proyek yang sama seperti `SUPER + O`. Memilih sebuah proyek membuka `lazygit` (atau `gitui`) langsung di dalamnya, di terminal ARGVUS baru pada ruang kerja saat ini. Tidak ada langkah terpisah untuk memilih proyek terlebih dahulu.

### Pengaturan

Instal salah satu dari dua alat tersebut. Keduanya adalah dependensi opsional dari paket ini:

```sh
sudo pacman -S lazygit   # or: sudo pacman -S gitui
```

### Gunakan

1. Tekan `SUPER + ALT + G`.
2. Pilih proyek dari daftar, atau tekan `Esc` untuk membatalkan. Membatalkan tidak membuka apa pun.
3. Terminal terbuka di direktori proyek dan memulai TUI.

Proyek yang bukan repositori git menampilkan notifikasi dan tidak membuka apa pun. Untuk melewati pemilih, lewati sebuah direktori:

```sh
argvus git ~/Projects/api
```

### Memilih alat

`argvus-git` menggunakan `lazygit` saat terinstal, dan `gitui` jika tidak. Untuk memilih `gitui`, atur `ARGVUS_GIT_TUI` untuk perintah:

```sh
ARGVUS_GIT_TUI=gitui argvus git
```

Variabel ini dibaca dari lingkungan perintah yang menjalankan skrip. Ini tidak disimpan dalam konfigurasi ARGVUS.

### Pemecahan masalah

| Gejala | Penyebab dan perbaikan |
| --- | --- |
| Pemberitahuan "bukan repositori git" | Proyek yang dipilih bukan repositori git, atau direktori-nya telah dipindahkan. Hapus atau perbaiki dengan `argvus projects remove`. |
| Notifikasi "install lazygit atau gitui" | Tidak ada salah satu alat tersebut di `PATH`. Pasang salah satunya. |
| Pemilih tidak menampilkan proyek | Tidak ada proyek yang ditambahkan. Gunakan `argvus projects add`. |

## Pemilih emoji (`SUPER + .`)

`SUPER + .` → **ARGVUS Emoji** (`argvus emoji-picker`). ←↑↓→  Tab   / Cari berdasarkan nama atau kata kunci   Enter Sisipkan   Ctrl+C Salin   Ctrl+D Favorit   Esc.

Pemilih dibuka pada tab Semua. Tab berpindah kategori dan tombol panah menavigasi kisi emoji.

## Kalkulator (`SUPER + C`)

`SUPER + C` → `argvus calculator` (ARGVUS / GTK4).

## Menu lain yang menggunakan konfigurasi Rofi

Konfigurasi peluncur dibagikan dengan komponen yang dimiliki oleh paket lain:

- Riwayat papan klip (`SUPER + H`) dan pintasan bersihnya (`SUPER + SHIFT + H`) dinyatakan oleh `argvus-hyprland`. Mereka mengalirkan `cliphist` ke Rofi dengan konfigurasi ini. `cliphist` berasal dari `argvus-session`, yang menjalankan perekam papan klip yang mengisi riwayat; paket meta `argvus` juga bergantung padanya.
- Tema, aksen, dan pemilih tata letak di `argvus-appearance` membuka Rofi dengan `config.rasi`.
- Aturan jendela Hyprland mengenali namespace `argvus-launcher` dan `rofi`, sehingga menu menerima perlakuan permukaan peluncur.

## Pengemasan dan dependensi

Paket `argvus-launcher` bersifat independen terhadap arsitektur dan menginstal:

- `argvus launcher`, `argvus-snippets`, `argvus-ssh` dan `argvus-git`, di bawah direktori yang sama;
- `/usr/share/argvus/launcher/config/`, dengan konfigurasi dan tema Rofi;

Dependensi yang dibutuhkan: `argvus-session`, `argvus-appearance`, `argvus`, `bash`, `jq`, `hyprland`, `libnotify`, `quickshell`, `qt6-declarative`, `wl-clipboard`, `wtype`, `gnupg` dan `pinentry` (yang menyediakan `pinentry-gtk`). Dependensi opsional: `openssh`, untuk pemilih SSH dan manajer kunci SSH; `lazygit` dan `gitui`, untuk TUI git.

Menginstal paket tidak menulis ke `$HOME`. Konfigurasi pengguna dibuat saat sesi dimulai, seperti yang dijelaskan dalam [Konfigurasi dan tema Rofi](#where-the-active-configuration-lives).

## Pemecahan masalah

| Gejala | Penyebab dan perbaikan |
| --- | --- |
| `SUPER + D`tidak membuka apa pun | Periksa`argvus launcher`di terminal. Konfirmasikan bahwa`rofi`telah terpasang dan konfigurasi Rofi ada.
| `SUPER + D`menampilkan tidak ada aplikasi | Aplikasi tidak memiliki entri desktop. Hanya aplikasi dengan`.desktop`file ditampilkan. |
| Menu menggunakan font lama | The `font:`baris ditulis ulang saat sesi dimulai. Mulai ulang sesi setelah mengganti font. |
| Perubahan tema tidak mencapai menu Rofi | Periksa apakah salinan pengguna dari `config.rasi` in `$XDG_CONFIG_HOME/argvus/data/rofi/`masih mengarah ke tema yang dikemas. Terapkan tema dari`argvus-appearance` again. |
| `SUPER + O`melaporkan bahwa tidak ada proyek yang ditemukan | Tidak ada root atau jalur yang dikonfigurasi, atau direktori sudah tidak ada. Jalankan `argvus projects list`. |
| `SUPER + C` / `SUPER + .` | `argvus`, `wl-clipboard`, `wtype` |
| Panduan cepat tidak terbuka | File dengan nama dan bahasa tersebut tidak ada. Periksa jalur yang dijelaskan di bagian Panduan Cepat. |
| `SUPER + H`menunjukkan tidak ada | Riwayat kosong, atau perekam papan klip dari`argvus-session`belum menyimpan apa pun.

## Komponen terkait

| Komponen | Tanggung jawab |
| --- | --- |
| `argvus-hyprland`| Menyatakan pintasan dan aturan jendela Hyprland untuk menu. |
| `argvus-appearance` | Mengubah tema aktif, aksen, dan tata letak, serta menulis ulang referensi tema Rofi. |
| `argvus` (`argvus config`) | Menyimpan proyek, potongan kode, dan pengaturan peluncur default. |
| `argvus-session` | Menyalin konfigurasi Rofi awal dan mengatur fontnya saat memulai sesi. |
| `argvus` (`argvus terminal`) | Membuka sesi SSH, terminal proyek, dan prompt passphrase dari `argvus keys`. |
| `argvus` (`argvus widget-telemetry`) | Membaca proyek aktif yang ditulis oleh `argvus projects`. |
| `argvus` (`argvus i18n`) | Menyediakan pesan yang diterjemahkan yang digunakan oleh skrip peluncur. |
| `argvus` (`argvus control-center`) | Mengedit daftar proyek melalui `argvus projects`. |

Dalam Sticky dan Spaced, blur Rofi mencakup seluruh monitor menu, termasuk bilah dan margin. Menu tetap di tengah dan mengikuti pengaturan blur global.


`/launcher/show_icons`: `true` / `false`.

`/launcher/selected_category`: `""` (All), `applications`, `windows`, `settings`, `actions`, `projects`, `ssh`, `files`, `help`.

`/launcher/application_sort`: `recent` (Baru dibuka, bawaan) atau `alphabetical` (A–Z).

Teks aplikasi mengikuti Applications Font di Control Center → Appearance → Desktop Style → Fonts. GTK mewarisi gtk-font-name; ukuran angka dan judul dipertahankan. Peluncur membaca apps_family yang dihasilkan dan memantau perubahan.
