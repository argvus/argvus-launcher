---
title: Uygulama başlatıcı
description: ARGVUS Rofi menüleri aracılığıyla uygulamaları başlatın, projeleri açın, SSH hostlarına ve snippet'lere bağlanın, emoji seçin, hesaplama yapın ve hile sayfalarını okuyun.
---

`argvus-launcher`, ARGVUS'un klavyeden bir şeyleri açmak için kullandığı Rofi yapılandırmasını, temalarını ve menülerini sağlar. İçerir:

- uygulama başlatıcıyı (`SUPER + D`);
- her ARGVUS Rofi menüsü tarafından paylaşılan Rofi yapılandırması ve temaları;
- proje değiştirici, SSH seçici ve snippet seçici (`argvus projects`, `argvus ssh`, `argvus snippets`);
- SSH anahtar yöneticisi (`argvus keys`), anahtar çiftlerini oluşturur, listeler, yükler ve siler;
- GPG anahtar yöneticisi (`argvus gpg`), anahtarları listeler, oluşturur ve dışa aktarır ve gpg-agent için pinentry-gtk ayarlar;
- emoji seçici, kısayol tablosu görüntüleyici ve hesap makinesi menüsü.

Kısayollar `argvus-hyprland` tarafından beyan edilmiştir. Bu paket, komutları ve bunların arkasındaki menüleri sağlar.

## Kısayollar

| Kısayol | Eylem | Komut | Bölüm |
| --- | --- | --- | --- |
| `SUPER + D` | Uygulama başlatıcısı | `argvus launcher` | Uygulama başlatıcısı |
| `SUPER + O` | Proje değiştirici | `argvus projects` | Proje değiştirici |
| `SUPER + ALT + 1` - `9` | Projeyi bu konumda açın | `argvus projects open N` | Proje değiştirici |
| `SUPER + ALT + S` | SSH ana bilgisayar seçici | `argvus ssh` | SSH |
| `SUPER + ALT + N` | Parçacık seçici | `argvus snippets` | Parçacıklar |
| `SUPER + ALT + G` | Proje seçici, ardından git TUI | `argvus git` | Git |
| `SUPER + .` | Emoji seçici | `emoji-picker.sh` | Emoji seçici |
| `SUPER + C` | Hesap Makinesi | `rofi -show calc` | Hesap Makinesi |
| `SUPER + SHIFT + /` | Hyprland hile sayfası | `cheatsheets.sh hypr` | Hile Sayfaları |
| `SUPER + CTRL + /` | Kitty hile sayfası | `cheatsheets.sh kitty` | Hile Sayfaları |

## Uygulama başlatıcı (`SUPER + D`)

`SUPER + D`, `argvus launcher` çalıştırır, bu da Rofi'yi `drun` modunda açar. Masaüstü girişi ile yüklü grafik uygulamalarını listeler ve seçilen uygulama `Enter` tuşuna bastığınızda başlar.

1. `SUPER + D`'ye basın.
2. Uygulama adının bir kısmını yazın. Liste sıralanır ve filtre büyük/küçük harf duyarsızdır.
3. Uygulamayı başlatmak için `Enter` tuşlayın veya menüyü kapatmak için `Esc` tuşlayın.

```sh
argvus launcher                  # opens the application menu
argvus launcher --config PATH    # uses another Rofi configuration file
```

Başka herhangi bir argüman `rofi`'ye iletilir. `--config` bir değer olmadan hata ile durur.

Hyprland, varsayılan başlatıcı rofi olduğunda `argvus launcher --config <Rofi configuration>` çalıştırır, ki bu varsayılandır. Eğer varsayılan uygulamalardaki varsayılan  `rofi` `launcher` başka bir programa ayarlanmışsa, Hyprland yerine `<program> --show drun` çalıştırır. Bunu, değerini `argvus-config` içinde depolayan Kontrol Merkezi'nin varsayılan uygulamalarında ayarlayın.

Yalnızca masaüstü girişi olan uygulamalar listede görünür. Hiçbir `.desktop` dosyası yüklemeyen bir uygulama burada bulunamaz.

## Rofi yapılandırması ve temalar

Paket, Rofi yapılandırmasını `/usr/share/argvus/launcher/config/` altında yükler:

| Dosya | Rol |
| --- | --- |
| `config.rasi` | Her ARGVUS menüsü tarafından kullanılan giriş noktası. Rofi `configuration`'yi (yazı tipi, simge yok, sıralı liste, büyük/küçük harfe duyarlı olmayan eşleştirme) ayarlar ve `theme.rasi`'yi içe aktarır. |
| `theme.rasi` | Pencerenin, giriş çubuğunun ve listenin renkleri ve düzeni. Bir temayı ve mod dosyasını içe aktarır. |
| `mode.rasi` | Mod geçersiz kılma. Paketlenmiş dosyanın geçersiz kılmaları yoktur ve Karanlık modu korur. |
| `themes/<family>/theme.rasi` | Bir tema ailesinin paleti, örneğin `argvus-dark` veya `tokyo-night`. |
| `themes/<family>-spaced/theme.rasi` | Aynı ailenin aralıklı versiyonu. |

Paket 22 aile sağlar ve her birinin bir `-spaced` varyantı vardır. Paketlenmiş `theme.rasi`, `argvus-dark`'yi içe aktarır.

### Aktif yapılandırmanın bulunduğu yer

ARGVUS, her Rofi dosyasını `paths_config` üzerinden çözer. Kullanıcı geçersiz kılmaları, kullanıcı kopyası, eski konumlar ve oluşturulmuş ağaç arasında mevcut olan ilk dosya kazanır; aksi takdirde `/usr/share/argvus/launcher/config/` altındaki paketlenmiş dosya kullanılır. Bir dosyanın kullanıcı kopyası `$XDG_CONFIG_HOME/argvus/data/rofi/<file>`'dir: `launcher/config/` öneki `rofi/` altında saklanır.

ARGVUS, bir ARGVUS betiği o dosyayı ilk kez değiştirdiğinde bir kullanıcı kopyası oluşturur; `argvus-appearance` bu işlemi tema, vurgu ve mod değişiklikleri için yapar. Hiç değiştirilmeyen dosyalar paketten okunmaya devam eder ve bir kullanıcı kopyası paketlenmiş dosyanın önceliğine sahiptir.

`argvus-session` oturum başlatıldığında yazı tipini uyguladığında, config.rasi'nin `font:` satırını ARGVUS yazı tipi ayarından yeniden yazar. Bu düzenleme yalnızca kullanıcı kopyasına ulaşır. Kopya var olana kadar, paketlenmiş dosya bulunan dosyadır ve kullanıcılar buna yazamaz, bu nedenle yazı tipi değişikliği, ilk görünüm değişikliği kopyayı oluşturduktan sonra etkili olur.

### Temayı değiştirme

 `config.rasi` `argvus-appearance` tema değişikliklerine sahiptir. Tema değiştiğinde, kullanıcı kopyalarını yeniden yazar, böylece `config.rasi` yeni `theme.rasi`'yi gösterir ve `theme.rasi`, aktif aile, düzen ve vurgulama rengini içeren tema yapısının başlatıcı paletini (`~/.config/argvus/data/generated/theme/current/launcher/theme.rasi`) içe aktarır. Tema yapısı olmadan, aile kopyasını içe aktarır ve Spaced düzeni, aktif ailenin `-spaced` varyantını seçer. Tema seçim araçları, tema menüsü ve düzen menüsü gibi, aynı `config.rasi`'yi okur, böylece aktif stili de kullanırlar.

`/usr/share/argvus/launcher/` altındaki dosyaları düzenlemeyin; paket yükseltmesi sırasında bunlar değiştirilir. Değişiklikleri kullanıcı kopyasında, `$XDG_CONFIG_HOME/argvus/data/rofi/` altında yapın.

## Proje değiştirici (`SUPER + O`)

`argvus projects` (`SUPER + O`) eklediğiniz projeleri listeler ve seçilen projeyi kendi Hyprland çalışma alanında açar, dizininde bir `argvus terminal` ile birlikte. Projenin çalışma alanı zaten mevcutsa, geçiş aracı sadece ona odaklanır.

Sadece klavye ile erişim için, `SUPER + ALT + 1`'dan `SUPER + ALT + 9`'ya listedeki o pozisyondaki projeyi menüsüz açın. Pozisyonlar menüde gösterilen numaralardır. Liste sırasını takip ederler, bu yüzden bir projeyi eklemek veya kaldırmak onları değiştirebilir. `argvus projects open <number or directory name>` aynı şeyi bir terminalden yapar ve hatalar bildirim olarak gösterilir.

