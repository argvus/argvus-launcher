---
title: Application launcher
description: ARGVUS Rofi मेनू के माध्यम से एप्लिकेशन लॉन्च करें, प्रोजेक्ट खोलें, SSH होस्ट और स्निपेट्स, इमोजी चुनें, गणना करें, और चीटशीट पढ़ें।
---

`argvus-launcher` वह Rofi कॉन्फ़िगरेशन, थीम और मेनू प्रदान करता है जिसका ARGVUS उपयोग करता है चीज़ें कीबोर्ड से खोलने के लिए। इसमें शामिल हैं:

- एप्लिकेशन लॉन्चर (`SUPER + D`);
- Rofi कॉन्फ़िगरेशन और थीम जो प्रत्येक ARGVUS Rofi मेनू द्वारा साझा की जाती हैं;
- प्रोजेक्ट स्विचर, SSH पिकर और स्निपेट पिकर (`argvus projects`, `argvus ssh`, `argvus snippets`);
- SSH की मैनेजर (`argvus keys`), जो की जोड़े बनाता है, सूचीबद्ध करता है, लोड करता है और हटाता है;
- GPG की मैनेजर (`argvus gpg`), जो सूचियाँ बनाता है, की बनाता है और निर्यात करता है और gpg-agent के लिए pinentry-gtk सेट करता है;
- इमोजी पिकर, चीटशीट व्यूअर और कैलकुलेटर मेनू।

शॉर्टकट `argvus-hyprland` द्वारा घोषित किए गए हैं। यह पैकेज कमांड और उनके पीछे के मेनू प्रदान करता है।

## Shortcuts

| Shortcut | Action | Command | Section |
| --- | --- | --- | --- |
| `SUPER + D` | Application launcher | `argvus launcher` | Application launcher |
| `SUPER + O` | Project switcher | `argvus projects` | Project switcher |
| `SUPER + ALT + 1` to `9`उस स्थिति में प्रोजेक्ट खोलें`argvus projects open N` | प्रोजेक्ट स्विचर |
| `SUPER + ALT + S` | SSH host picker | `argvus ssh` | SSH |
| `SUPER + ALT + N` | Snippet picker | `argvus snippets` | Snippets |
| `SUPER + ALT + G` | Project picker, then git TUI | `argvus git` | Git |
| `SUPER + .` | Emoji picker | `emoji-picker.sh` | Emoji picker |
| `SUPER + C` | Calculator | `rofi -show calc` | Calculator |
| `SUPER + SHIFT + /` | Hyprland cheatsheet | `cheatsheets.sh hypr` | Cheatsheets |
| `SUPER + CTRL + /` | Kitty cheatsheet | `cheatsheets.sh kitty` | Cheatsheets |

## एप्लिकेशन लॉन्चर (`SUPER + D`)

`SUPER + D` चलाता है `argvus launcher`, जो `drun` मोड में Rofi को खोलता है। यह डेस्कटॉप एंट्री के साथ इंस्टॉल की गई ग्राफिकल एप्लिकेशन्स की सूची दिखाता है, और चुनी गई एप्लिकेशन `Enter` दबाने पर शुरू होती है।

1. Press `SUPER + D`.
2. एप्लिकेशन के नाम का हिस्सा टाइप करें। सूची क्रमबद्ध होती है और फ़िल्टर केस की परवाह नहीं करता।
3. एप्लिकेशन शुरू करने के लिए `Enter` दबाएँ, या मेनू बंद करने के लिए `Esc` दबाएँ।

```sh
argvus launcher                  # opens the application menu
argvus launcher --config PATH    # uses another Rofi configuration file
```

कोई अन्य तर्क `rofi` को दिया जाता है। बिना मान के `--config` त्रुटि के साथ रुक जाता है।

जब डिफ़ॉल्ट लॉन्चर rofi होता है, जो डिफ़ॉल्ट है, तब Hyprland `argvus launcher --config <Rofi configuration>` चलाता है। यदि डिफ़ॉल्ट एप्लिकेशन में डिफ़ॉल्ट  `rofi` `launcher` किसी अन्य प्रोग्राम पर सेट किया गया है, तो Hyprland इसके बजाय `<program> --show drun` चलाता है। इसे कंट्रोल सेंटर के डिफ़ॉल्ट एप्लिकेशन में सेट करें, जो इस मान को `argvus-config` में संग्रहीत करता है।

केवल डेस्कटॉप एंट्री वाली एप्लिकेशन सूची में दिखाई देती हैं। कोई एप्लिकेशन जो कोई `.desktop` फ़ाइल इंस्टॉल नहीं करता, उसे यहाँ नहीं पाया जा सकता।

## Rofi कॉन्फ़िगरेशन और थीम

पैकेज Rofi कॉन्फ़िगरेशन को `/usr/share/argvus/launcher/config/` के तहत इंस्टॉल करता है:

| File | Role |
| --- | --- |
| `config.rasi` | प्रत्येक ARGVUS मेनू द्वारा उपयोग किया जाने वाला एंट्री पॉइंट। Rofi सेट करता है `configuration`(फ़ॉन्ट, कोई आइकन नहीं, क्रमबद्ध सूची, केस-इन्सेंसिटिव मिलान) और इम्पोर्ट्स`theme.rasi`. |
| `theme.rasi` | विंडो, इनपुट बार और सूची के रंग और लेआउट। एक थीम और मोड फ़ाइल आयात करता है। |
| `mode.rasi` | मोड ओवरराइड। पैकेज किया गया फाइल कोई ओवरराइड नहीं रखता और डार्क मोड बनाए रखता है। |
| `themes/<family>/theme.rasi` | Palette of a theme family, for example `argvus-dark` or `tokyo-night`. |
| `themes/<family>-spaced/theme.rasi` | Spaced variant of the same family. |

