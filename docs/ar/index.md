---
title: المشغّل والبحث
description: المشغّل والبحث — Quickshell/QML + Rust.
---


-                                            ؛(`SUPER + D`) ﺕﺎﻘﻴﺒﻄﺘﻟﺍ ﻞﻐﺸﻣ
- ;(`argvus projects`، `argvus ssh`، `argvus snippets`) ﺕﺎﺻﺎﺼﻘﻟﺍ ﻲﻘﺘﻨﻣﻭ SSH
- ؛ﺢﻴﺗﺎﻔﻤﻟﺍ ﺝﺍﻭﺯﺃ ﻑﺬﺤﻳﻭ ﻞّﻤﺤﻳﻭ ﺽﺮﻌﻳﻭ ﺊﺸﻨﻳ ﻱﺬﻟﺍ ،SSH (`argvus keys`) ﺢﻴﺗﺎﻔﻣ ﺮﻳ
-                                                              ) GPG ﺢﻴﺗﺎﻔﻣ ﺮﻳﺪﻣ`argvus gpg`                ;gpg ﻞﻴﻛﻮﻟ pinentry-gtk ﺪﻌﻳﻭ ﺢﻴﺗﺎﻔﻤﻟﺍ ﺭﺪﺼﻳﻭ ﺊﺸﻨﻳﻭ ﺩﺮﺴﻳ ﻱﺬﻟﺍ ,(
-                    .ﺔﺒﺳﺎﺤﻟﺍ ﺔﻟﻵ﻿ﺍ ﺔﻤﺋﺎﻗﻭ ﺶﻐﻟﺍ ﺔﻗﺭﻭ ﺽﺭﺎﻋ ،ﺔﻳﺮﻴﺒﻌﺘﻟﺍ ﺯﻮﻣﺮﻟﺍ ﻲﻘﺘﻨﻣ

.ﺎﻬﺑ ﺔﻄﺒﺗﺮﻤﻟﺍ ﻢﺋﺍﻮﻘﻟﺍﻭ ﺮﻣﺍﻭﻷ﻿ﺍ ﺔﻣﺰﺤﻟﺍ ﻩﺬﻫ ﺮﻓﻮﺗ .`argvus-hyprland` ﺔﻄﺳﺍﻮﺑ ﺕﺍﺭﺎﺼﺘ

## الاختصارات

| الاختصار | العمل | الأمر | القسم |
| --- | --- | --- | --- |
| `SUPER + D` | ARGVUS Launcher | `argvus launcher` | مشغل التطبيقات |
| `SUPER + O` | مشروع الجلاد | `argvus projects` | مشروع الجلاد |
| `SUPER + ALT + 1` to `9`                                               | ﻊﺿﻮﻤﻟﺍ ﻚﻟﺫ ﻲﻓ ﻉﻭﺮﺸﻤﻟﺍ ﺢﺘﻓﺍ | `argvus projects open N`                                                             | ﻉﻭﺮﺸﻤﻟﺍ ﻝّﺪﺒﻣ |
| `SUPER + ALT + S` | منتقي مضيف SSH | `argvus ssh` | سش |
| `SUPER + ALT + N` | منتقي المقتطفات | `argvus snippets` | مقتطفات |
| `SUPER + ALT + G` | منتقي المشروع، ثم git TUI | `argvus git` | بوابة |
| `SUPER + .` | ARGVUS Emoji | `argvus emoji-picker` | ARGVUS Emoji |
| `SUPER + C` | حاسبة | `argvus calculator` | حاسبة |

## المشغّل والبحث


يستخدم المشغّل تخطيط TUI مدمجًا بخط ثابت العرض وبحث وفئات متراصة ومفضلة مدمجة وتذييل مساعدة منفصل. تتبع سماكة الحدود واستدارتها إعدادات ARGVUS الحالية.

يتبع المشغّل لغة واجهة ARGVUS المختارة في مركز التحكم.

`argvus launcher` · `argvus control-center launcher`

↑↓ تنقل · Enter فتح · Esc رجوع · Ctrl+F مفضلة

- إعداد البحث: التطبيقات, النوافذ, الترتيبات, الإجراءات, المشاريع, SSH, الملفات, النجدة.
- إضافة مجلد للفهرسة / إضافة استثناء — مسار مطلق.
- إيقاف الفهرسة مؤقتًا / مسح الفهرس والإيقاف مؤقتًا / إعادة بناء الفهرس.
- ↑↓ تنقل · Enter تبديل/إضافة · Delete حذف · Ctrl+↑↓ ترتيب · F5 تحديث · Esc رجوع

`argvus config get /launcher --effective`

`$XDG_CONFIG_HOME/argvus/config/launcher.json` → `$XDG_CACHE_HOME/argvus/launcher/index.json`

Quickshell: `launcher/Theme.qml`

إعداد البحث → `argvus control-center launcher`.

##                                                            ﻲﻓﻭﺭ ﺕﺎﻤﻴﺛﻭ ﺕﺍﺩﺍﺪﻋﺇ


| ملف | الدور |
| --- | --- |

ﺩ





.ﺔﺨﺴﻨﻟﺍ ءﺎﺸﻧﺈﺑ ﺮﻬﻈﻤﻟﺍ ﻲﻓ ﻝﻭﻷ﻿ﺍ ﺮﻴ

### ﺔﻤﺴﻟﺍ ﺮﻴﻴﻐﺗ




##                                               (`SUPER + O`) ﻉﻭﺮﺸﻤﻟﺍ ﻝﺪﺒﻣ

`argvus projects` (`SUPER + O` ﻊﻣ ،Hyprland ﻲﻓ ﺔﺻﺎﺨﻟﺍ ﻪﻠﻤﻋ ﺔﺣﺎﺴﻣ ﻲﻓ ﺩﺪﺤﻤﻟﺍ ﻉﻭﺮﺸﻤﻟﺍ ﺢﺘﻔﻳﻭ ﺎﻬﺘﻔﺿﺃ ﻲﺘﻟﺍ ﻊﻳﺭﺎﺸﻤﻟ`argvus terminal`   .ﻂﻘﻓ ﺎﻬﻴﻠﻋ ﺰﻴﻛﺮﺘﻟﺍ ﺮﺼﺘﻘﻳ ،ﻞﻌﻔﻟﺎﺑ ﺓﺩﻮﺟﻮﻣ ﻉﻭﺮﺸﻤﻟﺍ ﻞﻤﻋ ﺔﺣﺎﺴﻣ ﻥﺎﻛ ﺍﺫﺇ .ﻪﻠﻴﻟﺩ ﻲﻓ



قائمة المشاريع الفعالة محددة بـ 9، نظرًا لأن هذا هو كل مشاريع argvus المفتوحة <الرقم أو اسم الدليل> SUPER + ALT + 9 `SUPER + ALT + 1` `SUPER + ALT + 9` `argvus projects open <number or directory name>` `SUPER + ALT + 1..9` يمكن معالجتها. `argvus projects add` (وصفحة المشاريع في مركز التحكم، التي تستدعيها) يرفض إضافة مشروع أو جذر من شأنه أن يدفع الإجمالي إلى ما بعد 9، ويبلغ عن الخطأ بدلاً من ذلك.

         :argvus-config ﻦﻣ `projects` ﻢﺴﻗ ﻲﻓ ﻦﻴﻧﺎﻜﻣ ﻦﻣ ﻉﻭﺮﺸﻤﻟﺍ ﻲﺗﺄﻳ

-  `argvus-config` `paths`: ﺔﻳﺩﺮﻔﻟﺍ ﻊﻳﺭﺎﺸﻤﻟﺍ ﺕﺍﺪﻠﺠﻣ.
- `roots`: ﻪﻟ ﺩﻮﺟﻭ ﻻ﻿ ﻱﺬﻟﺍ ﺭﺬﺠﻟﺍ ﻞﻫﺎﺠﺗ ﻢﺘﻳ .ﻊﻳﺭﺎﺸﻣ ﻲﻫ ﺔﻳﺭﻮﻓ ﺔﻴﻋﺮﻓ ﺕﺍﺪﻠﺠ

.ﻪﺿﺮﻌﻴﻟ ءﻲﺷ ﻱﺃ `SUPER + O` ﻯﺪﻟ ﻥﻮﻜﻳ ﻥﺃ ﻞﺒﻗ ﻞﻗﻷ﻿ﺍ ﻰﻠﻋ ﺍًﺪﺣﺍﻭ ﻒﺿﺃ ؛ﻲﺿﺍﺮﺘﻓﺍ ﻞ

                                                   :ﺔﻴﻓﺮﻄﻟﺍ ﻝﻼ﻿ﺧ ﻦﻣ ﺎﻬﺗﺭﺍﺩﺈﺑ ﻢﻗ

```sh
argvus projects add ~/Work/api          # one project
argvus projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus projects remove ~/Work/api       # removes it from paths and roots
argvus projects list                    # prints the roots and paths
```

`argvus projects pick`ﺎﻤﻛ ،ﻪﻣﺍﺪﺨﺘﺳﺍ ﻯﺮﺧﻷ﻿ﺍ ﺕﺍﻭﺩﻸ﻿ﻟ ﻦﻜﻤﻳ .ﻪﺤﺘﻓ ﻦﻣ ًﻻ﻿ﺪﺑ ﺭﺎﺘﺨﻤﻟﺍ ﺭﺎﺴﻤﻟﺍ ﻊﺒﻄﻳﻭ ﺔﻤﺋﺎﻘﻟﺍ ﺲﻔﻧ `argvus git`                                                      .ﺎًﺌﻴﺷ ﻊﺒﻄﻳ ﻻ﻿ ءﺎﻐﻟﺇ .ﻞﻌﻔﻳ

                                                  ،ﺭﺎﺴﻤﻟﺍ ﻭﺃ ﺭﺬﺠﻟﺍ ﺪﺟﻮﺗ ﻢﻟ ﺍﺫﺇ`SUPER + O`                      ،ﻱﺭﺎﻴﺘﺧﺍ ﺭﺮﺤﻣ ﺮﻣﺃ .ﻊﻳﺭﺎﺸﻣ ﻱﺃ ﻰﻠﻋ ﺭﻮﺜﻌﻟﺍ ﻢﺘﻳ ﻢﻟ ﻪﻧﺄﺑ ﺪﻴﻔُﻳ`/projects/editor`                              .ﻞﻤﻌﻟﺍ ﺔﺣﺎﺴﻣ ءﺎﺸﻧﺇ ﺪﻨﻋ ﻞﻤﻌﻟﺍ ﺔﺣﺎﺴﻣ ﺲﻔﻧ ﻲﻓ ﺃﺪﺒﻳ ,

            .ﺎﻬﻨﻣ ﺔﺨﺴﻧ ﻱﺄﺑ ﻆﻔﺘﺤﻳ ﻻ﻿ ﻞﻐﺸﻤﻟﺍ ؛ﻝﺎﻌﻔﻟﺍ ﻦﻳﻮﻜﺘﻟﺍ ﻦﻣ ﺕﻻ﻿ﺎﺧﺩﻹ﻿ﺍ ﺓءﺍﺮﻗ ﻢﺘﻳ

)ـﺑ ﺭﻮﻄﻤﻟﺍ ﺕﺎﻣﻮﻠﻌﻣ ﺔﺣﻮﻟ ﻲﻓ ﺪﻌُﺑ ﻦﻋ ﺱﺎﻴﻘﻟﺍ ﺔﻠﺘﻛ ﻡﻮﻘﻳ ﻱﺬﻟﺍﻭ ،ﺔﺴﻠﺠﻠﻟ ﻂﺸﻧ ﻉﻭﺮﺸﻤﻛ ﻩﺭ`argvus widget-telemetry`                   .ﺕﺎﻳﻭﺎﺤﻟﺍﻭ ﻉﺎﻤﺘﺳﻻ﻿ﺍ ﺬﻓﺎﻨﻣﻭ ،ﻉﻭﺮﺸﻤﻟﺎﺑ ﺹﺎﺨﻟﺍ git ﺮﻳﺮﻘﺘﻟ ﺃﺮﻘﻳ (

##                                                  (`SUPER + ALT + S`) ﺶﺗﺇ ﺱﺇ ﺱﺇ

**ARGVUS SSH** · GTK 4 / Wayland · `↑` `↓` `Enter` `Esc`

`SUPER + ALT + S`                                              ﻲﻓ ﻦﻳﺩﺪﺤﻤﻟﺍ ﻦﻴﻔﻴﻀﻤﻟﺎﺑ ﺍًﺩﺪﺤﻣ ﺢﺘﻔﻳ`~/.ssh/config`                               ﻞﻤﻌﺗ ﺓﺪﻳﺪﺟ ARGVUS ﺔﻴﻓﺮﻃ ﻲﻓ ﺢﺘﻔﻳ ﺩﺪﺤﻤﻟﺍ ﻒﻴﻀﻤﻟﺍ .`ssh <host>`                                                     .ﺔﻴﻟﺎﺤﻟﺍ ﻞﻤﻌﻟﺍ ﺔﺣﺎﺴﻣ ﻲﻓ ،

### الإعداد

                   :~/.ssh/config ﻰﻟﺇ ﻡﺩﺎﺧ ﻞﻜﻟ `Host` ﻝﺎﺧﺩﺇ ﻒﺿﺃ

```ini
Host myhost
    HostName myhost.local
    User boss
    IdentityFile ~/.ssh/myhost
    IdentitiesOnly yes
```

تأكد من أن `~/.ssh/config` `ssh myhost` يعمل في محطة عادية أولاً. المشغل يعمل فقط على `ssh`؛ تتم معالجة المصادقة والمفاتيح والتحقق من المضيف بواسطة OpenSSH.

### استخدم

1. اضغط على `SUPER + ALT + S`.
2.                               .ﻢﻬﺴﻟﺍ ﺢﻴﺗﺎﻔﻣ ﻡﺪﺨﺘﺳﺍ ﻭﺃ ،ﻒﻴﻀﻤﻟﺍ ﻢﺳﺍ ﻦﻣ ﺍًءﺰﺟ ﺐﺘﻛﺍ
3.                    . `Enter` `ssh <host>` ﻞﻐﺸﻳﻭ ﻑﺮﻄﻟﺍ ﺢﺘﻔﻳ . `ssh exited with status 0. Press Enter to close.` `Enter` ﻂﻐﺿﺍ



### القواعد

-                                                      ) ﺔﺤﻣﺎﺠﻟﺍ ﺕﺎﻗﺎﻄﺒﻟﺍ ﺕﻻ﻿ﺎﺧﺩﺇ`Host *`, `Host *.internal`                             .ﺍًﺪﺑﺃ ﺎﻫﺩﺮﺳ ﻢﺘﻳ ﻻ﻿ﻭ ،ﺎًﻓﺍﺪﻫﺃ ﺖﺴﻴﻟﻭ ،ﺔﻘﺑﺎﻄﻣ ﻞﺘﻛ ﻲﻫ (
-                                                              ﻰﻠﻋ ﺭﺎﻌﺘﺴﻣ ﻢﺳﺍ ﻞﻛ`Host`                                                  ) ﻞﺼﻔﻨﻣ ﻞﻜﺸﺑ ﺮﻄﺴﻟﺍ ﺝﺍﺭﺩﺇ ﻢﺘﻳ`Host a b` lists `a` and `b`                                                   .ﺓﺭﺮﻜﻤﻟﺍ ﺦﺴﻨﻟﺍ ﺔﻟﺍﺯﺇ ﻢﺘﻳ .(
-                                    ﻊﻣ ﺔﻠﻤﺤﻤﻟﺍ ﺕﺎﻔﻠﻤﻟﺍ ﻲﻓ ﻂﻘﻓ ﻥﻭﺩﺪﺤﻤﻟﺍ ﻥﻮﻔﻴﻀﻤﻟﺍ`Include`                                     .ﻂﻘﻓ ﻲﺴﻴﺋﺮﻟﺍ ﻒﻠﻤﻟﺍ ﺩﺪﺤُﻤﻟﺍ ﺃﺮﻘﻳ ؛ﺔﺟﺭﺪﻣ ﺮﻴﻏ
-                               ،ﻡﺎﻗﺭﻷ﻿ﺍﻭ ﻑﻭﺮﺤﻟﺍ ﻦﻣ ﺔﻋﻮﻨﺼﻤﻟﺍ ﺓﺭﺎﻌﺘﺴﻤﻟﺍ ءﺎﻤﺳﻷ﻿ﺍ ﻂﻘﻓ`.`, `-` and `_`                                         .ﺭﺎﻌﺷﺇ ﻊﻣ ﺾﻓﺮُﻳ ﺮﺧﺁ ﻢﺳﺍ ﻱﺃ .ﺎﻬﻗﻼ﻿ﻃﺇ ﻢﺘﻳ
-                           .ﺕﺍﺩﺍﺪﻋﻹ﻿ﺍ ﻲﻓ (CRLF) ﺯﻭﺪﻨﻳﻮﻟﺍ ﻲﻓ ﺮﻄﺳﻷ﻿ﺍ ﺕﺎﻳﺎﻬﻧ ﻝﻮﺒﻗ ﻢﺗ
- `ARGVUS_SSH_CONFIG` ﺭﺎﺒﺘﺧﻼ﻿ﻟ ﺪﻴﻔﻣ ﺮﻣﺃ ﻮﻫﻭ ،ﺕﺍﺩﺍﺪﻋﻹ﻿ﺍ ﻒﻠﻣ ﺭﺎﺴﻣ ﻝﺪﺒﺘﺴﻳ.

### الأوامر

```sh
argvus ssh list          # prints the configured hosts, one per line
argvus ssh open myhost   # opens a specific host without the picker
```

### استكشاف الأخطاء وإصلاحها

| العَرَض | السبب والإصلاح |
| --- | --- |
ﻰﻠﻋ ﻱﻮﺘﺤﻳ ﻻ﻿ ﻭﺃ ﺩﻮﻘﻔﻣ ﻒﻠﻤﻟﺍ | "ssh/config./~ ﻲﻓ ﻦﻴﻔﻴﻀﻣ ﻰﻠﻋ ﺭﻮﺜﻌﻟﺍ ﻢﺘﻳ ﻢﻟ" ﺭﺎﻌﺷﺇ`Host`                                                                  ﻞﻴﻐﺸﺗ .ﺮﻄﺳﻷ﻿ﺍ`argvus ssh list`                                                                     | .ﻖﻘﺤﺘﻠﻟ
                           ﻦﻣ ﻲﺗﺄﻳ ،ﻝﺪﺑ ﺰﻣﺭ ﻪﻧﺇ | ﺭﺎﻴﺘﺧﻻ﻿ﺍ ﺓﺍﺩﺃ ﻦﻣ ﺩﻮﻘﻔﻣ ﻒﻴﻀﻣ |`Include`| .ﻱﺩﺎﻋ ﺭﺎﻌﺘﺴﻣ ﻢﺳﺎﺑ ﻲﺴﻴﺋﺮﻟﺍ ﻒﻠﻤﻟﺍ ﻲﻓ ﻪﻌﺿ .ﺎﻬﺑ ﺡﻮﻤﺴﻤﻟﺍ ﺔﻋﻮﻤﺠﻤﻟﺍ ﺝﺭﺎﺧ ﻑﺮﺣﺃ ﻰﻠﻋ ﻱ
                                     ﻞﻴﻐﺸﺗ | ﺭﻮﻔﻟﺍ ﻰﻠﻋ ﺄﻄﺧ ﺔﻟﺎﺣ ﺓﺬﻓﺎﻨﻟﺍ ﺽﺮﻌﺗ |`ssh <host>`   | .(ﺍﺬﻜﻫﻭ ،ﺊﻃﺎﺧ ﺡﺎﺘﻔﻣ ،ﺡﺎﺘﻣ ﺮﻴﻏ ﻒﻴﻀﻤﻟﺍ) ﺔﻠﻣﺎﻜﻟﺍ ﺔﻟﺎﺳﺮﻟﺍ ﺔﻳﺅﺮﻟ ﺔﻳﺩﺎﻋ ﺔﻄﺤﻣ ﻲﻓ
                                                                ﺓﺬﻓﺎﻨﻟﺍ ﺮﻬﻈُﺗ |`message.ssh_session_ended`                                                          ﺖﺒﺜﻤﻟﺍ | ﺺﻨﻟﺍ ﻦﻣ ًﻻ﻿ﺪﺑ`argvus`                                        ﺚﻳﺪﺤﺘﻟﺎﺑ ﻢﻗ .ﺭﺍﺪﺻﻹ﻿ﺍ ﺍﺬﻫ ﻦﻣ ﻡﺪﻗﺃ ﺔﻣﺰﺤﻟﺍ`argvus`. |

          .(argvus terminal ﺮﻣﺃ) argvus ﻭ `openssh` ﺐﻠﻄﺘﻳ

##                                                 SSH ( argvus terminal  `argvus`  `argvus terminal` `argvus keys`) ﺢﻴﺗﺎﻔﻣ

`argvus keys` ﻲﻓ ﺢﻴﺗﺎﻔﻤﻟﺍ ﺝﺍﻭﺯﺃ ﺮﻳﺪﻳ `~/.ssh` ﺎﻬﺑ ﻆﻔﺘﺤﻳ ﻲﺘﻟﺍ ﺢﻴﺗﺎ

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

                                                :ﺮﻣﺃ ﻞﻛ ﻰﻠﻋ ﻖﺒﻄﻨﺗ ﻲﺘﻟﺍ ﺪﻋﺍﻮﻘﻟﺍ

-                                                   ﺖﺤﺗ ﻒﻠﻣ ﻢﺳﺍ ﺡﺎﺘﻔﻤﻟﺍ ﻢﺳﺍ ﺢﺒﺼﻳ`~/.ssh`ﺏ ﻲﻬﺘﻨﻳ ﻭﺃ ﺔﻄﻘﻨﺑ ﺃﺪﺒﻳ ﻥﺃ ﻦﻜﻤﻳ ﻻ﻿ .ﺔﻴﻠﻔﺳ ﺔﻃﺮﺷﻭ ﺔﻃﺮﺷﻭ ﺔﻄﻘﻧﻭ ﻡﺎﻗﺭﺃﻭ ﻑﻭﺮﺣ ﻰﻠﻋ ﻂﻘﻓ ﻱ`.pub`                                             .ﺩﻮﺟﻮﻣ ﺝﻭﺯ ﻕﻮﻓ ﺔﺑﺎﺘﻜﻟﺍ ًﺍﺪﺑﺃ ﻢﺘﻳ ﻻ﻿
- .ﺎﻬﻓﺬﺣ ﻭﺃ ﺎﻬﻐﻳﺮﻔﺗ ﻭﺃ ﺎﻬﻠﻴﻤﺤﺗ ﻦﻜﻤﻳ ﻚﻠﺗ ﻂﻘﻓﻭ ،(`NAME.pub`) ﻂﻘﻓ ﻡﺎﻋ ﻒﻠﻣ ﻰﻠ
- .ﻢﻜﺤﺘﻟﺍ ﺰﻛﺮﻣ ﻲﻓ ﺽﺮﻌُﺗ ﻭﺃ ﻞﺠﺴﻟﺍ ﻲﻓ ﺐﺘﻜُﺗ ﻻ﻿ﻭ ،ﺍًﺪﺑﺃ ﺮﻣﺍﻭﻸ﻿ﻟ ﻂﺋﺎﺳﻮﻛ ﺭﻭﺮﻤﻟﺍ ﺕﺍﺭﺎﺒﻋ ﺮﻳﺮ`load` and `generate --passphrase`                         .ﺔﻴﻓﺮﻄﻟﺍ ﻚﻠﺗ ﻦﻣ ﺮﺴﻟﺍ ﺃﺮﻘﻳ OpenSSHﻭ ،ARGVUS ﺔﻴﻓﺮﻃ ﺢﺘﻓﺍ
- `list` reports `unknown`                                                                         ﻝﺍ ﻲﻓ`loaded`                           .ﺍًﺪﺑﺃ ﻦﻤﺨﻳ ﻻ﻿ .ﻞﻴﻛﻮﻟﺍ ﻰﻟﺇ ﻝﻮﺻﻮﻟﺍ ﻦﻜﻤﻳ ﻻ﻿ ﺎﻣﺪﻨﻋ ﺩﻮﻤﻌﻟﺍ
- `delete`         .ﻪﻴﻟﺇ ﺔﺟﺎﺤﺑ ﻝﺍﺰﺗ ﻻ﻿ ﺡﺎﺘﻔﻣ ﻱﺃ ﻦﻣ ﺔﺨﺴﻨﺑ ﻆﻔﺘﺣﺍ .ﺎًﻴﺋﺎﻬﻧ ﺹﺎﺨﻟﺍ ﺡﺎﺘﻔﻤﻟﺍ ﻞﻳﺰﻳ
- `ARGVUS_SSH_DIR` ﻝﺪﺒﺘﺴﻳ `~/.ssh`، ﺭﺎﺒﺘﺧﻼ﻿ﻟ ﺪﻴﻔﻣ ﻮﻫﻭ.

                                                                     ﻮﻫ ﻞﻴﻛﻮﻟﺍ`argvus-ssh-agent.service`                                                   ﺔﻄﺳﺍﻮﺑ ﻡﺪﺨﺘﺴﻤﻟﺍ ﺔﻣﺪﺧ ءﺪﺑ ﻢﺗ`argvus-session`. `SSH_AUTH_SOCK`                                                          .ﺔﺴﻠﺠﻟﺍ ﻲﻓ ﻪﻴﻟﺇ ﺮﻴﺸﻳ

GPG

| العَرَض | السبب والإصلاح |
| --- | --- |
|  argvus terminal  argvus  ssh-add  ssh-keygen  `openssh`  `ssh-keygen`  `ssh-add`  `argvus`  `argvus terminal` `load` opens a terminal, but the key is not loaded | Type the passphrase in that terminal. If it was not asked, run `ssh-add -l` to see what the agent holds. |
                                                                ﺔﻴﻓﺮﻄﻟﺍ ﺽﺮﻌﻳ |`Could not open a connection to your authentication agent`                        ﻪﺗﺎﻳﺎﻬﻧ ﺮﻘﺘﻔﺗ ﺍﺬﻟ ،ﻞﻴﻛﻮﻟﺍ ﺃﺪﺒﻳ ﻥﺃ ﻞﺒﻗ ﺪﻧﻻ﻿ﺮﻴﺒﻳﺎﻫ ﺃﺪﺑ | `SSH_AUTH_SOCK`                                                             ﻰﻟﺇ ﻞﻐﺸﻤﻟﺍ ﺩﻮﻌﻳ .`$XDG_RUNTIME_DIR/ssh-agent.socket`                                                                     ﺙّﺪﺣ ﺍﺬﻟ ،`argvus-launcher`                                                         | .ﺓﺪﻳﺪﺟ ﺔﻴﻓﺮﻃ ﺢﺘﻓﺍﻭ
| `list` shows `unknown`                                                                         ﻝﺍ ﻲﻓ`loaded`                                                  ﻖﻘﺤﺗ .ﺡﺎﺘﻣ ﺮﻴﻏ ﻞﻴﻛﻮﻟﺍ | ﺩﻮﻤﻋ`systemctl --user status argvus-ssh-agent.service`                                                                         ﻝﺍ ﻭ `SSH_AUTH_SOCK` variable. |
| `delete`                                              ﻞﻴﻐﺸﺗ | ﻞّﻤﺤﻣ ﺡﺎﺘﻔﻤﻟﺍ ﻥﺃ ﻰﻟﺇ ﺮﻴﺸﻳ`argvus keys unload NAME`                                                     | .ﻯﺮﺧﺃ ﺓﺮﻣ ﻪﻓﺬﺣﺍ ﻢﺛ ،ًﻻ﻿ﻭﺃ
| `generate`| .ﺍًﺪﺑﺃ ﺎﻬﻟﺍﺪﺒﺘﺳﺍ ﻢﺘﻳ ﻻ﻿ ﺓﺩﻮﺟﻮﻤﻟﺍ ﺝﺍﻭﺯﻷ﻿ﺍ .ﺮﺧﺁ ﺎًﻤﺳﺍ ﺮﺘﺧﺍ | ﻞﻌﻔﻟﺎﺑ ﺩﻮﺟﻮﻣ ﻢﺳﻻ﻿ﺍ ﻥﺃ

## (`argvus gpg`)

 gpg-agent.conf  pinentry-gtk  `argvus gpg`  `pinentry-gtk`  `gpg-agent.conf` `generate` ﺬﺧﺄﻳ .ﺮﻣﺍﻭﻷ﻿ﺍ

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

:ﺕﺍﺭﺎﻴﺨﻟﺍ ﻩﺬﻫ

- .rsa ﻮﻫ ﻲﺿﺍﺮﺘﻓﻻ﻿ﺍ ﺩﺍﺪﻋﻹ﻿ﺍ .ﺡﺎﺘﻔﻤﻟﺍ ﺔﻴﻣﺯﺭﺍﻮﺧ `--algo rsa|dsa` ﺭﺎﺘﺨ
- `rsa` `--bits` يختار حجم المفتاح. يقبل RSA `1024` و`2048` و`3072` و`4096`، مع `4096` كإعداد افتراضي. يقبل DSA `1024` و`2048` و`3072`، مع `2048` كإعداد افتراضي؛ لا يمكن لـ gpg إنشاء مفاتيح DSA أكبر، لذلك يتم رفض `4096` قبل تشغيل gpg.
- `--expire` takes `0`                                             ـﺑ ﻉﻮﺒﺘﻣ ﻢﻗﺭ ،ءﺎﻬﺘﻧﺍ ﻥﻭﺩ ﻡﺍﺪﺨﺘﺳﻼ﻿ﻟ`d`, `w`, `m` or `y`                                                                          ﻞﺜﻣ)`2y`                                                         ISO ﺔﻐﻴﺼﺑ ﺦﻳﺭﺎﺗ ﻭﺃ ,(`YYYY-MM-DD`                                            .ﺎًﻴﻘﻴﻘﺣ ﺎًﺨﻳﺭﺎﺗ ﻥﻮﻜﺗ ﻥﺃ ﺐﺠﻳ ﻲﺘﻟﺍﻭ ،
- `--passphrase-stdin`.ﻍﺭﺎﻔﻟﺍ ﺮﻄﺴﻟﺍ ﺾﻓﺭ ﻢﺘﻳ .ﻢﻜﺤﺘﻟﺍ ﺰﻛﺮﻣ ﺎﻬﻣﺪﺨﺘﺴﻳ .ﻲﺳﺎﻴﻘﻟﺍ ﻝﺎﺧﺩﻹ﻿ﺍ ﻦﻣ ﻝﻭﻷ﻿ﺍ ﺮﻄﺴﻟﺍ ﻦﻣ ﺭ
- `--no-passphrase --yes` ﻦﻴﻨﺛﻻ﻿ﺍ ﺭﻭﺮﻤﻟﺍ ﺓﺭﺎﺒﻋ ﻲﻌﺿﻭ ﺞﻣﺩ ﻦﻜﻤﻳ ﻻ﻿ .ﻲﻤﺤﻣ ﺮﻴﻏ ﺎًﺣﺎﺘﻔﻣ ﺊﺸﻨﻳ.

DSA.

                                                :ﺮﻣﺃ ﻞﻛ ﻰﻠﻋ ﻖﺒﻄﻨﺗ ﻲﺘﻟﺍ ﺪﻋﺍﻮﻘﻟﺍ

- لا يتم تمرير عبارات المرور مطلقًا كوسائط أوامر أو كتابتها في سجل أو إظهارها في مركز التحكم. باستخدام elg `rsa` `elg` `--passphrase-stdin`، تنتقل عبارة المرور إلى gpg في واصف الملف 0 من الأنبوب. بدون هذا الخيار، يسأل gpg نافذة الإدخال، والتي يفتحها `gpg-agent`.
- `--no-passphrase`                                  ﻢﻟ ﺎﻣ ﻪﻀﻓﺭ ﻢﺘﻳ .ﺔﻳﺎﻤﺣ ﻥﻭﺩ ﺹﺎﺨﻟﺍ ﺡﺎﺘﻔﻤﻟﺍ ﻥﺰﺨﻳ`--yes`                                                              .ﺎًﻀﻳﺃ ﻩﺅﺎﻄﻋﺇ ﻢﺘﻳ
- `import`ﻝﻼ﻿ﺧ ﻦﻣ ﻻ﻿ﺇ ﺢﻴﺗﺎﻔﻤﻟﺍ ﺔﻘﻠﺣ ﺔﺻﺎﺨﻟﺍ ﺢﻴﺗﺎﻔﻤﻟﺍ ﺭﺩﺎﻐﺗ ﻻ﻿ .ﺔﻴﺋﺎﻨﺛ ﻭﺃ ASCII ﺔﻐﻴﺼﺑ ﺖﻧﺎﻛ ءﺍ`export-private`                                                                  ﺝﺎﺘﺤﻳ ﻱﺬﻟﺍ ،`--yes`                                                                   ﻊﺿﻮﻟﺍ ﺐﺘﻜﻳﻭ`600`; `import-private`                                                            .ﻞﺧﺍﺪﻟﺍ ﻰﻟﺇ ﻢﻫﺪﻴﻌﻳ
-
-  --no-tty  --yes  keyserver send  edit revoke  edit sign  delete  `export-private`  `delete`  `edit sign`  `edit revoke`  `keyserver send`  `--yes`  `--no-tty` `generate --passphrase-stdin`.
-

 makes gpg-agent use

. ويكتب هذا الخط بين

 and

 markers, keeps the rest of

، ويحفظ الملف السابق باسم

. When the block already names

، يتم ترك الملف وgpg-agent كما هما. يرفض الأمر التشغيل متى

 already sets

 خارج تلك الكتلة، بحيث لا تتعارض القيمتان أبدًا.
- .ﺡﺎﺘﻔﻣ ءﺎﺸﻧﺇ ﻢﺘﻳ ﺎﻣﺪﻨﻋ ﻂﻘﻓ ﺕﺎﻨﻳﻮﻜﺘﻟﺍ ﺮﻴﻐﺘﺗ . pinentry-program  gpg-agent.conf  pinentry-gtk  gpg-agent.conf.bak  gpg-agent.conf  # END argvus-managed pinentry  # BEGIN argvus-managed pinentry  pinentry-gtk  `generate`  `pinentry-gtk`  `# BEGIN argvus-managed pinentry`  `# END argvus-managed pinentry`  `gpg-agent.conf`  `gpg-agent.conf.bak`  `pinentry-gtk`  `gpg-agent.conf`  `pinentry-program` `~/.gnupg` ﻰﻟﺇ ﺍًﺪﺑﺃ ﺐﺘﻜﻳ ﻻ﻿
- `GNUPGHOME` ﻝﺪﺒﺘﺴﻳ `~/.gnupg`، ﺭﺎﺒﺘﺧﻼ﻿ﻟ ﺪﻴﻔﻣ ﻮﻫﻭ.

`gnupg` and `pinentry`         ﻲﻫ ﺭﻭﺮﻤﻟﺍ ﺓﺭﺎﺒﻋ ﺓﺬﻓﺎﻧﻭ ،gpg ﻰﻟﺇ ﺝﺎﺘﺤﺗ ﺡﺎﺘﻔﻤﻟﺍ ﺮﻣﺍﻭﺃ :ﺔﻣﺯﻼ﻿ﻟﺍ ﺕﺎﺒﻠﻄﺘﻤﻟﺍ`pinentry-gtk`.

| العَرَض | السبب والإصلاح |
| --- | --- |
| `generate`                                              ﻖﻘﺤﺗ | ﺭﻭﺮﻤﻟﺍ ﺓﺭﺎﺒﻋ ﺓﺬﻓﺎﻧ ﺢﺘﻔﻳ ﻻ﻿`argvus gpg status`. `pinentry-gtk`                                               ﺔﺴﻠﺠﻟﺍ ﻒﺸﻜﺗ ﻥﺃ ﺐﺠﻳﻭ ،ﻪﺘﻴﺒﺜﺗ ﺐﺠﻳ`WAYLAND_DISPLAY` or `DISPLAY`. |
| `generate`                                                                       ﻥﺃ ﺮﻛﺬﻳ`pinentry-gtk`                                                          ﺖﻴﺒﺜﺘﺑ ﻢﻗ | ﺖﺒﺜﻣ ﺮﻴﻏ`pinentry` package. |
| `generate` reports a `pinentry-program`                                      ﻦﻣ ﺮﻄﺴﻟﺍ ﺍﺬﻫ ﻑﺬﺣﺍ | ARGVUS ﺔﻠﺘﻛ ﺝﺭﺎﺧ ﺮﻄﺳ`~/.gnupg/gpg-agent.conf`                                               | .ﻯﺮﺧﺃ ﺓﺮﻣ ﺮﻣﻷ﻿ﺍ ﻞﻴﻐﺸﺘﺑ ﻢﻗ ﻢﺛ ،
| `generate`| .ﺖﺑ 3072 ﺪﻨﻋ DSA ﻒﻗﻮﺘﺗ :ﺔﻴﻣﺯﺭﺍﻮﺨﻠﻟ ﻢﺠﺤﻟﺍ ﻦﻣ ﻖﻘﺤﺗ | ﻡﻮﻋﺪﻣ ﺮﻴﻏ ﺡﺎﺘﻔﻤﻟﺍ ﻢﺠﺣ ﻥﺄﺑ
| `generate`ﻡﺍﺪﺨﺘﺳﺎﺑ ﻲﻋﺮﻔﻟﺍ ﺡﺎﺘﻔﻤﻟﺍ ﻒﺿﺃ .ﺡﺎﺘﻔﻤﻟﺍ ءﺎﺸﻧﺇ ﻢﺗ | ﻪﺘﻓﺎﺿﺇ ﻢﺘﻳ ﻢﻟ ﻲﻋﺮﻔﻟﺍ ﺮﻴﻔﺸﺘﻟﺍ ﺡ`gpg --quick-add-key FINGERPRINT cv25519 encr 2y`                                                          ﻊﻣ ﺡﺎﺘﻔﻤﻟﺍ ﻑﺬﺣﺍ ﻭﺃ ،`gpg --delete-secret-and-public-key`                                                     | .ﻯﺮﺧﺃ ﺓﺮﻣ ﻩﺪﻴﻟﻮﺗ ﺓﺩﺎﻋﺇﻭ
| `import` ﻡﺍﺪﺨﺘﺳﺎﺑ ﺮﺧﻵ﻿ﺍ ﺯﺎﻬﺠﻟﺍ ﻰﻠﻋ ﻂﻘﻓ ﻡﺎﻌﻟﺍ ﺡﺎﺘﻔﻤﻟﺍ ﺮﻳﺪﺼﺘﺑ ﻢﻗ .ﺹﺎﺧ ﺡﺎﺘﻔﻣ ﻰﻠﻋ ﻒﻠﻤﻟﺍ ﻱﻮﺘ`argvus gpg export-public`. |
| `list`                                              ﻲﻓ ﺢﻴﺗﺎﻔﻤﻟﺍ ﺔﻘﻠﺣ | ﺢﻴﺗﺎﻔﻣ ﻻ﻿ ﺽﺮﻌﻳ`GNUPGHOME` (or `~/.gnupg`                                                             ﻞﻴﻐﺸﺘﺑ ﻢﻗ .ﻍﺭﺎﻓ (`argvus gpg generate`                                                                | .ﺡﺎﺘﻔﻣ ءﺎﺸﻧﻹ﻿

##                                                    (`SUPER + ALT + N`) ﺕﺎﻔﻄﺘﻘﻣ

**ARGVUS المقتطفات** · GTK 4 / Wayland · `↑` `↓` `Enter` `Esc`

`SUPER + ALT + N` ﺔﻈﻓﺎﺤﻟﺍ ﺮﺒﻋ ﺭﻭﺮﻤﻟﺍ ﻦﻣ ًﻻ﻿ﺪﺑ ،ﺮﺷﺆﻤﻟﺍ ﺪﻨﻋ ،ﺔﻄﺸﻨﻟﺍ ﺓﺬﻓﺎﻨﻟﺍ ﻲﻓ ﺩﺪﺤ

### الإعداد

                                                          :ﻪّﺼﻧﻭ ﻢﺳﺎﺑ ﺎًﻌﻄﻘﻣ ﻒﺿﺃ

```sh
argvus snippets add "email" "you@example.com"
```

                                                        :ﻪﻨﻳﺰﺨﺗ ﻢﺗ ﻪﻧﺃ ﻦﻣ ﻖﻘﺤﺗ

```sh
argvus snippets list
```

                                                     ﻲﻓ ﺕﺎﻔﻄﺘﻘﻤﻟﺎﺑ ﻅﺎﻔﺘﺣﻻ﻿ﺍ ﻢﺘﻳ`snippets`                                                                        ﻦﻣ ﻢﺴﻗ`argvus config`, as `{name, content}`                                                     ﻊﻣ ﺎﻬﺗءﺍﺮﻗ ﻚﻨﻜﻤﻳ .ﻞﺧﺍﺪﻤﻟﺍ`argvus config get /snippets/items`.

### استخدم

1.                         .ﺺﻨﻟﺍ ﻞﺒﻘﺘﺴﻳ ﻥﺃ ﺐﺠﻳ ﻱﺬﻟﺍ ﻖﻴﺒﻄﺘﻟﺍ ﻲﻓ ﺺﻨﻟﺍ ﻞﻘﺣ ﻞﺧﺍﺩ ﺮﻘﻧﺍ
2. اضغط على `SUPER + ALT + N`.
3.          .ﺮﺷﺆﻤﻟﺍ ﺚﻴﺣ ﺺﻨﻟﺍ ﺐﺘﻜُﻳ .`Enter` ﻰﻠﻋ ﻂﻐﺿﺍﻭ ﻢﺳﻻ﻿ﺎﺑ ﻒﻄﺘﻘﻤﻟﺍ ﺮﺘﺧﺍ

### الأوامر

```sh
argvus snippets add "NAME" "CONTENT"   # adds a snippet, or replaces the one with the same name
argvus snippets remove NAME            # removes a snippet
argvus snippets list                   # prints index and name, one per line
argvus snippets open NAME              # types a snippet by name
argvus snippets open 2                 # types the snippet at position 2 of `list`
argvus snippets                        # opens the picker (same as the shortcut)
argvus snippets --help                 # shows the options and an example
```

### القواعد

- .ﻩﺍﻮﺘﺤﻣ ﻝﺪﺒﺘﺴﻳ ﺩﻮﺟﻮﻣ ﻢﺳﺎﺑ ﻒﻄﺘﻘﻣ ﺔﻓﺎﺿﺇ .ﻑﺮﺣﻷ﻿ﺍ ﺔﻟﺎﺤﻟ ﺔﺳﺎﺴﺣﻭ ﺓﺪﻳ
-   .ﺩﻮﺟﻮﻣ ﺮﻴﻏ ﻪﻧﺃ ﻰﻠﻋ ﻍﺭﺎﻔﻟﺍ ﻒﻄﺘﻘﻤﻟﺍ ﻦﻋ ﻍﻼ﻿ﺑﻹ﻿ﺍ ﻢﺘﻳ :ﺎًﻏﺭﺎﻓ ﻯﻮﺘﺤﻤﻟﺍ ﻥﻮﻜﻳ ﻥﺃ ﻦﻜﻤﻳ ﻻ﻿
- `open`    ﻞﺜﻣ ،ﻑﻭﺮﺣ ﻰﻠﻋ ﻱﻮﺘﺤﺗ ءﺎﻤﺳﺃ ﻡﺪﺨﺘﺳﺍ .ﻊﻗﻮﻤﻛ ﻡﺎﻗﺭﺃ ﻦﻣ ﻂﻘﻓ ﻥَّﻮﻜﻤﻟﺍ ﻢﺳﻻ﻿ﺍ ﻊﻣ ﻞﻣﺎﻌﺘﻳ`code2`                                                               .ﺽﻮﻤﻐﻟﺍ ﺐﻨﺠﺘﻟ ،
-

### استكشاف الأخطاء وإصلاحها

| العَرَض | السبب والإصلاح |
| --- | --- |
| إشعار "عدم وجود قصاصات" عند الضغط على الاختصار | لم تتم إضافة أي مقتطف بعد. قم بتشغيل `list` `argvus snippets add` أولاً. |
| `open`             ﻊﻣ ﻥﺭﺎﻗ .ﻂﺒﻀﻟﺎﺑ ﻖﺑﺎﻄﻳ ﻻ﻿ ﻢﺳﻻ﻿ﺍ | ﻪﻴﻠﻋ ﺭﻮﺜﻌﻟﺍ ﻢﺘﻳ ﻢﻟ ﻒﻄﺘﻘﻤﻟﺍ ﻥﺃ ﻎﻠﺒﻳ`argvus snippets list`. |
| .ﻲﻠﺻﺃ Wayland ﻖﻴﺒﻄﺗ ﻊﻣ ﺏﺮﺟ .ﻝﺎﺧﺩﻹ﻿ﺍ ﻦﻣ ﻉﻮﻨﻟﺍ ﺍﺬﻫ ﻞﻫﺎﺠﺘﻳ ﺪﻗ ﻱﺬﻟﺍﻭ ،XWayland ﺖﺤ

.(`wtype` argvus  jq  ﺮﻣﺃ)  `jq`  `argvus` `argvus config` ﻭ

`wtype`.ﻊﻄﻘﻤﻟﺍ ﻰﻠﻋ ﺭﻮﺜﻌﻟﺍ ﻢﺗ ﻮﻟ ﻰﺘﺣ ﻙﺎﻨﻫ ﺺﻨﻟﺍ ﺮﻬﻈﻳ ﻻ﻿ ﺪﻗ ﺍﺬﻟ ،ﺙﺍﺪﺣﻷ﻿ﺍ ﻩﺬﻫ ﻞﻫﺎﺠﺘﺗ XWayla

##                                                        (`SUPER + ALT + G`) ﺖﻴﺟ

`SUPER + ALT + G`                                                     ﻞﺜﻣ ﻉﻭﺮﺸﻤﻟﺍ ﺩﺪﺤﻣ ﺲﻔﻧ ﺢﺘﻔﻳ`SUPER + O`                                                           ﺢﺘﻔﻳ ﻉﻭﺮﺸﻣ ﺭﺎﻴﺘﺧﺍ .`lazygit` (or `gitui`. ًﻻ﻿ﻭﺃ ﻉﻭﺮﺸﻤﻟﺍ ﺭﺎﻴﺘﺧﻻ﻿ ﺔﻠﺼﻔﻨﻣ ﺓﻮﻄﺧ ﺪﺟﻮﻳ ﻻ﻿ .ﺔﻴﻟﺎﺤﻟﺍ ﻞﻤﻌﻟﺍ ﺔﺣﺎﺴﻣ ﻰﻠﻋ ﺓﺪﻳﺪﺟ ARGVUS ﺔ

### الإعداد

                   :ﺔﻣﺰﺤﻟﺍ ﻩﺬﻬﻟ ﺔﻳﺭﺎﻴﺘﺧﺍ ﺕﺍﺩﺎﻤﺘﻋﺍ ﺎﻤﻫﻼ﻿ﻛ .ﻦﻴﺗﺍﺩﻷ﻿ﺍ ﺪﺣﺃ ﺖﻴﺒﺜﺘﺑ ﻢﻗ

```sh
sudo pacman -S lazygit   # or: sudo pacman -S gitui
```

### استخدم

1. اضغط على `SUPER + ALT + G`.
2. .ﺎًﺌﻴﺷ ﺢﺘﻔﻳ ﻻ﻿ ءﺎﻐﻟﻹ﻿ﺍ . ءﺎﻐﻟﻺ﻿ﻟ `Esc` ﻰﻠﻋ ﻂﻐﺿﺍ ﻭﺃ ،ﺔﻤﺋﺎﻘﻟﺍ ﻦﻣ ﺎًﻋﻭﺮﺸﻣ ﺮ
3.                      .ﺔﻴﺼﻨﻟﺍ ﻡﺪﺨﺘﺴﻤﻟﺍ ﺔﻬﺟﺍﻭ ﺃﺪﺒﻳﻭ ﻉﻭﺮﺸﻤﻟﺍ ﻞﻴﻟﺩ ﻲﻓ ﺔﻴﻓﺮﻄﻟﺍ ﺢﺘﻔﻳ

:ﺍًﺪﻠﺠﻣ ﺭّﺮﻣ ،ﺩﺪﺤﻤﻟﺍ ﻲﻄﺨﺘﻟ . ءﻲﺷ ﻱﺃ ﺢﺘﻔﻳ ﻻ﻿ﻭ ﺍًﺭﺎﻌﺷﺇ ﺽﺮﻌﻳ git ﻉﺩﻮﺘﺴﻣ ﺲﻴﻟ ﻱﺬﻟﺍ ﻉﻭﺮﺸﻤ

```sh
argvus git ~/Projects/api
```

###                                                                   ﺓﺍﺩﻷ﻿ﺍ ﺭﺎﻴﺘﺧﺍ

`argvus-git` uses `lazygit`                                                           ﻭ ،ﻪﺘﻴﺒﺜﺗ ﻢﺘﻳ ﺎﻣﺪﻨﻋ`gitui`                                                              ﻞﻴﻀﻔﺘﻟ .ﻚﻟﺫ ﻑﻼ﻿ﺨﺑ`gitui`, set `ARGVUS_GIT_TUI`                                                                         :ﺮﻣﻸ﻿ﻟ

```sh
ARGVUS_GIT_TUI=gitui argvus git
```

.ARGVUS ﻦﻳﻮﻜﺗ ﻲﻓ ﻪﻨﻳﺰﺨﺗ ﻢﺘﻳ ﻻ﻿ﻭ .ﺖﺒﻳﺮﻜﺴﻟﺍ ﻞّﻐﺸﻳ ﻱﺬﻟﺍ ﺮﻣﻷ﻿ﺍ ﺔﺌﻴﺑ ﻦﻣ ﺮﻴﻐﺘﻤﻟﺍ ﺓءﺍﺮﻗ

### استكشاف الأخطاء وإصلاحها

| العَرَض | السبب والإصلاح |
| --- | --- |
 ﻡﺍﺪﺨﺘﺳﺎﺑ ﻪﺤﻠﺻﺃ ﻭﺃ ﻪﻓﺬﺣﺍ .ﻪﻠﻴﻟﺩ ﻞﻘﻧ ﻢﺗ ﻭﺃ ،Git ﻉﺩﻮﺘﺴﻣ ﺲﻴﻟ ﺭﺎﺘﺨﻤﻟﺍ ﻉﻭﺮﺸﻤﻟﺍ | "G`argvus projects remove`. |
              ﻰﻠﻋ ﺓﺩﻮﺟﻮﻣ ﺕﺍﻭﺩﻷ﻿ﺍ ﻦﻣ ﻱﺃ ﻻ﻿ | "gitui ﻭﺃ lazygit ﺖﻴﺒﺜﺘﺑ ﻢﻗ" ﺭﺎﻌﺷﺇ |`PATH`                                                          | .ﺎﻫﺪﺣﺃ ﺖﻴﺒﺜﺘﺑ ﻢﻗ .
               ﻡﺪﺨﺘﺳﺍ .ﻉﻭﺮﺸﻣ ﻱﺃ ﺔﻓﺎﺿﺇ ﻢﺘﻳ ﻢﻟ | ﻊﻳﺭﺎﺸﻣ ﻱﺃ ﺽﺮﻌﻳ ﻻ﻿ ﺭﺎﻴﺘﺧﻻ﻿ﺍ ﺽﺭﺎﻋ |`argvus projects add`. |

## ARGVUS Emoji (`SUPER + .`)

`SUPER + .` → **ARGVUS Emoji** (`argvus emoji-picker`). ←↑↓→  Tab   / ابحث بالاسم أو بالكلمة المفتاحية   Enter إدراج   Ctrl+C نسخ   Ctrl+D المفضلة   Esc.

يبدأ على «الكل». للتبديل بين الفئات استخدم Tab، وللتنقل بين الرموز استخدم الأسهم.

## الحاسبة (`SUPER + C`)

يفتح الاختصار `SUPER + C` الحاسبة (`argvus calculator`).

## ﺕﺎﻴﻌﺒﺘﻟﺍﻭ ﻒﻴﻠﻐﺘﻟﺍ

The package

 is architecture-independent and installs:


Required dependencies:

,

,

,

,

,

,

,

,

,

,

,

,



## استكشاف الأخطاء وإصلاحها

| العَرَض | السبب والإصلاح |
| --- | --- |
| `SUPER + D`ﺎﻬﻟ ﻲﺘﻟﺍ ﺕﺎﻘﻴﺒﻄﺘﻟﺍ ﻂﻘﻓ .ﺐﺘﻜﻤﻟﺍ ﺢﻄﺳ ﻰﻠﻋ ﻝﺎﺧﺩﺇ ﺎﻬﻳﺪﻟ ﺲﻴﻟ ﺕﺎﻘﻴﺒﻄﺘﻟﺍ | ﺕﺎﻘﻴﺒﻄﺗ ﻱﺃ `.desktop`                                                              | .ﻒﻠﻤﻟﺍ ﺽﺮﻋ ﻢﺘﻳ
                                              ـﻟﺍ | ﺎًﻤﻳﺪﻗ ﺎًﻄﺧ ﻡﺪﺨﺘﺴﺗ ﻢﺋﺍﻮﻘﻟﺍ |`font:`        .ﻂﺨﻟﺍ ﺮﻴﻴﻐﺗ ﺪﻌﺑ ﺔﺴﻠﺠﻟﺍ ﻞﻴﻐﺸﺗ ﺪﻋﺃ .ﺔﺴﻠﺠﻟﺍ ءﺪﺑ ﺪﻨﻋ ﺮﻄﺴﻟﺍ ﺔﺑﺎﺘﻛ ﺓﺩﺎﻋﺇ ﻢﺘﻳ
| `SUPER + O`ﻞﻴﻐﺸﺘﺑ ﻢﻗ .ﺓﺩﻮﺟﻮﻣ ﺪﻌﺗ ﻢﻟ ﻞﺋﻻ﻿ﺪﻟﺍ ﻥﺃ ﻭﺃ ،ﺭﺎﺴﻤﻟﺍ ﻭﺃ ﺭﺬﺠﻟﺍ ﻦﻳﻮﻜﺗ ﻢﺘﻳ ﻢﻟ | ﻊﻳﺭﺎﺸﻣ ﻱ`argvus projects list`. |
| `SUPER + C` / `SUPER + .` | `argvus`, `wl-clipboard`, `wtype` |
| .ﺓﺮﺼﺘﺨﻤﻟﺍ ﻝﻭﺍﺪﺠﻟﺍ ﻢﺴﻗ ﻲﻓ ﺔﺤﺿﻮﻤﻟﺍ ﺕﺍﺭﺎﺴﻤﻟﺍ ﻦﻣ ﻖﻘﺤﺗ .ﺩﻮﺟﻮﻣ ﺮﻴﻏ ﺔﻐﻠﻟﺍﻭ ﻢﺳﻻ﻿ﺍ ﺍﺬﻬ
| `SUPER + H`                                 ﻦﻣ ﺔﻈﻓﺎﺤﻟﺍ ﻞﺠﺴﻣ ﻭﺃ ،ﻍﺭﺎﻓ ﺦﻳﺭﺎﺘﻟﺍ | ءﻲﺷ ﺮﻬﻈﻳ ﻻ﻿`argvus-session`                                                   | .ﺪﻌﺑ ءﻲﺷ ﻱﺃ ﻦﻳﺰﺨﺘﺑ ﻢﻘﻳ ﻢﻟ

##                                                             ﺔﻠﺼﻟﺍ ﺕﺍﺫ ﺕﺎﻧﻮﻜﻤﻟﺍ

| المكون | المسؤولية |
| --- | --- |
| `argvus-hyprland`                         | .ﻢﺋﺍﻮﻘﻠﻟ Hyprland ﺬﻓﺍﻮﻧ ﺪﻋﺍﻮﻗﻭ ﺕﺍﺭﺎﺼﺘﺧﻻ﻿ﺍ ﻦﻋ ﻦﻠﻌﻳ |
| `argvus` (`argvus config`                    | .ﻲﺿﺍﺮﺘﻓﻻ﻿ﺍ ﻞﻐﺸﻤﻟﺍ ﺕﺍﺩﺍﺪﻋﺇﻭ ،ﺕﺎﻔﻄﺘﻘﻤﻟﺍﻭ ،ﻊﻳﺭﺎﺸﻤﻟﺍ ﻥﺰﺨﻳ | (
| `argvus` (`argvus terminal`             ـﺑ ﺔﺻﺎﺨﻟﺍ ﺭﻭﺮﻤﻟﺍ ﺓﺭﺎﺒﻋ ﺕﺎﺒﻟﺎﻄﻣﻭ ﻉﻭﺮﺸﻤﻟﺍ ﺕﺎﻄﺤﻣﻭ SSH ﺕﺎﺴﻠﺟ ﺢﺘﻔﻳ | (`argvus keys`. |
| `argvus` (`argvus widget-telemetry`) | يقرأ المشروع النشط الذي كتبه `argvus projects`. |
| `argvus` (`argvus i18n`                    | .ﻞﻐﺸﻤﻟﺍ ﺕﺎﺘﺒﻳﺮﻜﺳ ﺎﻬﻣﺪﺨﺘﺴﺗ ﻲﺘﻟﺍ ﺔﻤﺟﺮﺘﻤﻟﺍ ﻞﺋﺎﺳﺮﻟﺍ ﺮﻓﻮﻳ | (
| `argvus` (`argvus control-center`) | يقوم بتحرير قائمة المشاريع من خلال `argvus projects`. |



`/launcher/show_icons`: `true` / `false`.

`/launcher/selected_category`: `""` (All), `applications`, `windows`, `settings`, `actions`, `projects`, `ssh`, `files`, `help`.

`/launcher/application_sort`: `recent` (الأحدث فتحًا، افتراضيًا) أو `alphabetical` (أبجديًا).

يتبع نص التطبيقات Applications Font في Control Center → Appearance → Desktop Style → Fonts. ترث تطبيقات GTK قيمة gtk-font-name مع الحفاظ على أحجام الأرقام والعناوين. يقرأ المشغّل apps_family المولّد ويتابع التغييرات.

**ARGVUS الحافظة** · `argvus clipboard` · `Super + H` · `↑` `↓` (التنقل) · `/` (بحث) · `Enter` (نسخ) · `Delete` (مسح السجل) · `Esc` (إغلاق)
