---
title: Anwendungsstarter
description: Starten Sie Anwendungen, öffnen Sie Projekte, SSH-Hosts und Snippets, wählen Sie Emoji aus, berechnen Sie und lesen Sie Spickzettel über die ARGVUS Rofi-Menüs.
---
`argvus-launcher` stellt die Rofi-Konfiguration, Themen und Menüs bereit, die ARGVUS verwendet, um Dinge über die Tastatur zu öffnen. Es enthält:

- den Anwendungsstarter (`SUPER + D`);
- die Rofi-Konfiguration und Themen, die von jedem ARGVUS Rofi-Menü gemeinsam genutzt werden;
- den Projektschalter, SSH-Auswähler und Snippet-Auswähler (`argvus projects`, `argvus ssh`, `argvus snippets`);
- den SSH-Schlüsselmanager (`argvus keys`), der Schlüsselpaar erstellt, auflistet, lädt und löscht;
- den GPG-Schlüsselmanager (`argvus gpg`), der Schlüssel auflistet, erstellt und exportiert und pinentry-gtk für gpg-agent einrichtet;
- den Emoji-Auswähler, den Cheatsheet-Betrachter und das Taschenrechner-Menü.

Die Tastenkombinationen werden von `argvus-hyprland` deklariert. Dieses Paket stellt die Befehle und die dahinterliegenden Menüs bereit.

## Tastenkombinationen

| Shortcut | Aktion | Befehl | Abschnitt |
| --- | --- | --- | --- |
| `SUPER + D` | Anwendungsstarter | `argvus launcher` | Anwendungsstarter |
| `SUPER + O` | Projektwechsler | `argvus projects` | Projektwechsler |
| `SUPER + ALT + 1` bis `9` | Öffne das Projekt an dieser Position | `argvus projects open N` | Projektwechsler |
| `SUPER + ALT + S` | SSH-Host-Auswahl | `argvus ssh` | SSH |
| `SUPER + ALT + N` | Snippet-Auswahl | `argvus snippets` | Snippets |
| `SUPER + ALT + G` | Projekt-Auswahl, dann Git TUI | `argvus git` | Git |
| `SUPER + .` | Emoji-Auswahl | `emoji-picker.sh` | Emoji-Auswahl |
| `SUPER + C` | Taschenrechner | `rofi -show calc` | Taschenrechner |
| `SUPER + SHIFT + /` | Hyprland-Spickzettel | `cheatsheets.sh hypr` | Spickzettel |
| `SUPER + CTRL + /` | Kitty-Spickzettel | `cheatsheets.sh kitty` | Spickzettel |

## Anwendungsstarter (`SUPER + D`)

`SUPER + D` startet `argvus launcher`, das Rofi im `drun`-Modus öffnet. Es listet die mit einem Desktop-Eintrag installierten grafischen Anwendungen auf, und die ausgewählte Anwendung startet, wenn Sie `Enter` drücken.

1. Drücken Sie `SUPER + D`.
2. Geben Sie einen Teil des Anwendungsnamens ein. Die Liste ist sortiert und der Filter ignoriert Groß-/Kleinschreibung.
3. Drücken Sie `Enter`, um die Anwendung zu starten, oder `Esc`, um das Menü zu schließen.

```sh
argvus launcher                  # opens the application menu
argvus launcher --config PATH    # uses another Rofi configuration file
```
Jedes andere Argument wird an `rofi` übergeben. `--config` ohne einen Wert stoppt mit einem Fehler.

Hyprland führt `argvus launcher --config <Rofi configuration>` aus, wenn der Standardschnellstarter `rofi` ist, was die Standardeinstellung ist. Wenn der Standard-`launcher` in den Standardanwendungen auf ein anderes Programm gesetzt wird, führt Hyprland stattdessen `<program> --show drun` aus. Legen Sie es in den Standardanwendungen des Kontrollzentrums fest, welches den Wert in `argvus-config` speichert.

Nur Anwendungen mit einer Desktop-Eintragung erscheinen in der Liste. Eine Anwendung, die keine `.desktop`-Datei installiert, kann hier nicht gefunden werden.

## Rofi-Konfiguration und Themes

Das Paket installiert die Rofi-Konfiguration unter `/usr/share/argvus/launcher/config/`:

| Datei | Rolle |
| --- | --- |
| `config.rasi` | Einstiegspunkt, der von jedem ARGVUS-Menü verwendet wird. Setzt das Rofi `configuration` (Schriftart, keine Symbole, sortierte Liste, Groß-/Kleinschreibung wird ignoriert) und importiert `theme.rasi`. |
| `theme.rasi` | Farben und Layout des Fensters, der Eingabeleiste und der Liste. Importiert ein Thema und die Modusdatei. |
| `mode.rasi` | Modusüberschreibung. Die mitgelieferte Datei hat keine Überschreibungen und behält den Dunkelmodus bei. |
| `themes/<family>/theme.rasi` | Palette einer Themenfamilie, zum Beispiel `argvus-dark` oder `tokyo-night`. |
| `themes/<family>-spaced/theme.rasi` | Abstandsversion derselben Familie. |

Das Paket stellt 22 Familien bereit, und jede hat eine `-spaced`-Variante. Das gepackte `theme.rasi` importiert `argvus-dark`.

### Wo die aktive Konfiguration lebt

ARGVUS löst jede Rofi-Datei über `paths_config` auf. Die erste existierende Datei unter den Benutzerüberschreibungen, der Benutzerkopie, den Legacy-Standorten und dem generierten Baum gewinnt; andernfalls wird die verpackte Datei unter `/usr/share/argvus/launcher/config/` verwendet. Die Benutzerkopie einer Datei ist `$XDG_CONFIG_HOME/argvus/data/rofi/<file>`: das Präfix `launcher/config/` wird unter `rofi/` gespeichert.

ARGVUS erstellt eine Benutzerkopie zum ersten Mal, wenn ein ARGVUS-Skript diese Datei ändert; `argvus-appearance` macht dies für Theme-, Akzent- und Modusänderungen. Dateien, die nie geändert wurden, werden weiterhin aus dem Paket gelesen, und eine Benutzerkopie hat Vorrang vor der verpackten Datei.

Wenn `argvus-session` die Schriftart beim Sitzungsstart anwendet, schreibt es die `font:`-Zeile von `config.rasi` aus der ARGVUS-Schriftart-Einstellung um. Diese Bearbeitung betrifft nur die Benutzerkopie. Bis die Kopie existiert, ist die gepackte Datei diejenige, die gefunden wird, und die Benutzer können sie nicht beschreiben, sodass die Schriftartänderung in Kraft tritt, sobald die erste Erscheinungsänderung die Kopie erstellt hat.

### Wechseln des Themas

`argvus-appearance` besitzt Themenänderungen. Wenn sich das Thema ändert, schreibt es die Benutzerkopien so um, dass `config.rasi` auf das neue `theme.rasi` zeigt, und `theme.rasi` importiert die Launcher-Palette des Themen-Builds (`~/.config/argvus/data/generated/theme/current/launcher/theme.rasi`), die die aktive Familie, das Layout und die Akzentfarbe enthält. Ohne einen Themen-Build importiert es die Familienkopie, und das Spaced-Layout wählt die `-spaced`-Variante der aktiven Familie. Themenwähler wie das Themenmenü und das Layoutmenü lesen dasselbe `config.rasi`, sodass sie auch den aktiven Stil verwenden.

Bearbeiten Sie die Dateien unter `/usr/share/argvus/launcher/` nicht; sie werden bei einem Paket-Upgrade ersetzt. Nehmen Sie Änderungen in der Benutzerkopie unter `$XDG_CONFIG_HOME/argvus/data/rofi/` vor.

## Projektwechsler (`SUPER + O`)

`argvus projects` (`SUPER + O`) listet die Projekte auf, die Sie hinzugefügt haben, und öffnet das ausgewählte Projekt in seinem eigenen Hyprland-Arbeitsbereich, mit einem `argvus terminal` in seinem Verzeichnis. Wenn der Arbeitsbereich des Projekts bereits existiert, fokussiert der Wechseler nur diesen.

Für die ausschließliche Tastaturnavigation, `SUPER + ALT + 1` bis `SUPER + ALT + 9` öffnen das Projekt an dieser Position der Liste, ohne das Menü. Die Positionen sind die im Menü angezeigten Zahlen. Sie folgen der Reihenfolge der Liste, sodass das Hinzufügen oder Entfernen eines Projekts diese ändern kann. `argvus projects open <number or directory name>` macht dasselbe über ein Terminal, und Fehler werden als Benachrichtigung angezeigt.

Die effektive Projektliste ist auf 9 begrenzt, da dies alles ist, was `SUPER + ALT + 1..9` adressieren kann. `argvus projects add` (und die Projektseite des Kontrollzentrums, die sie aufruft) verweigert es, ein Projekt oder Root hinzuzufügen, das die Gesamtzahl über 9 erhöhen würde, und meldet stattdessen den Fehler.

Ein Projekt stammt aus zwei Orten im Abschnitt `projects` von `argvus-config`:

- `paths`: individuelle Projektverzeichnisse.
- `roots`: Verzeichnisse, deren unmittelbare Unterverzeichnisse Projekte sind. Ein Root, das nicht existiert, wird ignoriert.