पैकेज 22 परिवार प्रदान करता है, और प्रत्येक के पास `-spaced` प्रकार है। पैकेज किए गए `theme.rasi` ने `argvus-dark` को आयात किया।

### जहां सक्रिय कॉन्फ़िगरेशन मौजूद है

ARGVUS प्रत्येक Rofi फ़ाइल को `paths_config` के माध्यम से हल करता है। उपयोगकर्ता ओवरराइड, उपयोगकर्ता कॉपी, पुराने स्थान और उत्पन्न पेड़ में से पहला मौजूद फ़ाइल जीतता है; अन्यथा `/usr/share/argvus/launcher/config/` के अंतर्गत पैकेज फ़ाइल का उपयोग किया जाता है। किसी फ़ाइल की उपयोगकर्ता कॉपी `$XDG_CONFIG_HOME/argvus/data/rofi/<file>` है: `launcher/config/` प्रीफिक्स को `rofi/` के अंतर्गत संग्रहीत किया जाता है।

ARGVUS उस फ़ाइल को तब पहली बार उपयोगकर्ता प्रति बनाता है जब ARGVUS स्क्रिप्ट उस फ़ाइल को बदलती है; `argvus-appearance` यह थीम, एक्सेंट और मोड में बदलाव के लिए करता है। फ़ाइलें जो कभी बदली नहीं गईं, वे पैकेज से पढ़ी जाती हैं, और एक उपयोगकर्ता प्रति पैकेज फ़ाइल पर प्राथमिकता रखती है।

जब `argvus-session` सत्र की शुरुआत में फॉंट लागू करता है, तो यह ARGVUS फॉंट सेटिंग से config.rasi की `font:` पंक्ति को फिर से लिख देता है। यह संपादन केवल उपयोगकर्ता प्रतिलिपि तक पहुँचता है। जब तक प्रतिलिपि मौजूद नहीं होती, पैकेज्ड फ़ाइल वही पाई जाती है, और उपयोगकर्ता इसमें लिख नहीं सकते, इसलिए फॉंट परिवर्तन तब प्रभावी होता है जब पहली उपस्थिति परिवर्तन ने प्रतिलिपि बना दी।

### थीम बदलना

 `config.rasi` `argvus-appearance` थीम परिवर्तनों का मालिक है। जब थीम बदलती है, तो यह उपयोगकर्ता की प्रतियों को फिर से लिखता है ताकि `config.rasi` नए `theme.rasi` की ओर इशारा करे, और `theme.rasi` थीम बिल्ड (`~/.config/argvus/data/generated/theme/current/launcher/theme.rasi`) का लॉन्चर पैलेट आयात करता है, जिसमें सक्रिय फैमिली, लेआउट और हाइलाइट रंग होता है। थीम बिल्ड के बिना, यह फैमिली कॉपी आयात करता है, और स्पेस्ड लेआउट सक्रिय फैमिली के `-spaced` संस्करण का चयन करता है। थीम पिकर्स जैसे कि थीम मेनू और लेआउट मेनू वही `config.rasi` पढ़ते हैं, इसलिए वे भी सक्रिय शैली का उपयोग करते हैं।

`/usr/share/argvus/launcher/` के अंतर्गत फ़ाइलों को संपादित न करें; इन्हें पैकेज अपग्रेड पर बदल दिया जाता है। उपयोगकर्ता की प्रति में परिवर्तन करें, `$XDG_CONFIG_HOME/argvus/data/rofi/` के अंतर्गत।

## प्रोजेक्ट स्विचर (`SUPER + O`)

`argvus projects` (`SUPER + O`) उन परियोजनाओं की सूची दिखाता है जिन्हें आपने जोड़ा है और चयनित परियोजना को इसके अपने Hyprland कार्यक्षेत्र में खोलता है, जिसमें इसकी निर्देशिका में एक `argvus terminal` होता है। यदि परियोजना का कार्यक्षेत्र पहले से मौजूद है, तो स्विचर केवल उस पर ध्यान केंद्रित करता है।

केवल कीबोर्ड पहुँच के लिए, `SUPER + ALT + 1` से `SUPER + ALT + 9` तक उस सूची की स्थिति में प्रोजेक्ट खोलें, मेनू के बिना। स्थिति वे नंबर हैं जो मेनू में दिखाए जाते हैं। वे सूची के क्रम के अनुसार होते हैं, इसलिए किसी प्रोजेक्ट को जोड़ना या हटाना उन्हें बदल सकता है। `argvus projects open <number or directory name>` टर्मिनल से वही करता है, और विफलताओं को एक नोटिफिकेशन के रूप में दिखाया जाता है।

सक्रिय परियोजना सूची को 9 पर सीमित किया गया है, क्योंकि यही सब `SUPER + ALT + 1..9` संभाल सकता है। `argvus projects add` (और कंट्रोल सेंटर का प्रोजेक्ट्स पेज, जो इसे कॉल करता है) एक परियोजना या रूट जोड़ने से इंकार कर देता है जो कुल संख्या को 9 से आगे बढ़ा देगा, और इसके बजाय त्रुटि रिपोर्ट करता है।

