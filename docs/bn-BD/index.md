---
title: Application launcher
description: অ্যাপ্লিকেশন লঞ্চ করুন, প্রজেক্ট খুলুন, SSH হোস্ট এবং স্নিপেট ব্যবহার করুন, ইমোজি নির্বাচন করুন, হিসাব করুন, এবং ARGVUS Rofi মেনুর মাধ্যমে চিটশিট পড়ুন।
---

`argvus-launcher` রফি কনফিগারেশন, থিম এবং মেনুসমূহ সরবরাহ করে যা ARGVUS কী-বোর্ড থেকে কিছু খোলার জন্য ব্যবহার করে। এতে রয়েছে:

- অ্যাপ্লিকেশন লঞ্চার (`SUPER + D`);
- রফি কনফিগারেশন এবং থিমগুলি যা প্রতিটি ARGVUS রফি মেনু দ্বারা শেয়ার করা হয়;
- প্রজেক্ট সুইচার, এসএসএইচ পিকার এবং স্নিপেট পিকার (`argvus projects`, `argvus ssh`, `argvus snippets`);
- এসএসএইচ কী ম্যানেজার (`argvus keys`), যা কী জুটি তৈরি করে, তালিকাভুক্ত করে, লোড করে এবং মুছে ফেলে;
- জিপিজি কী ম্যানেজার (`argvus gpg`), যা কী তালিকাভুক্ত করে, তৈরি করে এবং রপ্তানি করে এবং gpg-এজেন্টের জন্য pinentry-gtk সেটআপ করে;
- ইমোজি পিকার, চিটশিট ভিউয়ার এবং ক্যালকুলেটর মেনু।

শর্টকাটগুলি `argvus-hyprland` দ্বারা ঘোষণা করা হয়েছে। এই প্যাকেজটি কমান্ড এবং তাদের পিছনের মেনুগুলি সরবরাহ করে।

## Shortcuts

| Shortcut | Action | Command | Section |
| --- | --- | --- | --- |
| `SUPER + D` | Application launcher | `argvus launcher` | Application launcher |
| `SUPER + O` | Project switcher | `argvus projects` | Project switcher |
| `SUPER + ALT + 1` to `9` | প্রকল্পটি সেই অবস্থানে খুলুন | `argvus projects open N` | প্রজেক্ট সুইচার |
| `SUPER + ALT + S` | SSH host picker | `argvus ssh` | SSH |
| `SUPER + ALT + N` | Snippet picker | `argvus snippets` | Snippets |
| `SUPER + ALT + G` | Project picker, then git TUI | `argvus git` | Git |
| `SUPER + .` | Emoji picker | `emoji-picker.sh` | Emoji picker |
| `SUPER + C` | Calculator | `rofi -show calc` | Calculator |
| `SUPER + SHIFT + /` | Hyprland cheatsheet | `cheatsheets.sh hypr` | Cheatsheets |
| `SUPER + CTRL + /` | Kitty cheatsheet | `cheatsheets.sh kitty` | Cheatsheets |

## অ্যাপ্লিকেশন লঞ্চার (`SUPER + D`)

`SUPER + D` চালায় `argvus launcher`, যা `drun` মোডে Rofi খুলে। এটি ডেস্কটপ এন্ট্রির সঙ্গে ইনস্টল করা গ্রাফিকাল অ্যাপ্লিকেশনগুলির তালিকা দেখায়, এবং নির্বাচিতটি `Enter` চাপলে শুরু হয়।

1. Press `SUPER + D`.
2. অ্যাপ্লিকেশনের নামের কিছু অংশ টাইপ করুন। তালিকাটি সাজানো হয় এবং ফিল্টারটি কেস উপেক্ষা করে।
3. অ্যাপ্লিকেশন শুরু করতে `Enter` চাপুন, অথবা মেনু বন্ধ করতে `Esc` চাপুন।

```sh
argvus launcher                  # opens the application menu
argvus launcher --config PATH    # uses another Rofi configuration file
```

যেকোনো অন্য আর্গুমেন্ট `rofi`-এ পাঠানো হয়। `--config` কোনো মান ছাড়া একটি ত্রুটির সাথে বন্ধ হয়ে যায়।

যখন ডিফল্ট লঞ্চার rofi হয়, যা ডিফল্ট, তখন Hyprland `argvus launcher --config <Rofi configuration>` চালায়। যদি ডিফল্ট  `rofi` `launcher` ডিফল্ট অ্যাপ্লিকেশনে অন্য প্রোগ্রামে সেট করা হয়, Hyprland এর পরিবর্তে `<program> --show drun` চালায়। এটি কন্ট্রোল সেন্টারের ডিফল্ট অ্যাপ্লিকেশনে সেট করুন, যা মানটি `argvus-config` তে সংরক্ষণ করে।

শুধুমাত্র ডেস্কটপ এন্ট্রি সহ অ্যাপ্লিকেশনগুলি তালিকায় প্রদর্শিত হয়। এমন কোনো অ্যাপ্লিকেশন যা কোনো `.desktop` ফাইল ইনস্টল করে না এখানে খুঁজে পাওয়া যাবে না।

## Rofi কনফিগারেশন এবং থিম

প্যাকেজটি Rofi কনফিগারেশনটি `/usr/share/argvus/launcher/config/` এর অধীনে ইনস্টল করে:

| File | Role |
| --- | --- |
| `config.rasi` | প্রতিটি ARGVUS মেনু দ্বারা ব্যবহৃত এন্ট্রি পয়েন্ট। Rofi সেট করে `configuration` (ফন্ট, কোন আইকন নেই, সাজানো তালিকা, কেস-অসংবেদনশীল মিল) এবং আমদানি`theme.rasi`. |
| `theme.rasi`| উইন্ডো, ইনপুট বার এবং তালিকার রঙ এবং বিন্যাস। একটি থিম এবং মোড ফাইল আমদানি করে। |
| `mode.rasi` | মোড ওভাররাইড। প্যাকেজ করা ফাইলে কোনো ওভাররাইড নেই এবং এটি ডার্ক মোড বজায় রাখে। |
| `themes/<family>/theme.rasi` | Palette of a theme family, for example `argvus-dark` or `tokyo-night`. |
| `themes/<family>-spaced/theme.rasi` | Spaced variant of the same family. |