Standardmäßig ist kein Root oder Pfad konfiguriert; fügen Sie mindestens einen hinzu, bevor `SUPER + O` etwas auflisten kann.

Verwalten Sie sie von einem Terminal aus:

```sh
argvus projects add ~/Work/api          # one project
argvus projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus projects remove ~/Work/api       # removes it from paths and roots
argvus projects list                    # prints the roots and paths
```
`argvus projects pick` zeigt dieselbe Liste an und druckt den gewählten Pfad, anstatt ihn zu öffnen. Andere Werkzeuge können es verwenden, wie `argvus git` es tut. Abbrechen druckt nichts.

Wenn kein Root oder Pfad existiert, meldet `SUPER + O`, dass keine Projekte gefunden wurden. Ein optionaler Editor-Befehl, `/projects/editor`, startet im selben Arbeitsbereich, wenn der Arbeitsbereich erstellt wird.

Die Einträge werden aus der effektiven Konfiguration gelesen; der Launcher behält keine Kopie davon.

Das Öffnen eines Projekts zeichnet auch seinen Pfad als aktives Projekt für die Sitzung auf, das der Dev Dashboard-Telemetrieblock (`argvus widget-telemetry`) liest, um die Git-, Listening-Ports und Container dieses Projekts zu melden.

## SSH („SUPER + ALT + S“)

`SUPER + ALT + S` öffnet einen Picker mit den Hosts, die in `~/.ssh/config` definiert sind. Der ausgewählte Host öffnet sich in einem neuen ARGVUS-Terminal, das `ssh <host>` im aktuellen Arbeitsbereich ausführt.

### Einrichtung

Fügen Sie einen `Host`-Eintrag für jeden Server zu `~/.ssh/config` hinzu:

```ini
Host myhost
    HostName myhost.local
    User boss
    IdentityFile ~/.ssh/myhost
    IdentitiesOnly yes
```
Bestätigen Sie zuerst, dass `ssh myhost` in einem normalen Terminal funktioniert. Der Launcher führt nur `ssh` aus; Authentifizierung, Schlüssel und Host-Verifizierung werden von OpenSSH übernommen.

### Verwendung

1. Drücken Sie `SUPER + ALT + S`.
2. Geben Sie einen Teil des Hostnamens ein oder verwenden Sie die Pfeiltasten.
3. Drücken Sie `Enter`. Das Terminal öffnet sich und führt `ssh <host>` aus.

Wenn die Sitzung endet, bleibt das Fenster geöffnet und zeigt den Exit-Status an, zum Beispiel `ssh exited with status 0. Press Enter to close.`. Drücken Sie `Enter`, um es zu schließen. Dies ist wichtig für Plattformen wie GitHub, GitLab und Gitea: Sie authentifizieren Sie und schließen die Verbindung sofort, weil sie keine Shell bereitstellen. Das Fenster zeigt stattdessen ihre Nachricht auf dem Bildschirm an, anstatt zu verschwinden.

### Regeln

- Platzhalter-Einträge (`Host *`, `Host *.internal`) sind Übereinstimmungsblöcke, keine Ziele, und werden niemals aufgelistet.
- Jeder Alias in einer `Host`-Zeile wird separat aufgelistet (`Host a b` listet `a` und `b`). Duplikate werden entfernt.
- Hosts, die nur in Dateien definiert sind, die mit `Include` geladen werden, werden nicht aufgelistet; der Auswähler liest nur die Hauptdatei.
- Nur Aliase, die aus Buchstaben, Ziffern, `.`, `-` und `_` bestehen, werden gestartet. Jeder andere Name wird mit einer Benachrichtigung abgelehnt.
- Windows-Zeilenenden (CRLF) in der Konfiguration werden akzeptiert.
- `ARGVUS_SSH_CONFIG` ersetzt den Pfad der Konfigurationsdatei, was für Tests nützlich ist.

### Befehle

```sh
argvus ssh list          # prints the configured hosts, one per line
argvus ssh open myhost   # opens a specific host without the picker
```
### Fehlerbehebung

| Symptom | Ursache und Lösung |
| --- | --- |
| Benachrichtigung "Keine Hosts in ~/.ssh/config gefunden" | Die Datei fehlt oder enthält keine `Host`-Zeilen. Führen Sie `argvus ssh list` aus, um dies zu überprüfen. |
| Ein Host fehlt im Auswahldialog | Es ist ein Platzhalter, stammt aus einer `Include`-Datei oder enthält Zeichen außerhalb des erlaubten Bereichs. Legen Sie ihn in der Hauptdatei mit einem einfachen Alias ab. |
| Das Fenster zeigt sofort einen Fehlerstatus an | Führen Sie `ssh <host>` in einem normalen Terminal aus, um die vollständige Meldung zu sehen (unerreichbarer Host, falscher Schlüssel usw.). |
| Das Fenster zeigt `message.ssh_session_ended` statt Text an | Das installierte `argvus`-Paket ist älter als diese Version. Aktualisieren Sie `argvus`. |