एक परियोजना `projects` अनुभाग के `argvus-config` में दो स्थानों से आती है:

- `paths`: व्यक्तिगत परियोजना निर्देशिकाएँ।
- `roots`: निर्देशिकाएँ जिनकी तत्काल उपनिर्देशिकाएँ परियोजनाएँ हैं। एक जड़ जो मौजूद नहीं है उसे अनदेखा किया जाता है।

डिफ़ॉल्ट रूप से कोई जड़ या पथ कॉन्फ़िगर नहीं है; सूचीबद्ध करने से पहले कम से कम एक जोड़ें। `SUPER + O` उन्हें टर्मिनल से प्रबंधित करें:

```sh
argvus projects add ~/Work/api          # one project
argvus projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus projects remove ~/Work/api       # removes it from paths and roots
argvus projects list                    # prints the roots and paths
```

`argvus projects pick` वही सूची दिखाता है और इसे खोलने के बजाय चुने हुए पथ को प्रिंट करता है। अन्य टूल इसका उपयोग कर सकते हैं, जैसे कि `argvus git` करता है। रद्द करने पर कुछ भी प्रिंट नहीं होता।

यदि कोई रूट या पथ मौजूद नहीं है, तो `SUPER + O` रिपोर्ट करता है कि कोई परियोजनाएँ नहीं पाई गईं। một वैकल्पिक संपादक आदेश, `/projects/editor`, वर्कस्पेस बनाने पर वही वर्कस्पेस में शुरू होता है।

प्रविष्टियाँ प्रभावी कॉन्फ़िगरेशन से पढ़ी जाती हैं; लॉन्चर उनकी कोई प्रति नहीं रखता।

किसी प्रोजेक्ट को खोलना भी उसके पथ को सत्र के लिए सक्रिय प्रोजेक्ट के रूप में रिकॉर्ड करता है, जिसे Dev Dashboard टेलीमेट्री ब्लॉक (`argvus widget-telemetry`) उस प्रोजेक्ट की git, सुनने वाले पोर्ट और कंटेनरों की रिपोर्ट करने के लिए पढ़ता है।

## एसएसएच (`SUPER + ALT + S`)

`SUPER + ALT + S` एक पिकर खोलता है जिसमें `~/.ssh/config` में परिभाषित होस्ट होते हैं। चयनित होस्ट वर्तमान कार्यस्थान में `ssh <host>` चला रहे एक नए ARGVUS टर्मिनल में खुलता है।

### Setup

प्रत्येक सर्वर के लिए `Host` प्रविष्टि `~/.ssh/config` में जोड़ें:

```ini
Host myhost
    HostName myhost.local
    User boss
    IdentityFile ~/.ssh/myhost
    IdentitiesOnly yes
```

सबसे पहले पुष्टि करें कि `ssh myhost` एक सामान्य टर्मिनल में काम करता है। लॉन्चर केवल `ssh` चलाता है; प्रमाणीकरण, कुंजी और होस्ट सत्यापन OpenSSH द्वारा संभाले जाते हैं।

### Use

1. Press `SUPER + ALT + S`.
2. होस्ट नाम का हिस्सा टाइप करें, या एरो कीज़ का उपयोग करें।
3. `Enter` दबाएँ। टर्मिनल खुलता है और `ssh <host>` चलाता है।

जब सत्र समाप्त होता है, तो विंडो खुली रहती है और निकासी स्थिति दिखाती है, उदाहरण के लिए `ssh exited with status 0. Press Enter to close.` इसे बंद करने के लिए `Enter` दबाएँ। यह GitHub, GitLab और Gitea जैसी फोर्ज के लिए महत्वपूर्ण है: वे आपको प्रमाणित करते हैं और तुरंत कनेक्शन बंद कर देते हैं क्योंकि वे शेल प्रदान नहीं करते। विंडो उनका संदेश स्क्रीन पर बनी रहती है, गायब होने के बजाय।

### Rules

- वाइल्डकार्ड प्रविष्टियां (`Host *`, `Host *.internal`) मैच ब्लॉक हैं, लक्ष्य नहीं, और कभी सूचीबद्ध नहीं की जातीं।
- किसी भी `Host` लाइन पर हर उपनाम अलग-अलग सूचीबद्ध किया जाता है (`Host a b` में `a` और `b` सूचीबद्ध हैं)। प्रतिलिपियां हटा दी जाती हैं।
- केवल उन फाइलों में परिभाषित होस्ट जो `Include` के साथ लोड की गई हैं, सूचीबद्ध नहीं होते; पिकर केवल मुख्य फ़ाइल पढ़ता है।
- केवल ऐसे उपनाम जो अक्षरों, अंकों, `.`, `-` और `_` से बने हैं, लॉन्च किए जाते हैं। कोई अन्य नाम अधिसूचना के साथ अस्वीकार कर दिया जाता है।
- कॉन्फ़िग में विंडोज़ लाइन एंडिंग्स (CRLF) स्वीकार किए जाते हैं।
- `ARGVUS_SSH_CONFIG` कॉन्फ़िग फ़ाइल का पथ बदलता है, जो परीक्षण के लिए उपयोगी है।

### Commands

```sh
argvus ssh list          # prints the configured hosts, one per line
argvus ssh open myhost   # opens a specific host without the picker
```

### Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| सूचना "~/.ssh/config में कोई होस्ट पाए नहीं गए" | फाइल गायब है या इसमें कोई नहीं है`Host`लाइनें। चलाएँ`argvus ssh list`जाँचने के लिए। |
| पिकर से एक होस्ट गायब है | यह एक वाइल्डकार्ड है, यह एक से आता है `Include`फ़ाइल, या उसमें अनुमत सेट के बाहर के अक्षर हैं। इसे मुख्य फ़ाइल में एक साधारण उपनाम के साथ रखें। |
| विंडो तुरंत त्रुटि स्थिति दिखाती है | चलाएँ `ssh <host>`सामान्य टर्मिनल में पूरा संदेश देखने के लिए (अनपहुंच होस्ट, गलत कुंजी, आदि)। |
| विंडो दिखाती है`message.ssh_session_ended`पाठ के बजाय | स्थापित किया गया`argvus`पैकेज इस संस्करण से पुराना है। अपडेट करें`argvus`. |

को `openssh` और `argvus` (`argvus terminal` कमांड) की आवश्यकता है।

## एसएसएच कुंजियाँ (`argvus keys`)

`argvus keys` `~/.ssh` में की जोड़ी और ssh-agent द्वारा रखी गई कुंजियों का प्रबंधन करता है। इसका कोई शॉर्टकट नहीं है। कंट्रोल सेंटर (एप्लिकेशन) का **SSH कुंजी** पृष्ठ वही कमांड का उपयोग करता है।

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

हर कमांड पर लागू नियम:

- `~/.ssh` के तहत एक कुंजी नाम फ़ाइल नाम बन जाता है, इसलिए इसमें केवल अक्षर, अंक, डॉट, हाइफ़न और अंडरस्कोर शामिल हो सकते हैं। यह डॉट से शुरू नहीं हो सकता या `.pub` पर समाप्त नहीं हो सकता। मौजूदा जोड़ी कभी ओवरराइट नहीं की जाती।
- केवल सार्वजनिक फ़ाइल (`NAME.pub`) वाली जोड़ियां सूचीबद्ध की जाती हैं, और केवल इन्हें लोड, अनलोड या हटाया जा सकता है।
- पासफ्रेज़ कभी भी कमांड आर्गुमेंट के रूप में नहीं पास किए जाते, लॉग में नहीं लिखे जाते और कंट्रोल सेंटर में नहीं दिखाए जाते। `load` और `generate --passphrase` एक ARGVUS टर्मिनल खोलते हैं, और OpenSSH उस टर्मिनल से सीक्रेट पढ़ता है।
- `list` उस समय loaded कॉलम में `unknown` रिपोर्ट करता है जब एजेंट तक पहुंच नहीं हो पाती। यह कभी भी अनुमान नहीं लगाता।
-  `loaded` `delete` निजी कुंजी को हमेशा के लिए हटा देता है। किसी भी कुंजी की एक प्रति रखें जिसकी आपको अभी भी आवश्यकता है।
-  `ARGVUS_SSH_DIR` `~/.ssh` को बदल देता है, जो परीक्षण के लिए उपयोगी है।

एजेंट argvus-session द्वारा शुरू की गई `argvus-ssh-agent.service` उपयोगकर्ता सेवा है।  `argvus-session` `SSH_AUTH_SOCK` सत्र में इसे इंगित करता है।

`openssh` (`ssh-keygen` और `ssh-add`) और `argvus` (`argvus terminal` कमांड) की आवश्यकता है।

| Symptom | Cause and fix |
| --- | --- |
| `load`एक टर्मिनल खोलता है, लेकिन कुंजी लोड नहीं हुई है | उस टर्मिनल में पासफ्रेज़ टाइप करें। अगर यह नहीं पूछा गया, तो चलाएँ `ssh-add -l`यह देखने के लिए कि एजेंट के पास क्या है। |
| टर्मिनल दिखाता है`Could not open a connection to your authentication agent` | Hyprland एजेंट से पहले शुरू हुआ, इसलिए इसके टर्मिनल्स में कमी है `SSH_AUTH_SOCK`. लॉन्चर पीछे हट जाता है`$XDG_RUNTIME_DIR/ssh-agent.socket`, इसलिए अपडेट करें`argvus-launcher`और एक नया टर्मिनल खोलें। |
| `list` shows `unknown`में`loaded`स्तंभ | एजेंट तक पहुँचना संभव नहीं है। जाँच करें`systemctl --user status argvus-ssh-agent.service` और `SSH_AUTH_SOCK` variable. |
| `delete`रिपोर्ट करता है कि कुंजी लोड हो गई है | चलाएँ`argvus keys unload NAME`पहले, फिर इसे फिर से मिटा दें। |
| `generate`रिपोर्ट करता है कि नाम पहले से मौजूद है | कोई अन्य नाम चुनें। मौजूदा जोड़े कभी प्रतिस्थापित नहीं किए जाते। |

## GPG कुंजियाँ (`argvus gpg`)

`argvus gpg` GPG कुंजियाँ सूचीबद्ध करता है, बनाता है और निर्यात करता है तथा सार्वजनिक कुंजियाँ आयात करता है। gpg-agent हमेशा `pinentry-gtk`: ARGVUS का उपयोग करता है और key बनाने से पहले pinentry को `gpg-agent.conf` में लिखता है। इसका कोई शॉर्टकट नहीं है। कंट्रोल सेंटर का **GPG कुंजियाँ** पृष्ठ वही कमांड इस्तेमाल करता है।

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

`generate` इन विकल्पों को लेता है:

- `--algo rsa|dsa` कुंजी एल्गोरिथ्म चुनता है। डिफ़ॉल्ट `rsa` है।
- `--bits` कुंजी आकार चुनता है। RSA `1024`, `2048`, `3072` और `4096` को स्वीकार करता है, जिसमें `4096` डिफ़ॉल्ट है। DSA `1024`, `2048` और `3072` को स्वीकार करता है, जिसमें `2048` डिफ़ॉल्ट है; gpg बड़े DSA कुंजी नहीं बना सकता, इसलिए `4096` gpg चलने से पहले अस्वीकार कर दिया जाता है।
- `--expire` कोई समाप्ति न होने के लिए `0` लेता है, एक संख्या जिसके बाद `d`, `w`, `m` या `y` (जैसे `2y`) आती है, या एक ISO तिथि `YYYY-MM-DD`, जो एक वास्तविक तिथि होनी चाहिए।
- `--passphrase-stdin` मानक इनपुट की पहली पंक्ति से पासफ्रेज पढ़ता है। इसे कंट्रोल सेंटर उपयोग करता है। एक खाली पंक्ति अस्वीकार कर दी जाती है।
- `--no-passphrase --yes` एक असुरक्षित कुंजी बनाता है। दो पासफ्रेज़ मोड को मिलाया नहीं जा सकता।

हर कुंजी को एक प्रमाणित-और-हस्ताक्षरित प्राथमिक कुंजी और एक एन्क्रिप्शन उपकुंजी मिलती है, ताकि यह फ़ाइलों को एन्क्रिप्ट कर सके और कमिट्स और पैकेजों पर हस्ताक्षर भी कर सके। उपकुंजी प्राथमिक कुंजी से मेल खाती है: RSA के लिए समान आकार के साथ `rsa`, और DSA के लिए समान आकार के साथ `elg`, जो DSA मानक द्वारा आवश्यक जोड़ी है।

हर कमांड पर लागू नियम:

- पासफ़्रेसेस कभी भी कमांड आर्गुमेंट्स के रूप में पास नहीं की जातीं, लॉग में नहीं लिखी जातीं और कंट्रोल सेंटर में नहीं दिखाई जातीं। `--passphrase-stdin` के साथ पासफ़्रेस फाइल डिस्क्रिप्टर 0 पर पाइप से gpg को जाता है। उस विकल्प के बिना, gpg पिनएंट्री विंडो पूछता है, जिसे `gpg-agent` खोलता है।
- `--no-passphrase` प्राइवेट की को बिना सुरक्षा के स्टोर करता है। इसे तब तक अस्वीकार कर दिया जाता है जब तक कि `--yes` भी न दिया गया हो।
- `import` किसी भी फ़ाइल को अस्वीकार करता है जिसमें सीक्रेट की पैकेट हो, ASCII या बाइनरी रूप में। प्राइवेट कीज़ केवल `export-private` के माध्यम से कीरिंग छोड़ती हैं, जिसमें `--yes` की आवश्यकता होती है और मोड zxqmask000003qxzq में लिखती है;  `600` `import-private` उन्हें वापस लाता है।
- जो कमांड्स कीज़ बदलते या प्रकाशित करते हैं (`export-private`, `delete`, `edit sign`, `edit revoke`, `keyserver send`) उन्हें `--yes` की आवश्यकता होती है। कंट्रोल सेंटर इसे केवल अपनी पुष्टि के बाद ही पास करता है।
- जो कमांड्स सीक्रेट की का उपयोग करती हैं वह gpg को `--no-tty` के साथ चलाती हैं, इसलिए gpg कभी टर्मिनल खोलने की कोशिश नहीं करता। पासफ्रेज़ pinentry विंडो से आता है, सिवाय `generate --passphrase-stdin` के।
- `generate` gpg-agent को `pinentry-gtk` इस्तेमाल करने के लिए बनाता है। यह लाइन `# BEGIN argvus-managed pinentry` और `# END argvus-managed pinentry` मार्करों के बीच लिखता है, बाकी `gpg-agent.conf` को बनाए रखता है, और पिछली फ़ाइल को `gpg-agent.conf.bak` के रूप में सहेजता है। जब ब्लॉक पहले से ही `pinentry-gtk` को नामित करता है, तो फ़ाइल और gpg-agent वैसे ही रहते हैं। यह कमांड तब चलाने से इंकार कर देता है जब `gpg-agent.conf` पहले से ही उस ब्लॉक के बाहर `pinentry-program` सेट करता है, ताकि दो मान कभी टकराएँ नहीं।
- पैकेज स्थापित करना कभी भी `~/.gnupg` में लिखता नहीं है। कॉन्फ़िगरेशन केवल तब बदलता है जब कोई कुंजी उत्पन्न होती है।
- `GNUPGHOME`, जो परीक्षण के लिए उपयोगी है, `~/.gnupg` की जगह लेता है।

`gnupg` और `pinentry` आवश्यक निर्भरता हैं: कुंजी आदेशों को gpg की आवश्यकता होती है, और पासफ़्रेज़ विंडो `pinentry-gtk` है।