প্যাকেজটি ২২টি পরিবার সরবরাহ করে, এবং প্রতিটির একটি `-spaced` ভ্যারিয়ান্ট রয়েছে। প্যাকেজকৃত `theme.rasi` `argvus-dark` আমদানি করে।

### যেখানে সক্রিয় কনফিগারেশন থাকে

ARGVUS প্রতিটি Rofi ফাইলকে `paths_config` মাধ্যমে সমাধান করে। ব্যবহারকারীর ওভাররাইড, ব্যবহারকারীর কপি, লিগ্যাসি অবস্থান এবং তৈরি করা ট্রির মধ্যে প্রথম যে বিদ্যমান ফাইলটি পাওয়া যায় তা বিজয়ী হয়; অন্যথায় `/usr/share/argvus/launcher/config/` এর অধীনে প্যাকেজড ফাইলটি ব্যবহার করা হয়। একটি ফাইলের ব্যবহারকারীর কপি হল `$XDG_CONFIG_HOME/argvus/data/rofi/<file>`: `launcher/config/` প্রিফিক্সটি `rofi/` এর অধীনে সংরক্ষিত হয়।

ARGVUS প্রথমবার যখন একটি ARGVUS স্ক্রিপ্ট সেই ফাইলটি পরিবর্তন করে তখন একটি ব্যবহারকারী কপি তৈরি করে; `argvus-appearance` থিম, আকর্ষণ এবং মোড পরিবর্তনের জন্য এটি করে। যেসব ফাইল কখনও পরিবর্তন করা হয়নি সেগুলি প্যাকেজ থেকে পড়া হয়, এবং একটি ব্যবহারকারী কপি প্যাকেজ করা ফাইলের তুলনায় প্রাধান্য পায়।

যখন `argvus-session` সেশন শুরুতে ফন্ট প্রয়োগ করে, এটি ARGVUS ফন্ট সেটিং থেকে config.rasi এর `font:` লাইনটি পুনর্লিখন করে। সেই সম্পাদনা কেবল ব্যবহারকারীর কপিতে পৌঁছায়। কপি না থাকা পর্যন্ত, প্যাকেজকৃত ফাইলটি পাওয়া যায় এবং ব্যবহারকারীরা এতে লিখতে পারে না, তাই প্রথম উপস্থিতি পরিবর্তন কপি তৈরি করার পরেই ফন্ট পরিবর্তন কার্যকর হয়।

### থিম পরিবর্তন করা

 `config.rasi` `argvus-appearance` থিম পরিবর্তনগুলি পরিচালনা করে। থিম পরিবর্তিত হলে, এটি ব্যবহারকারীর কপিগুলি পুনঃলিখন করে যাতে `config.rasi` নতুন `theme.rasi` নির্দেশ করে, এবং `theme.rasi` থিম বিল্ডের লঞ্চার প্যালেট (`~/.config/argvus/data/generated/theme/current/launcher/theme.rasi`) আমদানি করে, যা সক্রিয় ফ্যামিলি, লেআউট এবং হাইলাইট রঙ ধারণ করে। থিম বিল্ড ছাড়া এটি ফ্যামিলি কপি আমদানি করে, এবং স্পেসড লেআউট সক্রিয় ফ্যামিলির `-spaced` ভেরিয়েন্ট নির্বাচন করে। থিম নির্বাচক যেমন থিম মেনু এবং লেআউট মেনু একই `config.rasi` পড়ে, তাই তারা সক্রিয় শৈলীও ব্যবহার করে।

`/usr/share/argvus/launcher/` এর অধীনে ফাইলগুলি সম্পাদনা করবেন না; প্যাকেজ আপগ্রেডের সময় সেগুলি প্রতিস্থাপিত হয়। ব্যবহারকারীর কপিতে, `$XDG_CONFIG_HOME/argvus/data/rofi/` এর অধীনে পরিবর্তন করুন।

## প্রকল্প সুইচার (`SUPER + O`)

`argvus projects` (`SUPER + O`) আপনি যে প্রকল্পগুলো যোগ করেছেন সেগুলো তালিকাভুক্ত করে এবং নির্বাচিতটিকে তার নিজস্ব Hyprland কর্মক্ষেত্রে খুলে, যার ডিরেক্টরিতে একটি `argvus terminal` থাকে। যদি প্রকল্পের কর্মক্ষেত্র ইতিমধ্যেই বিদ্যমান থাকে, সুইচার কেবল এটিকে ফোকাস করে।

কীবোর্ড-শুধু অ্যাক্সেসের জন্য, `SUPER + ALT + 1` থেকে `SUPER + ALT + 9` পর্যন্ত সেই পজিশনে প্রজেক্টটি তালিকায় খুলুন, মেনু ব্যবহার না করে। পজিশনগুলি মেনুতে প্রদর্শিত সংখ্যাগুলি। এগুলি তালিকার ক্রম অনুসরণ করে, তাই একটি প্রজেক্ট যোগ বা মুছে ফেলা এগুলিকে পরিবর্তন করতে পারে। `argvus projects open <number or directory name>` টার্মিনাল থেকে একই কাজ করে, এবং ব্যর্থতা একটি নোটিফিকেশন হিসেবে দেখানো হয়।

কার্যকর প্রকল্পের তালিকাটি ৯-এর মধ্যে সীমাবদ্ধ, কারণ এটিই `SUPER + ALT + 1..9` ঠিক করতে পারে। `argvus projects add` (এবং নিয়ন্ত্রণ কেন্দ্রের প্রকল্প পৃষ্ঠা, যা এটিকে কল করে) এমন কোনো প্রকল্প বা মূল যোগ করতে অস্বীকার করে যা মোট সংখ্যা ৯-এর বেশি করবে, এবং পরিবর্তে ত্রুটির রিপোর্ট করে।