Erfordert `openssh` und `argvus` (der `argvus terminal`-Befehl).

## SSH-Schlüssel (`argvus keys`)

`argvus keys` verwaltet die Schlüsselpaaren in `~/.ssh` und die vom ssh-agent gehaltenen Schlüssel. Es gibt keine Tastenkombination. Die **SSH-Schlüssel**-Seite des Control Centers (Anwendungen) verwendet die gleichen Befehle.

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
Regeln, die für jeden Befehl gelten:

- Ein Schlüsselname wird unter `~/.ssh` zu einem Dateinamen, daher darf er nur Buchstaben, Ziffern, Punkt, Bindestrich und Unterstrich enthalten. Er darf nicht mit einem Punkt beginnen oder mit `.pub` enden. Ein bestehendes Paar wird niemals überschrieben.
- Nur Paare mit einer öffentlichen Datei (`NAME.pub`) werden aufgelistet, und nur diese können geladen, entladen oder gelöscht werden.
- Passphrasen werden niemals als Befehlsargumente übergeben, in ein Protokoll geschrieben oder im Kontrollzentrum angezeigt. `load` und `generate --passphrase` öffnen ein ARGVUS-Terminal, und OpenSSH liest das Geheimnis von diesem Terminal.
- `list` meldet `unknown` in der Spalte `loaded`, wenn der Agent nicht erreichbar ist. Er rät niemals.
- `delete` entfernt den privaten Schlüssel endgültig. Bewahren Sie eine Kopie jedes Schlüssels auf, den Sie noch benötigen.
- `ARGVUS_SSH_DIR` ersetzt `~/.ssh`, was für Tests nützlich ist.

Der Agent ist der `argvus-ssh-agent.service`-Benutzerservice, der von `argvus-session` gestartet wird. `SSH_AUTH_SOCK` verweist in der Sitzung darauf.

Erfordert `openssh` (`ssh-keygen` und `ssh-add`) und `argvus` (den Befehl `argvus terminal`).

| Symptom | Ursache und Lösung |
| --- | --- |
| `load` öffnet ein Terminal, aber der Schlüssel ist nicht geladen | Geben Sie die Passphrase in diesem Terminal ein. Wenn nicht danach gefragt wird, führen Sie `ssh-add -l` aus, um zu sehen, was der Agent hält. |
| Das Terminal zeigt `Could not open a connection to your authentication agent` | Hyprland wurde vor dem Agenten gestartet, daher fehlen seinen Terminals `SSH_AUTH_SOCK`. Der Launcher fällt auf `$XDG_RUNTIME_DIR/ssh-agent.socket` zurück, daher aktualisieren Sie `argvus-launcher` und öffnen ein neues Terminal. |
| `list` zeigt `unknown` in der `loaded`-Spalte an | Der Agent ist nicht erreichbar. Überprüfen Sie `systemctl --user status argvus-ssh-agent.service` und die `SSH_AUTH_SOCK`-Variable. |
| `delete` meldet, dass der Schlüssel geladen ist | Führen Sie zuerst `argvus keys unload NAME` aus und löschen Sie ihn dann wieder. |
| `generate` meldet, dass der Name bereits existiert | Wählen Sie einen anderen Namen. Bestehende Paare werden niemals ersetzt. |

## GPG-Schlüssel (`argvus gpg`)

`argvus gpg` listet, erstellt und exportiert GPG-Schlüssel und importiert öffentliche Schlüssel. gpg-agent verwendet immer `pinentry-gtk`: ARGVUS schreibt diese pinentry in `gpg-agent.conf`, bevor es einen Schlüssel erzeugt. Es hat keine Abkürzung. Die Seite **GPG-Schlüssel** des Kontrollzentrums verwendet dieselben Befehle.

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
`generate` nimmt diese Optionen an:

- `--algo rsa|dsa` wählt den Schlüsselalgorithmus. Standard ist `rsa`.
- `--bits` wählt die Schlüssellänge. RSA akzeptiert `1024`, `2048`, `3072` und `4096`, wobei `4096` der Standard ist. DSA akzeptiert `1024`, `2048` und `3072`, wobei `2048` der Standard ist; gpg kann keine größeren DSA-Schlüssel erzeugen, daher wird `4096` abgelehnt, bevor gpg ausgeführt wird.
- `--expire` nimmt `0` für kein Ablaufdatum, eine Zahl gefolgt von `d`, `w`, `m` oder `y` (zum Beispiel `2y`) oder ein ISO-Datum `YYYY-MM-DD`, das ein echtes Datum sein muss.
- `--passphrase-stdin` liest die Passphrase aus der ersten Zeile der Standardeingabe. Das Control Center verwendet sie. Eine leere Zeile wird abgelehnt.
- `--no-passphrase --yes` erstellt einen ungeschützten Schlüssel. Die beiden Passphrasenmodi können nicht kombiniert werden.

Jeder Schlüssel erhält einen primären Key zum Zertifizieren und Signieren sowie einen Verschlüsselungs-Subkey, sodass er Dateien verschlüsseln sowie Commits und Pakete signieren kann. Der Subkey entspricht dem primären Schlüssel: `rsa` mit derselben Größe für RSA und `elg` mit derselben Größe für DSA, was der Pairing-Standard für DSA vorschreibt.

Regeln, die für jeden Befehl gelten:

- Passphrasen werden niemals als Befehlsargumente übergeben, in einem Protokoll geschrieben oder im Control Center angezeigt. Mit `--passphrase-stdin` geht die Passphrase über gpg auf Dateideskriptor 0 durch eine Pipe. Ohne diese Option fragt gpg im pinentry-Fenster, das `gpg-agent` öffnet.
- `--no-passphrase` speichert den privaten Schlüssel ohne Schutz. Dies wird abgelehnt, es sei denn, `--yes` wird ebenfalls angegeben.
- `import` lehnt jede Datei ab, die ein Packet eines geheimen Schlüssels enthält, in ASCII- oder Binärform. Private Schlüssel verlassen den Schlüsselbund nur über `export-private`, das `--yes` benötigt und im Schreibmodus `600` arbeitet; `import-private` holt sie zurück.
- Befehle, die Schlüssel ändern oder veröffentlichen (`export-private`, `delete`, `edit sign`, `edit revoke`, `keyserver send`), benötigen `--yes`. Das Kontrollzentrum gibt es nur nach eigener Bestätigung weiter.
- Befehle, die den geheimen Schlüssel verwenden, führen gpg mit `--no-tty` aus, sodass gpg niemals versucht, ein Terminal zu öffnen. Das Passwort wird aus dem pinentry-Fenster genommen, außer in `generate --passphrase-stdin`.
- `generate` veranlasst den gpg-agent, `pinentry-gtk` zu verwenden. Es schreibt diese Zeile zwischen den `# BEGIN argvus-managed pinentry`- und `# END argvus-managed pinentry`-Markern, behält den Rest von `gpg-agent.conf` und speichert die vorherige Datei als `gpg-agent.conf.bak`. Wenn der Block bereits `pinentry-gtk` benennt, bleiben die Datei und der gpg-agent unverändert. Der Befehl verweigert die Ausführung, wenn `gpg-agent.conf` bereits `pinentry-program` außerhalb dieses Blocks setzt, sodass zwei Werte niemals im Konflikt stehen.
- Die Installation des Pakets schreibt niemals in `~/.gnupg`. Die Konfigurationsänderungen erfolgen nur, wenn ein Schlüssel generiert wird.
- `GNUPGHOME` ersetzt `~/.gnupg`, was für Tests nützlich ist.

`gnupg` und `pinentry` sind erforderliche Abhängigkeiten: die Schlüsselbefehle benötigen gpg, und das Passwortfenster ist `pinentry-gtk`.

| Symptom | Ursache und Lösung |
| --- | --- |
| `generate` öffnet kein Passwortfenster | Überprüfen Sie `argvus gpg status`. `pinentry-gtk` muss installiert sein, und die Sitzung muss `WAYLAND_DISPLAY` oder `DISPLAY` bereitstellen. |
| `generate` meldet, dass `pinentry-gtk` nicht installiert ist | Installieren Sie das Paket `pinentry`. |
| `generate` meldet eine `pinentry-program`-Zeile außerhalb des ARGVUS-Blocks | Entfernen Sie diese Zeile aus `~/.gnupg/gpg-agent.conf` und führen Sie den Befehl erneut aus. |
| `generate` meldet, dass die Schlüssellänge nicht unterstützt wird | Überprüfen Sie die Länge für den Algorithmus: DSA endet bei 3072 Bit. |
| `generate` meldet, dass der Verschlüsselungsunter­schlüssel nicht hinzugefügt werden konnte | Der Schlüssel wurde erstellt. Fügen Sie den Unterschlüssel mit `gpg --quick-add-key FINGERPRINT cv25519 encr 2y` hinzu oder löschen Sie den Schlüssel mit `gpg --delete-secret-and-public-key` und erzeugen Sie ihn erneut. |
| `import` lehnt eine Datei ab | Die Datei enthält einen privaten Schlüssel. Exportieren Sie nur den öffentlichen Schlüssel auf dem anderen Rechner mit `argvus gpg export-public`. |
| `list` zeigt keine Schlüssel an | Das Schlüsselbund in `GNUPGHOME` (oder `~/.gnupg`) ist leer. Führen Sie `argvus gpg generate` aus, um einen Schlüssel zu erstellen. |