| Symptom | Cause and fix |
| --- | --- |
| `generate`पासफ़्रेज़ विंडो नहीं खोलता | जाँच करें`argvus gpg status`. `pinentry-gtk`को स्थापित किया जाना चाहिए, और सत्र को उजागर करना चाहिए`WAYLAND_DISPLAY` or `DISPLAY`. |
| `generate`रिपोर्ट करता है कि`pinentry-gtk`स्थापित नहीं है | स्थापित करें `pinentry` package. |
| `generate` reports a `pinentry-program`ARGVUS ब्लॉक के बाहर की पंक्ति | उस पंक्ति को हटा दें`~/.gnupg/gpg-agent.conf`, फिर कमांड को फिर से चलाएँ। |
| `generate`रिपोर्ट करता है कि कुंजी का आकार समर्थित नहीं है | एल्गोरिथम के लिए आकार की जाँच करें: DSA 3072 बिट्स पर रुकता है। |
| `generate`रिपोर्ट करता है कि एन्क्रिप्शन सबकी को जोड़ा नहीं जा सका | कुंजी बनाई गई थी। सबकी जोड़ें `gpg --quick-add-key FINGERPRINT cv25519 encr 2y`, या कुंजी को हटा दें `gpg --delete-secret-and-public-key`और इसे फिर से उत्पन्न करें। |
| `import`फ़ाइल अस्वीकार करता है | फ़ाइल में एक निजी कुंजी शामिल है। दूसरी मशीन पर केवल सार्वजनिक कुंजी निर्यात करें`argvus gpg export-public`. |
| `list`कोई चाबियाँ नहीं दिखाती | चाबी का गुच्छा में`GNUPGHOME` (or `~/.gnupg`) खाली है। चलाएँ `argvus gpg generate`एक कुंजी बनाने के लिए। |

## स्निपेट्स (`SUPER + ALT + N`)

`SUPER + ALT + N` आपके स्निपेट्स के साथ एक पिकर खोलता है। चयनित स्निपेट को फोकस किए गए विंडो में, कर्सर पर टाइप किया जाता है, क्लिपबोर्ड के माध्यम से जाने के बजाय।

### Setup

एक स्निपेट जोड़ें जिसमें नाम और उसका टेक्स्ट हो:

```sh
argvus snippets add "email" "you@example.com"
```

जांचें कि यह संग्रहीत हुआ था:

```sh
argvus snippets list
```

स्निपेट्स को argvus config के `snippets` सेक्शन में  `argvus config` `{name, content}` प्रविष्टियों के रूप में रखा जाता है। आप उन्हें `argvus config get /snippets/items` के साथ पढ़ सकते हैं।

### Use

1. उस एप्लिकेशन के टेक्स्ट फ़ील्ड पर क्लिक करें जिसे टेक्स्ट प्राप्त करना चाहिए।
2. Press `SUPER + ALT + N`.
3. नाम से स्निपेट का चयन करें और `Enter` दबाएं। टेक्स्ट उस स्थान पर टाइप किया जाता है जहां कर्सर है।

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

- नाम अद्वितीय और केस-संवेदी होते हैं। किसी मौजूदा नाम के साथ एक स्निपेट जोड़ने से इसकी सामग्री बदल जाती है।
- सामग्री खाली नहीं हो सकती: एक खाली स्निपेट को नहीं मिलने के रूप में रिपोर्ट किया जाता है।
- `open` केवल अंकों से बने नाम को स्थिति के रूप में मानता है। अस्पष्टता से बचने के लिए अक्षरों वाले नामों का उपयोग करें, जैसे `code2`।
- एक पद का अर्थ है वह क्रम जो `list` द्वारा दिखाया गया है। किसी स्निपेट को हटाने से उसके बाद वाले पदों की स्थिति बदल जाती है।

### Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| शॉर्टकट दबाने पर "कोई स्निपेट नहीं" सूचना | अभी तक कोई स्निपेट जोड़ा नहीं गया है। चलाएँ`argvus snippets add` first. |
| `open`रिपोर्ट करता है कि स्निपेट नहीं मिला | नाम बिल्कुल मेल नहीं खाता। तुलना करें`argvus snippets list`. |
| एप्लिकेशन में कुछ भी दिखाई नहीं देता | केंद्रित विंडो एक टेक्स्ट फ़ील्ड नहीं है, या यह XWayland के अंतर्गत चल रहा एक X11 एप्लिकेशन है, जो इस तरह के इनपुट को अनदेखा कर सकता है। नेटिव वेल्लैंड एप्लिकेशन के साथ परीक्षण करें। |

को `wtype`, `rofi`, `jq` और `argvus` (`argvus config` कमांड) की आवश्यकता होती है।

`wtype` वेइलैंड इनपुट स्तर पर कुंजी दबावों का अनुकरण करता है। कुछ X11 एप्लिकेशन जो XWayland के तहत चल रहे हैं, इन घटनाओं की अनदेखी करते हैं, इसलिए टेक्स्ट वहां दिखाई नहीं दे सकता भले ही स्निपेट मिला हो।

## गिट (`SUPER + ALT + G`)

`SUPER + ALT + G` `SUPER + O` के समान प्रोजेक्ट पिकर खोलता है। किसी प्रोजेक्ट को चुनने से सीधे इसमें `lazygit` (या `gitui`) खुल जाता है, वर्तमान वर्कस्पेस में एक नए ARGVUS टर्मिनल में। पहले प्रोजेक्ट चुनने का अलग चरण नहीं है।

### Setup

दो टूल्स में से एक स्थापित करें। दोनों इस पैकेज की ऐच्छिक निर्भरताएँ हैं:

```sh
sudo pacman -S lazygit   # or: sudo pacman -S gitui
```

### Use