একটি প্রকল্প `projects` অংশের `argvus-config`-এর দুটি স্থান থেকে আসে:

- `paths`: ব্যক্তিগত প্রকল্পের ডিরেক্টরিগুলি।
- `roots`: সেই ডিরেক্টরিগুলি যাদের সরাসরি সাবডিরেক্টরি প্রকল্প। বিদ্যমান নয় এমন একটি রুট উপেক্ষিত হয়।

ডিফল্টভাবে কোনো রুট বা পথ কনফিগার করা নেই; কমপক্ষে একটি যোগ করুন, তারপরে `SUPER + O` এর কিছু তালিকাভুক্ত করতে।

এগুলি একটি টার্মিনাল থেকে পরিচালনা করুন:

```sh
argvus projects add ~/Work/api          # one project
argvus projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus projects remove ~/Work/api       # removes it from paths and roots
argvus projects list                    # prints the roots and paths
```

`argvus projects pick` একই তালিকা দেখায় এবং এটি খুলার পরিবর্তে নির্বাচিত পথটি মুদ্রণ করে। অন্যান্য সরঞ্জাম এটি ব্যবহার করতে পারে, যেমন `argvus git` করে। বাতিল করলে কিছুই মুদ্রিত হয় না।

যদি কোনো মূল বা পথ না থাকে, `SUPER + O` জানায় যে কোনো প্রকল্প পাওয়া যায়নি। একটি ঐচ্ছিক সম্পাদক কমান্ড, `/projects/editor`, যখন ওয়ার্কস্পেস তৈরি করা হয় তখন একই ওয়ার্কস্পেসে শুরু হয়।

এন্ট্রিগুলি কার্যকর কনফিগারেশন থেকে পড়া হয়; লঞ্চার কোনো কপি রাখে না।

একটি প্রকল্প খুললেও তার পথকে সেশনের সক্রিয় প্রকল্প হিসেবে রেকর্ড করে, যা ডেভ ড্যাশবোর্ড টেলিমেট্রি ব্লক (`argvus widget-telemetry`) পড়ে সেই প্রকল্পটির গিট, শুননো পোর্ট এবং কন্টেইনার রিপোর্ট করতে।

## এসএসএইচ (`SUPER + ALT + S`)

`SUPER + ALT + S` `~/.ssh/config`-এ সংজ্ঞায়িত হোস্টগুলির সাথে একটি পিকার খুলে। নির্বাচিত হোস্টটি বর্তমান ওয়ার্কস্পেসে `ssh <host>` চালানো একটি নতুন ARGVUS টার্মিনালে খোলে।

### Setup

~/.ssh/config-এ প্রতিটি সার্ভারের জন্য একটি `Host` এন্ট্রি যোগ করুন:

```ini
Host myhost
    HostName myhost.local
    User boss
    IdentityFile ~/.ssh/myhost
    IdentitiesOnly yes
```

প্রথমে নিশ্চিত করুন যে  `~/.ssh/config` `ssh myhost` একটি সাধারণ টার্মিনালে কাজ করে। লঞ্চারটি শুধুমাত্র `ssh` চালায়; প্রমাণীকরণ, কী এবং হোস্ট যাচাই OpenSSH দ্বারা পরিচালিত হয়।

### Use

1. Press `SUPER + ALT + S`.
2. হোস্টের নামের কিছু অংশ টাইপ করুন, অথবা তীর চিহ্ন ব্যবহার করুন।
3. `Enter` চাপুন। টার্মিনাল খুলে যায় এবং `ssh <host>` চালায়।

যখন সেশন শেষ হয়, উইন্ডোটি খোলা থাকে এবং এক্সিট স্ট্যাটাস দেখায়, উদাহরণস্বরূপ `ssh exited with status 0. Press Enter to close.` বন্ধ করার জন্য `Enter` চাপুন। এটি GitHub, GitLab এবং Gitea-এর মতো ফোরজগুলির জন্য গুরুত্বপূর্ণ: তারা আপনাকে প্রমাণীকরণ করে এবং সাথে সাথেই সংযোগ বন্ধ করে দেয় কারণ তারা শেল প্রদান করে না। উইন্ডোটি তাদের বার্তা স্ক্রিনে রাখে, হারিয়ে যায় না।

### Rules

- ওয়াইল্ডকার্ড এন্ট্রিগুলি (`Host *`, `Host *.internal`) ম্যাচ ব্লক, লক্ষ্য নয়, এবং কখনও তালিকাভুক্ত হয় না।
- একটি `Host` লাইনের প্রতিটি অ্যালিয়াস আলাদাভাবে তালিকাভুক্ত করা হয় (`Host a b` তে `a` এবং `b` তালিকাভুক্ত রয়েছে)। ডুপ্লিকেটগুলিকে মুছে ফেলা হয়।
- `Include` দিয়ে লোড করা ফাইলে শুধুমাত্র সংজ্ঞায়িত হোস্টগুলি তালিকাভুক্ত করা হয় না; পিকার শুধুমাত্র মূল ফাইলটি পড়ে।
- শুধুমাত্র অক্ষর, সংখ্যা, `.`, `-` এবং `_` দিয়ে তৈরি ছদ্মনামগুলি চালু করা হয়। অন্য কোনো নাম নোটিফিকেশনের সাথে প্রত্যাখ্যাত হয়।
- কনফিগে উইন্ডোজ লাইন সমাপ্তি (CRLF) গ্রহণযোগ্য।
- `ARGVUS_SSH_CONFIG` কনফিগারেশন ফাইলের পথ প্রতিস্থাপন করে, যা পরীক্ষা করার জন্য উপকারী।

### Commands

```sh
argvus ssh list          # prints the configured hosts, one per line
argvus ssh open myhost   # opens a specific host without the picker
```

### Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| বিজ্ঞপ্তি "~/.ssh/config-এ কোনো হোস্ট পাওয়া যায়নি" | ফাইলটি অনুপস্থিত বা এতে কিছু নেই`Host`লাইন। চালাও`argvus ssh list`পরীক্ষা করতে। |
| পিকার থেকে একটি হোস্ট অনুপস্থিত | এটি একটি ওয়াইল্ডকার্ড, যা আসে একটি `Include`ফাইল, অথবা অনুমোদিত সেটের বাইরে অক্ষর রয়েছে। এটি একটি সাধারণ ছদ্মনামে মূল ফাইলে রাখুন। |
| উইন্ডোটি সঙ্গে সঙ্গে একটি ত্রুটি স্থিতি দেখায় | চালান `ssh <host>`সাধারণ টার্মিনালে সম্পূর্ণ বার্তা দেখতে (অপ্রাপ্য হোস্ট, ভুল কি, ইত্যাদি)। |
| জানালাটি দেখায়`message.ssh_session_ended`পাঠ্য এর পরিবর্তে | ইনস্টল করা হয়েছে`argvus`প্যাকেজটি এই সংস্করণের থেকে পুরনো। আপডেট করুন`argvus`. |

`openssh` এবং `argvus` (`argvus terminal` কমান্ড) প্রয়োজন।

## SSH কীস (`argvus keys`)

`argvus keys` `~/.ssh`-এ কী জোড়াগুলি এবং ssh-agent দ্বারা রাখা কীগুলির ব্যবস্থাপনা করে। এটির কোনো শর্টকাট নেই। কন্ট্রোল সেন্টারের (অ্যাপ্লিকেশন) **SSH কী** পৃষ্ঠা একই কমান্ডগুলি ব্যবহার করে।

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

প্রতিটি কমান্ডে প্রযোজ্য নিয়ম:

- একটি কী নাম `~/.ssh` এর অধীনে একটি ফাইল নাম হয়ে যায়, তাই এতে শুধুমাত্র অক্ষর, সংখ্যা, ডট, হাইফেন এবং আন্ডারস্কোর থাকতে পারে। এটি একটি ডট দিয়ে শুরু হতে পারে না বা `.pub` দিয়ে শেষ হতে পারে না। একটি বিদ্যমান জোড়া কখনও ওভাররাইট করা হয় না।
- শুধুমাত্র একটি পাবলিক ফাইলের (`NAME.pub`) সাথে থাকা জোড়াগুলি তালিকাভুক্ত করা হয়, এবং শুধুমাত্র সেগুলিই লোড, আনলোড বা মুছে ফেলা যেতে পারে।
- পাসফ্রেজ কখনই কমান্ড আর্গুমেন্ট হিসেবে পাঠানো হয় না, লগে লেখা হয় না বা কন্ট্রোল সেন্টারে দেখানো হয় না। `load` এবং `generate --passphrase` একটি ARGVUS টার্মিনাল খুলে, এবং OpenSSH সেই টার্মিনাল থেকে সিক্রেট পড়ে।
- `list` রিপোর্ট করে `unknown` `loaded` কলামে যখন এজেন্ট পৌঁছানো যায় না। এটি কখনই অনুমান করে না।
- `delete` স্থায়ীভাবে প্রাইভেট কীটি মুছে দেয়। আপনার যদি এখনও কোন কী প্রয়োজন হয় তবে তার একটি কপি রাখুন।
- `ARGVUS_SSH_DIR` `~/.ssh` প্রতিস্থাপন করে, যা পরীক্ষার জন্য উপকারী।

এজেন্ট হল `argvus-ssh-agent.service` ব্যবহারকারী সেবা যা `argvus-session` দ্বারা শুরু করা হয়েছে। `SSH_AUTH_SOCK` সেশনে এটিকে নির্দেশ করে।

`openssh` (`ssh-keygen` এবং `ssh-add`) এবং `argvus` (`argvus terminal` কমান্ড) প্রয়োজন।

| Symptom | Cause and fix |
| --- | --- |
| `load`একটি টার্মিনাল খুলে, কিন্তু কী লোড হয়নি | সেই টার্মিনালে পাসফ্রেজ টাইপ করুন। যদি এটি জিজ্ঞাসা করা না হয়, তাহলে চালান`ssh-add -l`দেখতে যে এজেন্টের কাছে কী আছে। |
| টার্মিনাল দেখাচ্ছে `Could not open a connection to your authentication agent` | Hyprland এজেন্টের আগে শুরু হয়েছিল, তাই এর টার্মিনালে অভাব রয়েছে `SSH_AUTH_SOCK`. লঞ্চার ফিরে আসে `$XDG_RUNTIME_DIR/ssh-agent.socket`, তাই আপডেট করুন`argvus-launcher`এবং একটি নতুন টার্মিনাল খুলুন। |
| `list` shows `unknown`এতে`loaded`কলাম | এজেন্টটি পৌঁছানো যাচ্ছে না। পরীক্ষা করুন`systemctl --user status argvus-ssh-agent.service`এবং`SSH_AUTH_SOCK` variable. |
| `delete`রিপোর্ট করে যে চাবিটি লোড হয়েছে | চালান `argvus keys unload NAME`প্রথমে, তারপর আবার এটি মুছে দিন। |
| `generate`রিপোর্ট করে যে নামটি ইতিমধ্যে বিদ্যমান | অন্য একটি নাম বেছে নিন। বিদ্যমান জোড়াগুলি কখনো প্রতিস্থাপিত হয় না। |

## GPG কী (`argvus gpg`)

`argvus gpg` তালিকা তৈরি করে এবং GPG কী রপ্তানি করে এবং পাবলিক কী আমদানি করে। gpg-agent সর্বদা `pinentry-gtk` ব্যবহার করে: ARGVUS যে pinentry টি `gpg-agent.conf` তে লিখে, কী তৈরি করার আগে। এর কোনো শর্টকাট নেই। কন্ট্রোল সেন্টারের **GPG কী** পাতা একই কমান্ড ব্যবহার করে।

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