## Ausschnitte (`SUPER + ALT + N`)

`SUPER + ALT + N` öffnet einen Picker mit Ihren Ausschnitten. Der ausgewählte Ausschnitt wird in das fokussierte Fenster an der Cursorposition eingefügt, anstatt über die Zwischenablage zu gehen.

### Einrichtung

Fügen Sie einen Ausschnitt mit einem Namen und seinem Text hinzu:

```sh
argvus snippets add "email" "you@example.com"
```
Überprüfen Sie, ob es gespeichert wurde:

```sh
argvus snippets list
```
Snippets werden im Abschnitt `snippets` von `argvus config` als `{name, content}`-Einträge gespeichert. Sie können sie mit `argvus config get /snippets/items` lesen.

### Verwendung

1. Klicken Sie in das Textfeld der Anwendung, die den Text erhalten soll.
2. Drücken Sie `SUPER + ALT + N`.
3. Wählen Sie das Snippet nach Name aus und drücken Sie `Enter`. Der Text wird an der Cursorstelle eingegeben.

### Befehle

```sh
argvus snippets add "NAME" "CONTENT"   # adds a snippet, or replaces the one with the same name
argvus snippets remove NAME            # removes a snippet
argvus snippets list                   # prints index and name, one per line
argvus snippets open NAME              # types a snippet by name
argvus snippets open 2                 # types the snippet at position 2 of `list`
argvus snippets                        # opens the picker (same as the shortcut)
argvus snippets --help                 # shows the options and an example
```
### Regeln

- Namen sind einzigartig und unterscheiden zwischen Groß- und Kleinschreibung. Das Hinzufügen eines Snippets mit einem bereits vorhandenen Namen ersetzt dessen Inhalt.
- Der Inhalt darf nicht leer sein: Ein leeres Snippet wird als nicht gefunden gemeldet.
- `open` behandelt einen nur aus Ziffern bestehenden Namen als Position. Verwenden Sie Namen mit Buchstaben, z. B. `code2`, um Mehrdeutigkeiten zu vermeiden.
- Eine Position bezieht sich auf die durch `list` gezeigte Reihenfolge. Das Entfernen eines Snippets verschiebt die Positionen der danach folgenden.

### Fehlerbehebung

| Symptom | Ursache und Lösung |
| --- | --- |
| Benachrichtigung „keine Snippets“ beim Drücken der Tastenkombination | Es wurde noch kein Snippet hinzugefügt. Führen Sie zuerst `argvus snippets add` aus. |
| `open` meldet, dass das Snippet nicht gefunden wurde | Der Name stimmt nicht exakt überein. Vergleichen Sie mit `argvus snippets list`. |
| Es erscheint nichts in der Anwendung | Das fokussierte Fenster ist kein Textfeld oder es handelt sich um eine X11-Anwendung, die unter XWayland läuft und diese Art der Eingabe möglicherweise ignoriert. Testen Sie mit einer nativen Wayland-Anwendung. |

Erfordert `wtype`, `rofi`, `jq` und `argvus` (den Befehl `argvus config`).

`wtype` simuliert Tastendrücke auf der Wayland-Ebene der Eingabe. Einige unter XWayland laufende X11-Anwendungen ignorieren diese Ereignisse, sodass der Text dort möglicherweise nicht erscheint, selbst wenn das Snippet gefunden wurde.

## Git („SUPER + ALT + G“)

`SUPER + ALT + G` öffnet denselben Projekt-Picker wie `SUPER + O`. Die Auswahl eines Projekts öffnet `lazygit` (oder `gitui`) direkt darin, in einem neuen ARGVUS-Terminal auf dem aktuellen Arbeitsbereich. Es gibt keinen separaten Schritt, zuerst das Projekt auszuwählen.

### Einrichtung

Installieren Sie eines der beiden Werkzeuge. Beide sind optionale Abhängigkeiten dieses Pakets:

```sh
sudo pacman -S lazygit   # or: sudo pacman -S gitui
```
### Verwendung