Etkili proje listesi 9 ile sınırlıdır, çünkü `SUPER + ALT + 1..9` yalnızca bu kadarını adresleyebilir. `argvus projects add` (ve bunu çağıran Kontrol Merkezi'nin Projeler sayfası), toplamı 9'un üzerine çıkaracak bir proje veya kök eklemeyi reddeder ve bunun yerine hatayı bildirir.

Bir proje, `projects` bölümündeki `argvus-config` içinde iki yerden gelir:

- `paths`: bireysel proje dizinleri.
- `roots`: hemen alt dizinleri proje olan dizinler. Var olmayan bir kök dikkate alınmaz.

Varsayılan olarak herhangi bir kök veya yol yapılandırılmamıştır; `SUPER + O`'nin listelenecek bir şeyi olmadan önce en az bir tane ekleyin.

Bunları bir terminalden yönetin:

```sh
argvus projects add ~/Work/api          # one project
argvus projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus projects remove ~/Work/api       # removes it from paths and roots
argvus projects list                    # prints the roots and paths
```

`argvus projects pick` aynı listeyi gösterir ve açmak yerine seçilen yolu yazdırır. Diğer araçlar bunu kullanabilir, tıpkı `argvus git` gibi. İptal etmek hiçbir şey yazdırmaz.

Eğer kök veya yol yoksa, `SUPER + O` herhangi bir proje bulunamadığını bildirir. İsteğe bağlı bir editör komutu, `/projects/editor`, çalışma alanı oluşturulduğunda aynı çalışma alanında başlar.

Girdiler etkin yapılandırmadan okunur; başlatıcı bunların hiçbir kopyasını tutmaz.

Bir projeyi açmak aynı zamanda oturum için etkin proje olarak yolunu kaydeder; bu yolu Dev Dashboard telemetri bloğu (`argvus widget-telemetry`), ilgili projenin git, dinleme portları ve konteynerlerini raporlamak için okur.

## SSH ('SÜPER + ALT + S')

 opens a picker with the hosts defined in

. The selected host opens in a new ARGVUS terminal running

, in the current workspace.

### Kurulum

Add a

 entry for each server to

:

```ini
Host myhost
    HostName myhost.local
    User boss
    IdentityFile ~/.ssh/myhost
    IdentitiesOnly yes
```

 ~/.ssh/config  Host  ssh <host>  ~/.ssh/config  `SUPER + ALT + S`  `~/.ssh/config`  `ssh <host>`  `Host`  `~/.ssh/config` `ssh myhost`'nin önce normal bir terminalde çalıştığını doğrulayın. Başlatıcı yalnızca `ssh`'yi çalıştırır; kimlik doğrulama, anahtarlar ve sunucu doğrulaması OpenSSH tarafından yönetilir.

### Kullanım

1. `SUPER + ALT + S` tuşuna basın.
2. Sunucu adının bir kısmını yazın veya ok tuşlarını kullanın.
3. `Enter` tuşuna basın. Terminal açılır ve `ssh <host>`'yi çalıştırır.

Oturum sona erdiğinde, pencere açık kalır ve çıkış durumunu gösterir, örneğin `ssh exited with status 0. Press Enter to close.` Kapatmak için `Enter` tuşuna basın. Bu, GitHub, GitLab ve Gitea gibi platformlar için önemlidir: onlar sizi doğrular ve hemen bağlantıyı kapatır çünkü bir kabuk sağlamazlar. Pencere, mesajlarını ekranda kaybolmak yerine tutar.

### Kurallar

- Joker girişler (`Host *`, `Host *.internal`) hedef değil, eşleşme bloklarıdır ve asla listelenmez.
- Bir `Host` satırındaki her takma ad ayrı ayrı listelenir (`Host a b`, `a` ve `b`'yi listeler). Çoğaltmalar kaldırılır.
- Sadece `Include` ile yüklenen dosyalarda tanımlanan ana makineler listelenmez; seçim aracı yalnızca ana dosyayı okur.
- Yalnızca harflerden, rakamlardan, `.`, `-` ve `_`'den oluşan takma adlar başlatılır. Herhangi bir başka ad, bir bildirimle reddedilir.
- Yapılandırmadaki Windows satır sonları (CRLF) kabul edilir.
- `ARGVUS_SSH_CONFIG`, test etmek için faydalı olan yapılandırma dosyasının yolunu değiştirir.

### Komutlar

```sh
argvus ssh list          # prints the configured hosts, one per line
argvus ssh open myhost   # opens a specific host without the picker
```

### Sorun giderme

| Belirti | Nedeni ve çözümü |
| --- | --- |
| Notification "no hosts found in ~/.ssh/config" | The file is missing or has no `Host` lines. Run `argvus ssh list`kontrol etmek için. |
| Seçicide bir ana makine eksik | Bu bir joker karakterdir, bir `Include` dosyasından gelir veya izin verilen kümenin dışında karakterler içerir. Düz bir takma adla ana dosyaya koyun. |
| Pencere hemen bir hata durumu gösterir | Mesajın tamamını (ulaşılamayan ana bilgisayar, yanlış anahtar vb.) görmek için normal bir terminalde `ssh <host>` komutunu çalıştırın. |
| Pencerede metin yerine `message.ssh_session_ended` gösteriliyor | Kurulu `argvus` paketi bu sürümden daha eski. `argvus`'yu güncelleyin. |

, `openssh`'yu ve `argvus`'yu (`argvus terminal` komutu) gerektirir.

## SSH anahtarları (`argvus keys`)

`argvus keys`, `~/.ssh`'deki anahtar çiftlerini ve ssh-agent tarafından tutulan anahtarları yönetir. Bunun için bir kısayol yoktur. Kontrol Merkezi (Uygulamalar) içindeki **SSH anahtarları** sayfası aynı komutları kullanır.

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

Her komuta uygulanan kurallar:

- Bir anahtar adı, `~/.ssh` altında bir dosya adı olur, bu nedenle yalnızca harf, rakam, nokta, tire ve alt çizgi içerebilir. Nokta ile başlayamaz veya `.pub` ile bitemez. Mevcut bir çift asla üzerine yazılmaz.
- Yalnızca genel bir dosyaya (`NAME.pub`) sahip çiftler listelenir ve yalnızca onlar yüklenebilir, boşaltılabilir veya silinebilir.
- Parola cümleleri hiçbir zaman komut argümanları olarak geçirilmez, bir günlüğe yazılmaz veya Kontrol Merkezi'nde gösterilmez. `load` ve `generate --passphrase` bir ARGVUS terminali açar ve OpenSSH gizli bilgiyi bu terminalden okur.
- `list`, ajan ulaşılamadığında `unknown` değerini `loaded` sütununda bildirir. Asla tahmin etmez.
- `delete` özel anahtarı kalıcı olarak kaldırır. Hâlâ ihtiyaç duyduğunuz herhangi bir anahtarın bir kopyasını saklayın.
- `ARGVUS_SSH_DIR`, test için kullanışlı olan `~/.ssh`'nin yerini alır.

Temsilci, `argvus-ssh-agent.service` kullanıcısı hizmetidir ve `argvus-session` tarafından başlatılır. `SSH_AUTH_SOCK`, oturumda ona işaret eder.

`openssh` (`ssh-keygen` ve `ssh-add`) ve `argvus` (`argvus terminal` komutu) gerektirir.

| Belirti | Nedeni ve çözümü |
| --- | --- |
| `load` bir terminal açar, ancak anahtar yüklenmemiştir | O terminalde parolayı girin. Sorulmadıysa, çalıştırın `ssh-add -l` to see what the agent holds. |
| The terminal shows `Could not open a connection to your authentication agent` | Hyprland started before the agent did, so its terminals lack `SSH_AUTH_SOCK`. Başlatıcı geri düşer `$XDG_RUNTIME_DIR/ssh-agent.socket`, so update `argvus-launcher`ve yeni bir terminal açın. |
| `list` shows `unknown`içinde`loaded` column | The agent is not reachable. Check `systemctl --user status argvus-ssh-agent.service` and the `SSH_AUTH_SOCK` variable. |
| `delete` anahtarın yüklendiğini bildiriyor | Önce `argvus keys unload NAME`'yu çalıştırın, ardından tekrar silin. |
| `generate`adı zaten var | Başka bir ad seçin. Mevcut çiftler asla değiştirilmez |

## GPG anahtarları (`argvus gpg`)

`argvus gpg`, GPG anahtarlarını listeler, oluşturur ve dışa aktarır ve genel anahtarları içe aktarır. gpg-agent her zaman `pinentry-gtk` kullanır: ARGVUS, bir anahtar üretmeden önce pinentry'yi `gpg-agent.conf`'ye yazar. Kısayolu yoktur. Kontrol Merkezi'nin **GPG anahtarları** sayfası aynı komutları kullanır.

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

`generate` bu seçenekleri alır:

- `--algo rsa|dsa` anahtar algoritmasını seçer. Varsayılan `rsa`'dir.
- `--bits` anahtar boyutunu seçer. RSA, `1024`, `2048`, `3072` ve `4096`'yi kabul eder, varsayılan olarak `4096` kullanılır. DSA, `1024`, `2048` ve `3072`'yi kabul eder, varsayılan olarak `2048` kullanılır; gpg daha büyük DSA anahtarları oluşturamaz, bu yüzden `4096` gpg çalışmadan önce reddedilir.
- `--expire`, `0` için son kullanma tarihi olmadan alır, bir sayıdan sonra `d`, `w`, `m` veya `y` (örneğin `2y`) veya gerçek bir tarih olması gereken bir ISO tarihi `YYYY-MM-DD`.
- `--passphrase-stdin`, şifreyi standart girdinin ilk satırından okur. Kontrol Merkezi bunu kullanır. Boş bir satır reddedilir.
- `--no-passphrase --yes` korumasız bir anahtar oluşturur. İki parola modu birleştirilemez.

Her anahtar bir onayla ve imzala birincil anahtar ve bir şifreleme alt anahtarı alır, böylece dosyaları şifreleyebilir ve aynı zamanda commit’leri ve paketleri imzalayabilir. Alt anahtar birincil anahtarla eşleşir: RSA için aynı boyutta olan `rsa` ve DSA için DSA standardının gerektirdiği eşleştirme olan aynı boyutta `elg`.

Her komuta uygulanan kurallar:

- Parolalar asla komut argümanları olarak iletilmez, bir günlük dosyasına yazılmaz veya Kontrol Merkezi'nde gösterilmez. `--passphrase-stdin` ile parola, bir borudan dosya tanımlayıcısı 0 üzerinden gpg'ye gider. Bu seçenek olmadan, gpg pinentry penceresini sorar, `gpg-agent` bunu açar.
- `--no-passphrase` özel anahtarı koruma olmadan depolar. `--yes` de verilmedikçe reddedilir.
- `import`, ASCII veya ikili formda bir gizli anahtar paketini içeren herhangi bir dosyayı reddeder. Özel anahtarlar, yalnızca `export-private` aracılığıyla anahtar halkasından çıkar; bu, `--yes` gerektirir ve `600` yazma modunu kullanır; `import-private` onları geri getirir.
- Anahtarları değiştiren veya yayınlayan komutlar (`export-private`, `delete`, `edit sign`, `edit revoke`, `keyserver send`) `--yes` gerektirir. Kontrol Merkezi bunu yalnızca kendi onayından sonra iletir.
- Gizli anahtarı kullanan komutlar gpg'yi `--no-tty` ile çalıştırır, bu yüzden gpg hiç terminal açmaya çalışmaz. Parola, `generate --passphrase-stdin` dışında pinentry penceresinden gelir.
- `generate`, gpg-agent'in `pinentry-gtk` kullanmasını sağlar. Bu satırı `# BEGIN argvus-managed pinentry` ve `# END argvus-managed pinentry` işaretçileri arasına yazar, `gpg-agent.conf`'nin geri kalanını korur ve önceki dosyayı `gpg-agent.conf.bak` olarak kaydeder. Blok zaten `pinentry-gtk` olarak adlandırılmışsa, dosya ve gpg-agent olduğu gibi bırakılır. Komut, `gpg-agent.conf` zaten o blok dışında `pinentry-program` ayarlamışsa çalışmayı reddeder, böylece iki değer asla çelişmez.
- Paketin kurulumu hiç `~/.gnupg` yazmaz. Yapılandırma yalnızca bir anahtar oluşturulduğunda değişir.
- `GNUPGHOME`, `~/.gnupg`'yi değiştirir, bu test için kullanışlıdır.

`gnupg` ve `pinentry` gerekli bağımlılıklardır: anahtar komutları gpg gerektirir ve parola penceresi `pinentry-gtk`'dur.

| Belirti | Nedeni ve çözümü |
| --- | --- |
| `generate` parola penceresi açmıyor | `argvus gpg status`'yu kontrol edin. `pinentry-gtk` kurulmalı ve oturum `WAYLAND_DISPLAY` veya `DISPLAY`'yu açığa çıkarmalıdır. |
| `generate`, `pinentry-gtk`'nun kurulu olmadığını bildiriyor | `pinentry` paketini yükleyin. |
| `generate`, ARGVUS bloğunun dışında bir `pinentry-program` hattını rapor ediyor | Bu satırı `~/.gnupg/gpg-agent.conf`'dan kaldırın ve ardından komutu yeniden çalıştırın. |
| `generate`, anahtar boyutunun desteklenmediğini bildiriyor | Algoritmanın boyutunu kontrol edin: DSA 3072 bitte durur. |
| `generate`, şifreleme alt anahtarının eklenemediğini bildiriyor | Anahtar oluşturuldu. `gpg --quick-add-key FINGERPRINT cv25519 encr 2y` ile alt anahtarı ekleyin veya `gpg --delete-secret-and-public-key` ile anahtarı silin ve tekrar oluşturun.
| `import` bir dosyayı reddediyor | Dosya özel bir anahtar içeriyor. `argvus gpg export-public` ile yalnızca diğer makinedeki genel anahtarı dışa aktarın. |
| `list`'da anahtar görünmüyor | `GNUPGHOME` (veya `~/.gnupg`) içindeki anahtarlık boş. Bir anahtar oluşturmak için `argvus gpg generate` komutunu çalıştırın. |

## Parçacıklar (`SUPER + ALT + N`)

`SUPER + ALT + N` parçacıklarınızla bir seçim aracı açar. Seçilen parçacık, pano aracılığıyla gitmek yerine, odaklı pencereye ve imlecin bulunduğu konuma yazılır.

### Kurulum

Bir parçacık ekleyin, adı ve metniyle birlikte:

```sh
argvus snippets add "email" "you@example.com"
```

Saklandığını kontrol edin:

```sh
argvus snippets list
```

Kesitler, argvus config bölümünün `snippets` kısmında,  `argvus config` `{name, content}` girdileri olarak saklanır. `argvus config get /snippets/items` ile okuyabilirsiniz.

### Kullanım

1. Metni alması gereken uygulamanın metin alanına tıklayın.
2. `SUPER + ALT + N`'ya basın.
3. Kesiti adıyla seçin ve `Enter` tuşuna basın. Metin, imlecin bulunduğu yere yazılır.

### Komutlar

```sh
argvus snippets add "NAME" "CONTENT"   # adds a snippet, or replaces the one with the same name
argvus snippets remove NAME            # removes a snippet
argvus snippets list                   # prints index and name, one per line
argvus snippets open NAME              # types a snippet by name
argvus snippets open 2                 # types the snippet at position 2 of `list`
argvus snippets                        # opens the picker (same as the shortcut)
argvus snippets --help                 # shows the options and an example
```

### Kurallar

- İsimler benzersizdir ve büyük/küçük harfe duyarlıdır. Mevcut bir isimle bir snippet eklemek, onun içeriğini değiştirir.
- İçerik boş olamaz: boş bir snippet bulunamadı olarak raporlanır.
- `open`, sadece rakamlardan oluşan bir ismi pozisyon olarak ele alır. Belirsizlikten kaçınmak için `code2` gibi harf içeren isimler kullanın.
- Bir pozisyon, `list` tarafından gösterilen sıralamayı ifade eder. Bir parçacığı kaldırmak, sonrasındaki pozisyonları kaydırır.

### Sorun giderme

| Belirti | Nedeni ve çözümü |
| --- | --- |
| Kısayola basıldığında "parçacık yok" bildirimi | Henüz herhangi bir bölüm eklenmedi. Önce `argvus snippets add`'yu çalıştırın. |
| `open`parçacığın bulunamadığını bildiriyor | İsim tam olarak eşleşmiyor. İle karşılaştırın`argvus snippets list`. |
| Uygulamada hiçbir şey görünmüyor | Odaklanılan pencere bir metin alanı değildir veya XWayland altında çalışan ve bu tür girdileri göz ardı edebilecek bir X11 uygulamasıdır. Yerel bir Wayland uygulamasıyla test edin. |

Şunu gerektirir: `wtype`, `rofi`, `jq` ve `argvus` (`argvus config` komutu).

`wtype`, Wayland giriş seviyesinde tuş basımlarını simüle eder. XWayland altında çalışan bazı X11 uygulamaları bu olayları göz ardı eder, bu yüzden parça bulunduğu halde metin orada görünmeyebilir.

## Git (`SÜPER + ALT + G`)

`SUPER + ALT + G`, `SUPER + O` ile aynı proje seçim aracını açar. Bir proje seçmek, onu doğrudan `lazygit` (veya `gitui`) içinde açar ve mevcut çalışma alanında yeni bir ARGVUS terminali oluşturur. Projeyi önce seçmek için ayrı bir adım yoktur.

### Kurulum

İki araçtan birini yükleyin. Her ikisi de bu paketin isteğe bağlı bağımlılıklarıdır:

```sh
sudo pacman -S lazygit   # or: sudo pacman -S gitui
```

### Kullanım

1. `SUPER + ALT + G` tuşuna basın.
2. Listeden bir proje seçin veya iptal etmek için `Esc` tuşuna basın. İptal etmek hiçbir şeyi açmaz.
3. Terminal proje dizininde açılır ve TUI'yi başlatır.

Git deposu olmayan bir proje bildirim gösterir ve hiçbir şeyi açmaz. Seçiciyi atlamak için bir dizin geçin:

```sh
argvus git ~/Projects/api
```

### Aracı seçme

`argvus-git`, yüklendiğinde `lazygit`'yi ve aksi takdirde `gitui`'yi kullanır. `gitui`'yi tercih etmek için `ARGVUS_GIT_TUI`'yi komut için ayarlayın:

```sh
ARGVUS_GIT_TUI=gitui argvus git
```

Değişken, betiği çalıştıran komutun ortamından okunur. ARGVUS yapılandırmasında saklanmaz.

### Sorun giderme

| Belirti | Nedeni ve çözümü |
| --- | --- |
| "git deposu değil" bildirimi | Seçilen proje bir git deposu değil veya dizini taşınmış. `argvus projects remove` ile kaldırın veya düzeltin. |
| Bildirim "lazygit veya gitui'yi yükleyin" | `PATH`'da her iki araç da yok. Bunlardan birini yükleyin. |
| Seçici hiçbir proje göstermiyor | Hiçbir proje eklenmedi. `argvus projects add`'yu kullanın. |

## Emoji seçici (`SUPER + .`)

`SUPER + .`, ARGVUS Rofi yapılandırması ile `rofimoji`'yi açar. Bir emojiyi adına göre arayın, `Enter`'ye basın ve emoji panoya kopyalanır. `Ctrl + V` ile istediğiniz uygulamaya yapıştırın.

Seçici açıkken, oturum normalde gösterdiği klavye düzeni bildirimlerini yok sayar. Başlatıcı, ARGVUS önbellek dizininde kısa ömürlü bir işaretçi yazar ve seçici kapandıktan yaklaşık bir saniye sonra bunu kaldırır.

`rofimoji` ve `wl-clipboard` gerektirir.

## Hesap Makinesi (`SUPER + C`)

`SUPER + C` ARGVUS Rofi yapılandırması ile Rofi'nin `calc` modunu açar. Bir ifade yazın ve sonuç listesi yazdıkça güncellenir. `rofi-calc` modu tanımladığı şekilde bir sonuç seçin.

Başlatıcı paketi Rofi yapılandırmasını sağlar ve `rofi-calc`'ya bağımlıdır. Kısayolun kendisi `argvus-hyprland` tarafından beyan edilir.

## Hile sayfaları (`SUPER + SHIFT + /` ve `SUPER + CTRL + /`)

`cheatsheets.sh`, büyük bir Rofi penceresinde salt okunur kısayol listesini gösterir. Argümanı olarak uygulama adını alır:

```sh
cheatsheets.sh hypr     # Hyprland shortcuts (SUPER + SHIFT + /)
cheatsheets.sh kitty    # terminal shortcuts (SUPER + CTRL + /)
cheatsheets.sh <name>   # any other application with a cheatsheet
```

- `hypr`, dosya mevcut olduğunda kullanıcının ARGVUS yapılandırmasından `data/generated/hypr/keybindings.txt` kullanır. Aksi takdirde `argvus-hyprland` ile birlikte gelen Hyprland hile sayfasını kullanır.
- `kitty`, `argvus` ile birlikte sağlanan terminal hile sayfasını kullanır.
- Diğer herhangi bir isim `<name>/docs/cheatsheets/<language>.txt` dosyasını okur. Eğer bu dosya mevcut değilse, hiçbir pencere açılmaz.

Sistem yerel ayarı `pt-BR` olduğunda dil Portekizce, aksi takdirde İngilizcedir. `Esc` pencereyi kapatır. Bir satırı seçmek sadece pencereyi kapatır; hiçbir şey çalıştırılmaz.

## Diğer menüler Rofi yapılandırmasını kullanır

Başlatıcı yapılandırması diğer paketlere ait bileşenlerle paylaşılır:

- Pano geçmişi (`SUPER + H`) ve temizleme kısayolu (`SUPER + SHIFT + H`) `argvus-hyprland` tarafından bildirilir. Bu yapılandırmayla `cliphist`'yi Rofi'ye aktarırlar. `cliphist`, geçmişi dolduran pano kaydediciyi çalıştıran `argvus-session`'den gelir; `argvus` meta-paketi de buna bağımlıdır.
- `argvus-appearance`'deki tema, vurgu ve düzen seçicileri, `config.rasi` ile Rofi'yi açar.
- Hyprland pencere kuralları, `argvus-launcher` ve `rofi` ad alanlarını tanır, bu nedenle menüler başlatıcı yüzey muamelesi alır.

## Paketleme ve bağımlılıklar

`argvus-launcher` paketi mimariden bağımsızdır ve şunları yükler:

- `argvus launcher`, `argvus-snippets`, `argvus-ssh` ve `argvus-git`, aynı dizin altında;
- `/usr/share/argvus/launcher/config/`, Rofi yapılandırması ve temaları ile;
- `/usr/share/argvus/launcher/sh/`, `cheatsheets.sh` ve `emoji-picker.sh` ile.

Gerekli bağımlılıklar: `argvus-session`, `argvus-appearance`, `argvus`, `bash`, `jq`, `hyprland`, `libnotify`, `rofi`, `rofi-calc`, `rofimoji`, `wl-clipboard`, `wtype`, `gnupg` ve `pinentry` (`pinentry-gtk` sağlar). İsteğe bağlı bağımlılıklar: `openssh`, SSH seçici ve SSH anahtar yöneticisi için; `lazygit` ve `gitui`, git TUI için.

Paketin kurulumu `$HOME` içerisine yazmaz. Kullanıcı yapılandırması, [Rofi configuration and themes](#where-the-active-configuration-lives) bölümünde açıklandığı gibi oturum başında oluşturulur.

## Sorun giderme

| Belirti | Nedeni ve çözümü |
| --- | --- |
| `SUPER + D`hiçbir şey açmıyor | Kontrol et`argvus launcher` in a terminal. Confirm that `rofi`Yüklü olduğunu ve Rofi yapılandırmasının mevcut olduğunu kontrol edin. |
| `SUPER + D` hiç uygulama listelemiyor | Uygulamaların masaüstü girdisi yok. Sadece ile başlayan uygulamalar `.desktop` file are shown. |
| Menüler eski bir yazı tipini kullanıyor | `font:` satırı oturum başlangıcında yeniden yazılır. Yazı tipini değiştirdikten sonra oturumu yeniden başlatın. |
| Tema değişikliği Rofi menülerine ulaşmıyor | `$XDG_CONFIG_HOME/argvus/data/rofi/`'daki `config.rasi` kullanıcı kopyasının hala paketlenmiş temayı gösterip göstermediğini kontrol edin. Temayı `argvus-appearance`'dan tekrar uygulayın. |
| `SUPER + O` hiçbir proje bulunamadığını bildiriyor | Hiçbir kök veya yol yapılandırılmamış veya dizinler artık mevcut değil. `argvus projects list`'yu çalıştırın. |
| `SUPER + C` veya emoji seçici açılmıyor | `rofi-calc` veya `rofimoji`'yu yükleyin (her ikisi de gerekli bağımlılıklardır). |
| Hile sayfası açılmıyor | Bu ismin ve dilin dosyası mevcut değil. Hile Sayfaları bölümünde açıklanan yolları kontrol edin. |
| `SUPER + H` hiçbir şey göstermiyor | Geçmiş boş veya pano kaydedici şundan `argvus-session` has not stored anything yet. |

## İlgili bileşenler

| Bileşen | Sorumluluk |
| --- | --- |
| `argvus-hyprland` | Menülere ilişkin kısayolları ve Hyprland pencere kurallarını bildirir. |
| `argvus-appearance` | Etkin temayı, vurguyu ve düzeni değiştirir ve Rofi tema referanslarını yeniden yazar. |
| `argvus` (`argvus config`) | Projeleri, kod parçacıklarını ve varsayılan başlatıcı ayarını saklar. |
| `argvus-session` | Başlangıç ​​Rofi yapılandırmasını kopyalar ve oturum başlangıcında yazı tipini ayarlar. |
| `argvus` (`argvus terminal`) | SSH oturumlarını, proje terminallerini ve `argvus keys` parola istemlerini açar. |
| `argvus` (`argvus widget-telemetry`) | `argvus projects` tarafından yazılan aktif projeyi okur. |
| `argvus` (`argvus i18n`) | Başlatıcı komut dosyaları tarafından kullanılan çevrilmiş mesajları sağlar. |
| `argvus` (`argvus control-center`) | Proje listesini `argvus projects` aracılığıyla düzenler. |