`generate` এই অপশনগুলো নেয়:

- `--algo rsa|dsa` কী অ্যালগরিদম বেছে নেয়। ডিফল্ট হল `rsa`।
- `--bits` কী সাইজ নির্বাচন করে। RSA `1024`, `2048`, `3072` এবং `4096` গ্রহণ করে, যেখানে `4096` ডিফল্ট। DSA `1024`, `2048` এবং `3072` গ্রহণ করে, যেখানে `2048` ডিফল্ট; gpg বড় DSA কী তৈরি করতে পারে না, তাই `4096` gpg চালানোর আগে অগ্রহণযোগ্য।
- `--expire` কোনো মেয়াদ শেষ ছাড়া `0` নেয়, একটি সংখ্যা যা `d`, `w`, `m` বা `y` দ্বারা অনুসরণ করা হয় (যেমন `2y`), অথবা একটি ISO তারিখ `YYYY-MM-DD`, যা অবশ্যই একটি বাস্তব তারিখ হতে হবে।
- `--passphrase-stdin` স্ট্যান্ডার্ড ইনপুটের প্রথম লাইন থেকে পাসফ্রেজ পড়ে। কন্ট্রোল সেন্টার এটি ব্যবহার করে। খালি লাইন প্রত্যাখ্যাত হয়।
- `--no-passphrase --yes` একটি অরক্ষিত কী তৈরি করে। দুটি পাসফ্রেজ মোড একত্রিত করা যায় না।

প্রত্যেকটি কী получает একটি সার্টিফাই-এবং-স্বাক্ষর প্রাইমারি কী এবং একটি এনক্রিপশন সাবকী, তাই এটি ফাইল এনক্রিপ্ট করতে এবং কমিট এবং প্যাকেজ স্বাক্ষর করতে পারে। সাবকীটি প্রাইমারি কীর সাথে মিলে: `rsa` একই আকার সহ RSA এর জন্য, এবং `elg` একই আকার সহ DSA এর জন্য, যা DSA স্ট্যান্ডার্ডের জন্য প্রয়োজনীয় জুটি।

প্রতিটি কমান্ডে প্রযোজ্য নিয়ম:

- পাসফ্রেজ কখনো কমান্ড আর্গুমেন্ট হিসেবে পাঠানো হয় না, লগে লেখা হয় না বা কন্ট্রোল সেন্টারে প্রদর্শিত হয় না। `--passphrase-stdin` এর মাধ্যমে পাসফ্রেজ পাইপ থেকে ফাইল ডিসক্রিপ্টর 0 এর মাধ্যমে gpg তে যায়। ওই বিকল্প না থাকলে, gpg pinentry উইন্ডো জিজ্ঞেস করে, যা `gpg-agent` খোলে।
- `--no-passphrase` প্রাইভেট কী নিরাপত্তা ছাড়া সংরক্ষণ করে। এটি প্রত্যাখ্যান করা হয় যদি না `--yes` দেওয়া হয়।
- `import` যেকোনো ফাইল বাতিল করে যা একটি গোপন চাবির প্যাকেট ধারণ করে, ASCII বা বাইনারি ফর্মে। প্রাইভেট কী শুধুমাত্র `export-private` এর মাধ্যমে কীরিং থেকে বের হয়, যা `--yes` প্রয়োজন এবং মোড `600` এ লেখে; `import-private` এটি আবার ফিরিয়ে আনে।
- যে কমান্ডগুলি কী পরিবর্তন বা প্রকাশ করে (`export-private`, `delete`, `edit sign`, `edit revoke`, `keyserver send`) তাদের `--yes` প্রয়োজন। কন্ট্রোল সেন্টার এটি কেবল নিজের নিশ্চিতকরণের পরে প্রদান করে।
- গোপন কী ব্যবহার করে যে কমান্ডগুলো চালানো হয় তা gpg-কে `--no-tty` দিয়ে চালায়, তাই gpg কখনোই টার্মিনাল খোলার চেষ্টা করে না। পাসফ্রেজটি পিনএন্ট্রি উইন্ডো থেকে আসে, `generate --passphrase-stdin` ব্যতীত।
- `generate` `pinentry-gtk` ব্যবহার করতে gpg-agent কে তৈরি করে। এটি সেই লাইনটি `# BEGIN argvus-managed pinentry` এবং `# END argvus-managed pinentry` মার্কারের মধ্যে লিখে, বাকিগুলি `gpg-agent.conf` রাখে, এবং পূর্ববর্তী ফাইলটি `gpg-agent.conf.bak` হিসেবে সংরক্ষণ করে। যখন ব্লকটি ইতিমধ্যেই `pinentry-gtk` নামে থাকে, ফাইল এবং gpg-agent যেভাবে আছে তেমনই থাকায়। কমান্ডটি চলতে অস্বীকার করে যখন `gpg-agent.conf` ইতিমধ্যেই সেই ব্লক এর বাইরে `pinentry-program` সেট করে, যাতে দুটি মান কখনো সংঘর্ষ না করে।
- প্যাকেজ ইনস্টল করা কখনও `~/.gnupg`-তে লিখে না। কনফিগারেশন কেবল তখনই পরিবর্তিত হয় যখন একটি কী তৈরি করা হয়।
- `GNUPGHOME` `~/.gnupg`-কে প্রতিস্থাপন করে, যা পরীক্ষা করার জন্য ব্যবহারযোগ্য।

`gnupg` এবং `pinentry` আবশ্যকীয় নির্ভরশীলতা: কী কমান্ডগুলির জন্য gpg প্রয়োজন, এবং পাসফ্রেজ উইন্ডোটি হল `pinentry-gtk`।