1. Press `SUPER + ALT + G`.
2. सूची में से कोई प्रोजेक्ट चुनें, या रद्द करने के लिए `Esc` दबाएं। रद्द करने पर कुछ भी नहीं खुलता।
3. टर्मिनल प्रोजेक्ट डायरेक्टरी में खुलता है और TUI शुरू करता है।

एक प्रोजेक्ट जो git रिपॉजिटरी नहीं है, एक नोटिफिकेशन दिखाता है और कुछ भी नहीं खोलता। पिकर को छोड़ने के लिए, एक डायरेक्टरी पास करें:

```sh
argvus git ~/Projects/api
```

### उपकरण चुनना

जब यह स्थापित होता है, तो `argvus-git` `lazygit` का उपयोग करता है, और अन्यथा `gitui` का। `gitui` को प्राथमिकता देने के लिए, इस कमांड के लिए `ARGVUS_GIT_TUI` सेट करें:

```sh
ARGVUS_GIT_TUI=gitui argvus git
```

। इस वेरिएबल को उस कमांड के पर्यावरण से पढ़ा जाता है जो स्क्रिप्ट चलाता है। इसे ARGVUS कॉन्फ़िगरेशन में संग्रहीत नहीं किया जाता।\n

### Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| सूचना "गिट रिपॉजिटरी नहीं है" | चुना हुआ प्रोजेक्ट एक गिट रिपॉजिटरी नहीं है, या इसकी डायरेक्टरी को स्थानांतरित किया गया था। इसे हटाएं या ठीक करें `argvus projects remove`. |
| सूचना "lazygit या gitui इंस्टॉल करें" | इनमें से कोई भी टूल मौजूद नहीं है`PATH`. इनमें से किसी एक को इंस्टॉल करें। |
| चयनकर्ता कोई परियोजनाएँ नहीं दिखाता | कोई परियोजना जोड़ी नहीं गई। उपयोग करें `argvus projects add`. |

## इमोजी पिकर (`SUPER + .`)\n

`SUPER + .` ARGVUS Rofi कॉन्फ़िगरेशन के साथ `rofimoji` खोलता है। नाम से एक इमोजी खोजें, `Enter` दबाएँ, और इमोजी क्लिपबोर्ड में कॉपी हो जाएगा। इसे उस एप्लिकेशन में `Ctrl + V` के साथ पेस्ट करें जिसे आप चाहते हैं।

जब पिकर खुला होता है, सत्र उस कीबोर्ड-लेआउट सूचनाओं की अनदेखी करता है जो यह अन्यथा दिखाता। लॉन्चर ARGVUS कैश निर्देशिका में एक अल्पकालिक मार्कर लिखता है और पिकर बंद होने के लगभग एक सेकंड बाद इसे हटा देता है।

को `rofimoji` और `wl-clipboard` की आवश्यकता है।

## कैलकुलेटर (`SUPER + C`)

`SUPER + C` ARGVUS Rofi कॉन्फ़िगरेशन के साथ Rofi का `calc` मोड खोलता है। एक अभिव्यक्ति टाइप करें, और जैसे ही आप टाइप करते हैं परिणाम सूची अपडेट होती है। `rofi-calc` मोड के अनुसार एक परिणाम चुनें।

लॉन्चर पैकेज Rofi कॉन्फ़िगरेशन प्रदान करता है और `rofi-calc` पर निर्भर करता है। शॉर्टकट स्वयं `argvus-hyprland` द्वारा घोषित किया गया है।

## चीटशीट्स (`SUPER + SHIFT + /` और `SUPER + CTRL + /`)

`cheatsheets.sh` एक बड़े Rofi विंडो में शॉर्टकट्स की केवल-पढ़ने योग्य सूची दिखाता है। यह अपना तर्क के रूप में एप्लिकेशन का नाम लेता है:

```sh
cheatsheets.sh hypr     # Hyprland shortcuts (SUPER + SHIFT + /)
cheatsheets.sh kitty    # terminal shortcuts (SUPER + CTRL + /)
cheatsheets.sh <name>   # any other application with a cheatsheet
```

- `hypr` उपयोगकर्ता की ARGVUS कॉन्फ़िगरेशन से `data/generated/hypr/keybindings.txt` का उपयोग करता है जब वह फ़ाइल मौजूद हो। अन्यथा यह `argvus-hyprland` के साथ शिप किए गए Hyprland चीटशीट का उपयोग करता है।
- `kitty` `argvus` के साथ भेजी गई टर्मिनल चीटशीट का उपयोग करता है।
- किसी अन्य नाम से `<name>/docs/cheatsheets/<language>.txt` पढ़ता है। यदि वह फ़ाइल मौजूद नहीं है, तो कोई विंडो नहीं खुलती।

जब सिस्टम लोकल `pt-BR` होता है तो भाषा पुर्तगाली होती है, अन्यथा अंग्रेज़ी होती है। `Esc` विंडो बंद करता है। किसी पंक्ति का चयन केवल उसे बंद करता है; कुछ भी निष्पादित नहीं होता।

## अन्य मेनू जो Rofi कॉन्फ़िगरेशन का उपयोग करते हैं

लॉन्चर कॉन्फ़िगरेशन अन्य पैकेजों के स्वामित्व वाले घटकों के साथ साझा किया गया है:

- क्लिपबोर्ड इतिहास (`SUPER + H`) और इसका साफ़ शॉर्टकट (`SUPER + SHIFT + H`) को `argvus-hyprland` द्वारा घोषित किया गया है। वे `cliphist` को इस कॉन्फ़िगरेशन के साथ Rofi में भेजते हैं। `cliphist`, `argvus-session` से आता है, जो क्लिपबोर्ड रिकॉर्डर चलाता है जो इतिहास को भरता है; `argvus` मेटा-पैकेज भी इस पर निर्भर करता है।
- `argvus-appearance` में थीम, एक्सेंट और लेआउट पिकर `config.rasi` के साथ Rofi खोलते हैं।
- Hyprland विंडो नियम `argvus-launcher` और `rofi` नामस्थान को पहचानते हैं, इसलिए मेन्यू लांचर सरफेस ट्रीटमेंट प्राप्त करते हैं।

## पैकेजिंग और निर्भरताएँ

पैकेज `argvus-launcher` आर्किटेक्चर-निर्भर नहीं है और इंस्टॉल करता है:

- `argvus launcher`, `argvus-snippets`, `argvus-ssh` और `argvus-git`, एक ही निर्देशिका के अंतर्गत;
- `/usr/share/argvus/launcher/config/`, Rofi कॉन्फ़िगरेशन और थीम्स के साथ;
- `/usr/share/argvus/launcher/sh/`, `cheatsheets.sh` और `emoji-picker.sh` के साथ।

आवश्यक निर्भरताएँ: `argvus-session`, `argvus-appearance`, `argvus`, `bash`, `jq`, `hyprland`, `libnotify`, `rofi`, `rofi-calc`, `rofimoji`, `wl-clipboard`, `wtype`, `gnupg` और `pinentry` (जो `pinentry-gtk` प्रदान करता है)। वैकल्पिक निर्भरताएँ: `openssh`, SSH पिकर और SSH की मैनेजर के लिए; `lazygit` और `gitui`, git TUI के लिए।

पैकेज इंस्टॉल करने से `$HOME` में कोई लेखन नहीं होता है। उपयोगकर्ता कॉन्फ़िगरेशन सत्र प्रारंभ में बनाया जाता है, जैसा कि [Rofi कॉन्फ़िगरेशन और थीम्स](#where-the-active-configuration-lives) में वर्णित है।

## Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| `SUPER + D`कुछ भी नहीं खोलता | जाँच करें`argvus launcher`एक टर्मिनल में। पुष्टि करें कि`rofi`संस्थापित है और Rofi कॉन्फ़िगरेशन मौजूद है। |
| `SUPER + D`कोई आवेदन सूचीबद्ध नहीं है | इन आवेदनों का डेस्कटॉप एंट्री नहीं है। केवल वे आवेदन जिनके पास`.desktop`फ़ाइल दिखाई जाती है। |
| मेनू पुराने फॉन्ट का उपयोग करते हैं | `font:`सत्र प्रारंभ में लाइन को फिर से लिखा जाता है। फ़ॉन्ट बदलने के बाद सत्र को पुनः प्रारंभ करें। |
| थीम परिवर्तन Rofi मेनू तक नहीं पहुंचता | जांचें कि उपयोगकर्ता प्रति की `config.rasi` in `$XDG_CONFIG_HOME/argvus/data/rofi/`अभी भी पैक किए गए थीम की ओर इशारा करता है। थीम को से लागू करें`argvus-appearance` again. |
| `SUPER + O`रिपोर्ट करता है कि कोई परियोजनाएँ नहीं मिलीं | कोई रूट या पथ कॉन्फ़िगर नहीं है, या निर्देशिकाएँ अब मौजूद नहीं हैं। चलाएँ`argvus projects list`. |
| `SUPER + C`या इमोजी पिकर नहीं खुलता | इंस्टॉल करें`rofi-calc` or `rofimoji` (दोनों आवश्यक निर्भरता हैं)। |
| एक चीटशीट नहीं खुलती | उस नाम और भाषा के लिए फ़ाइल मौजूद नहीं है। चीटशीट्स अनुभाग में वर्णित पथों की जाँच करें। |
| `SUPER + H`कुछ भी नहीं दिखाता | इतिहास खाली है, या क्लिपबोर्ड रिकॉर्डर से `argvus-session`ने अभी तक कुछ भी संग्रहित नहीं किया है। |

## संबंधित घटक

| Component | Responsibility |
| --- | --- |
| `argvus-hyprland` | मेनू के लिए शॉर्टकट और Hyprland विंडो नियम घोषित करता है। |
| `argvus-appearance`| सक्रिय थीम, उच्चारण और लेआउट को बदलता है, और Rofi थीम संदर्भों को पुनः लिखता है। |
| `argvus` (`argvus config`) | परियोजनाओं, स्निपेट्स और डिफ़ॉल्ट लॉन्चर सेटिंग को स्टोर करता है। |
| `argvus-session`| प्रारंभिक Rofi कॉन्फ़िगरेशन की प्रतियां बनाता है और सत्र की शुरुआत में इसका फ़ॉन्ट सेट करता है। |
| `argvus` (`argvus terminal`) | SSH सत्र, प्रोजेक्ट टर्मिनल और पासफ्रेज़ प्रॉम्प्ट खोलता है`argvus keys`. |
| `argvus` (`argvus widget-telemetry`) | Reads the active project written by `argvus projects`. |
| `argvus` (`argvus i18n`) | लॉन्चर स्क्रिप्ट्स द्वारा उपयोग किए जाने वाले अनुवादित संदेश प्रदान करता है। |
| `argvus` (`argvus control-center`) | Edits the project list through `argvus projects`. |