1. Drücken Sie `SUPER + ALT + G`.
2. Wählen Sie ein Projekt in der Liste aus oder drücken Sie `Esc`, um abzubrechen. Ein Abbruch öffnet nichts.
3. Das Terminal öffnet sich im Projektverzeichnis und startet das TUI.

Ein Projekt, das kein Git-Repository ist, zeigt eine Benachrichtigung an und öffnet nichts. Um die Auswahl zu überspringen, geben Sie ein Verzeichnis an:

```sh
argvus git ~/Projects/api
```
### Auswahl des Werkzeugs

`argvus-git` verwendet `lazygit`, wenn es installiert ist, und `gitui` ansonsten. Um `gitui` zu bevorzugen, setzen Sie `ARGVUS_GIT_TUI` für den Befehl:

```sh
ARGVUS_GIT_TUI=gitui argvus git
```
Die Variable wird aus der Umgebung des Befehls gelesen, der das Skript ausführt. Sie wird nicht in der ARGVUS-Konfiguration gespeichert.

### Fehlerbehebung

| Symptom | Ursache und Lösung |
| --- | --- |
| Benachrichtigung „not a git repository“ | Das gewählte Projekt ist kein Git-Repository oder sein Verzeichnis wurde verschoben. Entfernen oder korrigieren Sie es mit `argvus projects remove`. |
| Benachrichtigung „install lazygit or gitui“ | Keines der Werkzeuge ist auf `PATH` vorhanden. Installieren Sie eines davon. |
| Picker zeigt keine Projekte | Es wurde kein Projekt hinzugefügt. Verwenden Sie `argvus projects add`. |

## Emoji-Auswahl (`SUPER + .`)

`SUPER + .` öffnet `rofimoji` mit der ARGVUS Rofi-Konfiguration. Suchen Sie ein Emoji nach Name, drücken Sie `Enter`, und das Emoji wird in die Zwischenablage kopiert. Fügen Sie es mit `Ctrl + V` in der Anwendung ein, die Sie verwenden möchten.

Während der Picker geöffnet ist, ignoriert die Sitzung die Tastaturlayout-Benachrichtigungen, die sie sonst anzeigen würde. Der Launcher schreibt ein kurzlebiges Marker im ARGVUS-Cache-Verzeichnis und entfernt es etwa eine Sekunde, nachdem der Picker geschlossen wurde.

Erfordert `rofimoji` und `wl-clipboard`.

## Rechner (`SUPER + C`)

`SUPER + C` öffnet den `calc`-Modus von Rofi mit der ARGVUS-Rofi-Konfiguration. Geben Sie einen Ausdruck ein, und die Ergebnisliste wird während der Eingabe aktualisiert. Wählen Sie ein Ergebnis aus, wie es der `rofi-calc`-Modus definiert.

Das Launcher-Paket stellt die Rofi-Konfiguration bereit und hängt von `rofi-calc` ab. Die Verknüpfung selbst wird von `argvus-hyprland` deklariert.

## Spickzettel (`SUPER + SHIFT + /` und `SUPER + CTRL + /`)

`cheatsheets.sh` zeigt eine schreibgeschützte Liste von Verknüpfungen in einem großen Rofi-Fenster an. Es nimmt den Anwendungsnamen als Argument:

```sh
cheatsheets.sh hypr     # Hyprland shortcuts (SUPER + SHIFT + /)
cheatsheets.sh kitty    # terminal shortcuts (SUPER + CTRL + /)
cheatsheets.sh <name>   # any other application with a cheatsheet
```

- `hypr` verwendet `data/generated/hypr/keybindings.txt` aus der ARGVUS-Konfiguration des Benutzers, wenn diese Datei existiert. Andernfalls wird das mit `argvus-hyprland` gelieferte Hyprland-Spickzettel verwendet.
- `kitty` verwendet das mit `argvus` gelieferte Terminal-Spickzettel.
- Jeder andere Name liest `<name>/docs/cheatsheets/<language>.txt`. Wenn diese Datei nicht existiert, wird kein Fenster geöffnet.

Die Sprache ist Portugiesisch, wenn das Systemgebietsschema `pt-BR` ist, und ansonsten Englisch. `Esc` schließt das Fenster. Das Auswählen einer Zeile schließt es nur; nichts wird ausgeführt.

## Andere Menüs, die die Rofi-Konfiguration verwenden

Die Launcher-Konfiguration wird mit Komponenten geteilt, die anderen Paketen gehören:

- Zwischenablage-Verlauf (`SUPER + H`) und seine Shortcut-Löschung (`SUPER + SHIFT + H`) werden von `argvus-hyprland` deklariert. Sie leiten `cliphist` mit dieser Konfiguration in Rofi ein. `cliphist` stammt von `argvus-session`, das den Zwischenablage-Rekorder ausführt, der den Verlauf füllt; das Meta-Paket `argvus` ist ebenfalls davon abhängig.
- Theme-, Akzent- und Layout-Auswahlen in `argvus-appearance` öffnen Rofi mit `config.rasi`.
- Die Hyprland-Fensterregeln erkennen die Namespaces `argvus-launcher` und `rofi`, sodass die Menüs die Launcher-Oberflächenbehandlung erhalten.

## Verpackung und Abhängigkeiten

Das Paket `argvus-launcher` ist architekturunabhängig und installiert:

- `argvus launcher`, `argvus-snippets`, `argvus-ssh` und `argvus-git` im gleichen Verzeichnis;
- `/usr/share/argvus/launcher/config/` mit der Rofi-Konfiguration und Themes;
- `/usr/share/argvus/launcher/sh/` mit `cheatsheets.sh` und `emoji-picker.sh`.

Erforderliche Abhängigkeiten: `argvus-session`, `argvus-appearance`, `argvus`, `bash`, `jq`, `hyprland`, `libnotify`, `rofi`, `rofi-calc`, `rofimoji`, `wl-clipboard`, `wtype`, `gnupg` und `pinentry` (welches `pinentry-gtk` bereitstellt). Optionale Abhängigkeiten: `openssh`, für den SSH-Auswähler und den SSH-Schlüsselmanager; `lazygit` und `gitui`, für die git-TUI.

Die Installation des Pakets schreibt nicht in `$HOME`. Die Benutzerkonfiguration wird beim Start der Sitzung erstellt, wie unter [Rofi-Konfiguration und Themen](#where-the-active-configuration-lives) beschrieben.

## Fehlerbehebung

| Symptom | Ursache und Lösung |
| --- | --- |
| `SUPER + D` öffnet nichts | Überprüfen Sie `argvus launcher` in einem Terminal. Bestätigen Sie, dass `rofi` installiert ist und die Rofi-Konfiguration existiert. |
| `SUPER + D` listet keine Anwendungen | Die Anwendungen haben keinen Desktop-Eintrag. Es werden nur Anwendungen mit einer `.desktop`-Datei angezeigt. |
| Die Menüs verwenden eine alte Schriftart | Die `font:`-Zeile wird beim Start der Sitzung neu geschrieben. Starten Sie die Sitzung nach dem Ändern der Schriftart neu. |
| Eine Designänderung erreicht die Rofi-Menüs nicht | Überprüfen Sie, ob die Benutzerkopie von `config.rasi` in `$XDG_CONFIG_HOME/argvus/data/rofi/` weiterhin auf das bereitgestellte Design zeigt. Wenden Sie das Design erneut von `argvus-appearance` an. |
| `SUPER + O` meldet, dass keine Projekte gefunden wurden | Kein Root oder Pfad ist konfiguriert oder die Verzeichnisse existieren nicht mehr. Führen Sie `argvus projects list` aus. |
| `SUPER + C` oder der Emoji-Picker öffnet sich nicht | Installieren Sie `rofi-calc` oder `rofimoji` (beide sind erforderliche Abhängigkeiten). |
| Ein Spickzettel öffnet sich nicht | Die Datei für diesen Namen und diese Sprache existiert nicht. Überprüfen Sie die in der Cheatsheets-Sektion beschriebenen Pfade. |
| `SUPER + H` zeigt nichts an | Die Historie ist leer oder der Clipboard-Rekorder von `argvus-session` hat noch nichts gespeichert. |

## Zugehörige Komponenten

| Komponente | Verantwortung |
| --- | --- |
| `argvus-hyprland` | Deklariert die Tastenkürzel und die Hyprland-Fensterregeln für die Menüs. |
| `argvus-appearance` | Ändert das aktive Thema, den Akzent und das Layout und schreibt die Rofi-Themareferenzen neu. |
| `argvus` (`argvus config`) | Speichert die Projekte, die Snippets und die Standardstarter-Einstellung. |
| `argvus-session` | Kopiert die anfängliche Rofi-Konfiguration und setzt die Schriftart beim Sitzungsstart. |
| `argvus` (`argvus terminal`) | Öffnet SSH-Sitzungen, Projektterminals und die Passphrasenabfragen von `argvus keys`. |
| `argvus` (`argvus widget-telemetry`) | Liest das aktive Projekt, das von `argvus projects` geschrieben wurde. |
| `argvus` (`argvus i18n`) | Stellt die übersetzten Nachrichten bereit, die von den Launcher-Skripten verwendet werden. |
| `argvus` (`argvus control-center`) | Bearbeitet die Projektliste über `argvus projects`. |