| Symptom | Cause and fix |
| --- | --- |
| `generate`পাসফ্রেজ উইন্ডো খোলে না | চেক করুন`argvus gpg status`. `pinentry-gtk`ইনস্টল করা আবশ্যক, এবং সেশনটি প্রকাশ করতে হবে`WAYLAND_DISPLAY` or `DISPLAY`. |
| `generate`প্রতিবেদন জানায় যে`pinentry-gtk`ইনস্টল করা হয়নি | ইনস্টল করুন `pinentry` package. |
| `generate` reports a `pinentry-program`ARGVUS ব্লকের বাইরের লাইন | সেই লাইনটি সরান `~/.gnupg/gpg-agent.conf`, তারপর আবার কমান্ডটি চালান। |
| `generate`রিপোর্ট করে যে কী সাইজ সমর্থিত নয় | অ্যালগরিদমের জন্য সাইজ পরীক্ষা করুন: DSA 3072 বিটে থেমে যায়। |
| `generate`রিপোর্ট করে যে এনক্রিপশন সাবকি যোগ করা যায়নি | কী তৈরি করা হয়েছে। সাবকি যোগ করুন`gpg --quick-add-key FINGERPRINT cv25519 encr 2y`, অথবা কীটি মুছে দিন `gpg --delete-secret-and-public-key`এবং এটি আবার তৈরি করুন। |
| `import`একটি ফাইল প্রত্যাখ্যান করে | ফাইলটিতে একটি ব্যক্তিগত কী রয়েছে। অন্য যন্ত্রে কেবলমাত্র পাবলিক কী রপ্তানি করুন`argvus gpg export-public`. |
| `list` কোন চাবি দেখাচ্ছে না | চাবির গুচ্ছটি `GNUPGHOME` (or `~/.gnupg`) খালি। চালান `argvus gpg generate`একটি কী তৈরি করতে। |

## স্নিপেটস (`SUPER + ALT + N`)

`SUPER + ALT + N` আপনার স্নিপেটসের সাথে একটি পিকার খুলে। নির্বাচিত স্নিপেটটি ক্লিপবোর্ডের মাধ্যমে না গিয়ে কার্সরের স্থানে ফোকাস করা উইন্ডোতে টাইপ করা হয়।

### Setup

একটি নাম এবং তার টেক্সট দিয়ে একটি স্নিপেট যোগ করুন:

```sh
argvus snippets add "email" "you@example.com"
```

এটি সংরক্ষিত হয়েছে কিনা পরীক্ষা করুন:

```sh
argvus snippets list
```

স্নিপেটগুলি argvus config এর `snippets` অংশে,  `argvus config` `{name, content}` এন্ট্রিরূপে রাখা হয়। আপনি এগুলি `argvus config get /snippets/items` দিয়ে পড়তে পারেন।

### Use

1. সেই অ্যাপ্লিকেশনের টেক্সট ফিল্ডে ক্লিক করুন যা টেক্সটটি পেতে হবে।
2. Press `SUPER + ALT + N`.
3. নামে স্নিপেটটি নির্বাচন করুন এবং `Enter` চাপুন। টেক্সটটি কার্সরের স্থানে টাইপ করা হবে।

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

- নামগুলো অনন্য এবং কেস-সংবেদনশীল। একটি বিদ্যমান নামের সাথে একটি স্নিপেট যোগ করলে তার বিষয়বস্তু প্রতিস্থাপিত হয়।
- বিষয়বস্তু খালি হতে পারবে না: একটি খালি স্নিপেটকে পাওয়া যায়নি হিসাবে রিপোর্ট করা হয়।
- `open` শুধুমাত্র সংখ্যা দিয়ে তৈরি একটি নামকে একটি অবস্থান হিসেবে বিবেচনা করে। অস্পষ্টতা এড়াতে এমন নাম ব্যবহার করুন যেগুলিতে অক্ষর আছে, যেমন `code2`।
- একটি অবস্থান বোঝায় `list` দ্বারা প্রদর্শিত ক্রম। একটি অংশ সরালে তার পরে থাকা অংশগুলির অবস্থান পরিবর্তিত হয়।

### Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| শর্টকাট চাপলে "কোনো স্নিপেট নেই" নোটিফিকেশন | এখনো কোনো স্নিপেট যোগ করা হয়নি। চালান `argvus snippets add` first. |
| `open`প্রতিবেদন অনুসন্ধান করা অংশটি পাওয়া যায়নি | নামটি সম্পূর্ণ মিলছে না। তুলনা করুন `argvus snippets list`. |
| অ্যাপ্লিকেশনে কিছুই প্রদর্শিত হচ্ছে না | ফোকাস করা উইন্ডোটি একটি টেক্সট ফিল্ড নয়, অথবা এটি একটি X11 অ্যাপ্লিকেশন যা XWayland-এর অধীনে চলছে, যা এই ধরনের ইনপুট উপেক্ষা করতে পারে। একটি নেটিভ ওয়েইল্যান্ড অ্যাপ্লিকেশনের সাথে পরীক্ষা করুন। |

প্রয়োজন `wtype`, `rofi`, `jq` এবং `argvus` (`argvus config` কমান্ড)।

`wtype` ওয়াইল্যান্ড ইনপুট স্তরে কি প্রেস সিমুলেট করে। কিছু X11 অ্যাপ্লিকেশন যেগুলো XWayland-এর অধীনে চলে, এই ইভেন্টগুলো উপেক্ষা করে, তাই টেক্সট সেখানে প্রদর্শিত নাও হতে পারে যদিও স্নিপেটটি পাওয়া গিয়েছে।

## গিট (`SUPER + ALT + G`)

`SUPER + ALT + G` `SUPER + O` এর মতো একই প্রজেক্ট পিকার খুলে। একটি প্রজেক্ট নির্বাচন করলে `lazygit` (বা `gitui`) সরাসরি এতে খুলে, বর্তমান ওয়ার্কস্পেসে একটি নতুন ARGVUS টার্মিনালে। প্রজেক্টটি আগে নির্বাচন করার জন্য আলাদা কোনো ধাপ নেই।

### Setup

দুটি টুলের একটি ইনস্টল করুন। এই উভয়ই এই প্যাকেজের ঐচ্ছিক ডিপেনডেন্সি:

```sh
sudo pacman -S lazygit   # or: sudo pacman -S gitui
```

### Use

1. Press `SUPER + ALT + G`.
2. তালিকায় একটি প্রকল্প বেছে নিন, অথবা বাতিল করতে `Esc` চাপুন। বাতিল করলে কিছু খুলবে না।
3. টার্মিনাল প্রকল্প ডিরেক্টরিতে খোলে এবং TUI শুরু করে।

একটি প্রকল্প যা git রিপোজিটরি নয়, একটি নোটিফিকেশন দেখায় এবং কিছু খোলে না। পিকার এড়ানোর জন্য, একটি ডিরেক্টরি পাস করুন:

```sh
argvus git ~/Projects/api
```

### টুল নির্বাচন করা

`argvus-git` ইনস্টল হলে `lazygit` ব্যবহার করে, এবং অন্যথায় `gitui` ব্যবহার করে। `gitui` পছন্দ করতে, এই কমান্ডের জন্য `ARGVUS_GIT_TUI` সেট করুন:

```sh
ARGVUS_GIT_TUI=gitui argvus git
```

। ভেরিয়েবলটি সেই কমান্ডের পরিবেশ থেকে পড়া হয় যা স্ক্রিপ্ট চালায়। এটি ARGVUS কনফিগারেশনে সংরক্ষিত নেই।

### Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| নোটিফিকেশন "গিট রেপোজিটরি নয়" | নির্বাচিত প্রকল্পটি একটি গিট রেপোজিটরি নয়, অথবা এর ডিরেক্টরি স্থানান্তরিত হয়েছে। এটি সরান বা ঠিক করুন `argvus projects remove`. |
| বিজ্ঞপ্তি "lazygit বা gitui ইনস্টল করুন" | উভয় টুলই নেই `PATH`. তাদের মধ্যে একটি ইনস্টল করুন। |
| পিকারের কোনো প্রকল্প দেখায় না | কোনো প্রকল্প যোগ করা হয়নি। ব্যবহার করুন `argvus projects add`. |

## ইমোজি পিকার (`SUPER + .`)

`SUPER + .` ARGVUS Rofi কনফিগারেশনের সঙ্গে `rofimoji` খুলে। নাম দ্বারা একটি ইমোজি খুঁজুন, `Enter` চাপুন, এবং ইমোজিটি ক্লিপবোর্ডে কপি করা হয়। আপনি যে অ্যাপ্লিকেশনে চান সেখানে `Ctrl + V` দিয়ে এটিকে পেস্ট করুন।

যখন পিকার খোলা থাকে, সেশন কীবোর্ড-লেআউট বিজ্ঞপ্তিগুলি উপেক্ষা করে যা এটি সাধারণত দেখাবে। লঞ্চার ARGVUS ক্যাশে ডিরেক্টরিতে একটি স্বল্পকালীন মার্কার লিখে এবং পিকার বন্ধ হওয়ার প্রায় এক সেকেন্ড পরে এটি মুছে দেয়।

-এর জন্য `rofimoji` এবং `wl-clipboard` প্রয়োজন।

## ক্যালকুলেটর (`SUPER + C`)

`SUPER + C` ARGVUS Rofi কনফিগারেশনের সঙ্গে Rofi এর `calc` মোড খোলে। একটি এক্সপ্রেশন টাইপ করুন, এবং ফলাফলের তালিকা টাইপ করার সাথে সাথে আপডেট হয়। `rofi-calc` মোড অনুযায়ী একটি ফলাফলের নির্বাচন করুন।

লঞ্চার প্যাকেজটি Rofi কনফিগারেশন প্রদান করে এবং `rofi-calc` এর উপর নির্ভর করে। শর্টকাটটি নিজেই `argvus-hyprland` দ্বারা ঘোষণা করা হয়।

## চিটশিট (`SUPER + SHIFT + /` এবং `SUPER + CTRL + /`)

`cheatsheets.sh` একটি বড় Rofi উইন্ডোতে শর্টকাটের রিড-অনলি লিস্ট দেখায়। এটি তার আর্গুমেন্ট হিসাবে অ্যাপ্লিকেশন নাম নেয়:

```sh
cheatsheets.sh hypr     # Hyprland shortcuts (SUPER + SHIFT + /)
cheatsheets.sh kitty    # terminal shortcuts (SUPER + CTRL + /)
cheatsheets.sh <name>   # any other application with a cheatsheet
```

- `hypr` ব্যবহারকারীর ARGVUS কনফিগারেশন থেকে `data/generated/hypr/keybindings.txt` ব্যবহার করে যখন সেই ফাইলটি উপস্থিত থাকে। অন্যথায় এটি `argvus-hyprland` সহ পাঠানো Hyprland চিটশিট ব্যবহার করে।
- `kitty` `argvus` এর সাথে সরবরাহিত টার্মিনাল চিটশিট ব্যবহার করে।
- অন্য যে কোনো নাম `<name>/docs/cheatsheets/<language>.txt` পড়ে। যদি সেই ফাইলটি না থাকে, কোনো উইন্ডো খোলা হয় না।

সিস্টেম লোকেল `pt-BR` হলে ভাষা পর্তুগিজ হয়, এবং অন্যথায় ইংরেজি। `Esc` উইন্ডো বন্ধ করে। একটি লাইন নির্বাচন করলে সেটি কেবল বন্ধ হয়; কিছু চালানো হয় না।

## অন্যান্য মেনু যা Rofi কনফিগারেশন ব্যবহার করে

লঞ্চার কনফিগারেশনটি অন্যান্য প্যাকেজের মালিকানাধীন উপাদানের সাথে ভাগ করা হয়:

- ক্লিপবোর্ড ইতিহাস (`SUPER + H`) এবং তার ক্লিয়ার শর্টকাট (`SUPER + SHIFT + H`) `argvus-hyprland` দ্বারা ঘোষণা করা হয়েছে। তারা `cliphist` এই কনফিগারেশনের সাথে Rofi-তে পাঠায়। `cliphist` আসে `argvus-session` থেকে, যা ক্লিপবোর্ড রেকর্ডার চালায় যা ইতিহাস পূরণ করে; `argvus` মেটা-প্যাকেজও এর উপর নির্ভরশীল।
- `argvus-appearance`-এ থিম, অ্যাকসেন্ট এবং লেআউট পিকারের মাধ্যমে `config.rasi` সহ Rofi খোলা হয়।
- Hyprland উইন্ডো নিয়মগুলি `argvus-launcher` এবং `rofi` নেমস্পেসগুলোকে চিনতে পারে, তাই মেনুগুলো লঞ্চার সারফেস ট্রিটমেন্ট পায়।

## প্যাকেজিং এবং ডিপেন্ডেন্সি

`argvus-launcher` প্যাকেজটি স্থাপত্য-নিরপেক্ষ এবং এটি ইনস্টল করে:

- `argvus launcher`, `argvus-snippets`, `argvus-ssh` এবং `argvus-git`, একই ডিরেক্টরির অধীনে;
- `/usr/share/argvus/launcher/config/`, Rofi কনফিগারেশন এবং থিমসহ;
- `/usr/share/argvus/launcher/sh/`, `cheatsheets.sh` এবং `emoji-picker.sh` এর সাথে।

প্রয়োজনীয় নির্ভরতা: `argvus-session`, `argvus-appearance`, `argvus`, `bash`, `jq`, `hyprland`, `libnotify`, `rofi`, `rofi-calc`, `rofimoji`, `wl-clipboard`, `wtype`, `gnupg` এবং `pinentry` (যা `pinentry-gtk` প্রদান করে)। ঐচ্ছিক নির্ভরতা: `openssh`, SSH পিকার এবং SSH কী ম্যানেজারের জন্য; `lazygit` এবং `gitui`, git TUI-এর জন্য।

প্যাকেজ ইনস্টল করা `$HOME`-এ লেখা হয় না। ব্যবহারকারীর কনফিগারেশন সেশন শুরুতে তৈরি হয়, যেমনটি [Rofi configuration and themes](#where-the-active-configuration-lives) তে বর্ণনা করা হয়েছে।

## Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| `SUPER + D`কিছুই খুলছে না | চেক করুন`argvus launcher`একটি টার্মিনালে। নিশ্চিত করুন যে`rofi`ইনস্টল করা হয়েছে এবং Rofi কনফিগারেশন উপস্থিত আছে। |
| `SUPER + D`কোনো অ্যাপ্লিকেশন তালিকাভুক্ত নয় | অ্যাপ্লিকেশনগুলির কোনো ডেস্কটপ এন্ট্রি নেই। শুধুমাত্র অ্যাপ্লিকেশন যা একটি`.desktop`ফাইল দেখানো হয়েছে। |
| মেনুগুলো একটি পুরোনো ফন্ট ব্যবহার করে | `font:`সেশন শুরুতে লাইনটি পুনরায় লেখা হয়। ফন্ট পরিবর্তনের পরে সেশনটি পুনরায় শুরু করুন। |
| একটি থিম পরিবর্তন Rofi মেনুতে পৌঁছায় না | ব্যবহারকারীর কপি পরীক্ষা করুন `config.rasi` in `$XDG_CONFIG_HOME/argvus/data/rofi/`এখনও প্যাকেজড থিমের দিকে নির্দেশ করছে। থিমটি থেকে প্রয়োগ করুন `argvus-appearance` again. |
| `SUPER + O`প্রতিবেদন করে যে কোনো প্রকল্প পাওয়া যায়নি | কোনো মূল বা পথ কনফিগার করা নেই, অথবা ডিরেক্টরি আর বিদ্যমান নেই। চালান `argvus projects list`. |
| `SUPER + C`অথবা ইমোজি পিকার খুলে না | ইনস্টল করুন`rofi-calc` or `rofimoji` (উভয়ই প্রয়োজনীয় নির্ভরতা)। |
| একটি চিটশিট খোলা যায় না | সেই নাম এবং ভাষার জন্য ফাইলটি বিদ্যমান নয়। চিটশিটস القسمে বর্ণিত পথগুলি পরীক্ষা করুন। |
| `SUPER + H`কিছু দেখায় না | ইতিহাস খালি, বা ক্লিপবোর্ড রেকর্ডার থেকে`argvus-session`এখনও কিছু সংরক্ষণ করা হয়নি। |

## সম্পর্কিত উপাদানসমূহ

| Component | Responsibility |
| --- | --- |
| `argvus-hyprland` | মেনুগুলির জন্য শর্টকাট এবং হাইপ্রল্যান্ড উইন্ডো নিয়মগুলি ঘোষণা করে। |
| `argvus-appearance` | সক্রিয় থিম, অ্যাকসেন্ট এবং লেআউট পরিবর্তন করে, এবং Rofi থিম রেফারেন্সগুলি পুনরায় লিখে। |
| `argvus` (`argvus config`) | প্রকল্পগুলি, স্নিপেটগুলি এবং ডিফল্ট লঞ্চার সেটিং সংরক্ষণ করে। |
| `argvus-session` | প্রাথমিক Rofi কনফিগারেশনটি নকল করে এবং সেশন শুরুতে তার ফন্ট সেট করে। |
| `argvus` (`argvus terminal`) | SSH সেশন, প্রজেক্ট টার্মিনাল এবং পাসফ্রেজ প্রম্পট খুলে`argvus keys`. |
| `argvus` (`argvus widget-telemetry`) | Reads the active project written by `argvus projects`. |
| `argvus` (`argvus i18n`) | লঞ্চার স্ক্রিপ্টগুলিতে ব্যবহৃত অনুবাদিত বার্তাগুলি সরবরাহ করে। |
| `argvus` (`argvus control-center`) | Edits the project list through `argvus projects`. |
