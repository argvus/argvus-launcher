---
title: Lanciatore e ricerca
description: Lanciatore e ricerca — Quickshell/QML + Rust.
---
Il lanciatore principale usa Quickshell/QML con un motore locale Rust per applicazioni, finestre, impostazioni, azioni, progetti, host SSH, file e scorciatoie. L’indicizzazione è inizialmente disattivata e richiede cartelle scelte esplicitamente. Indicizza solo nomi e percorsi, mai il contenuto. I file recenti dipendono dal registro XDG. I file nascosti sono esclusi per impostazione predefinita e i collegamenti simbolici alle cartelle non vengono seguiti. I menu Rofi specializzati restano disponibili. In Launcher and Search puoi scegliere l’ordine A–Z o Aperte di recente; Aperte di recente è l’impostazione predefinita. La categoria salvata continua a filtrare gli altri risultati; disattiva la sorgente Windows nelle impostazioni di ricerca per nascondere questo gruppo.

- il launcher delle applicazioni (`SUPER + D`);
- la configurazione di Rofi e i temi condivisi da ogni menu Rofi di ARGVUS;
- il selettore di progetti, il selettore SSH e il selettore di snippet (`argvus projects`, `argvus ssh`, `argvus snippets`);
- il gestore delle chiavi SSH (`argvus keys`), che crea, elenca, carica ed elimina coppie di chiavi;
- il gestore delle chiavi GPG (`argvus gpg`), che elenca, crea ed esporta le chiavi e configura pinentry-gtk per gpg-agent;
- il selettore di emoji e il menu della calcolatrice.

Le scorciatoie sono dichiarate da `argvus-hyprland`. Questo pacchetto fornisce i comandi e i menu associati.

## Scorciatoie

| Scorciatoia | Azione | Comando | Sezione |
| --- | --- | --- | --- |
| `SUPER + D` | ARGVUS Launcher | `argvus launcher` | Avviatore dell'applicazione |
| `SUPER + O` | Selettore di progetto | `argvus projects` | Selettore di progetto |
| `SUPER + ALT + 1` a `9` | Apri il progetto in quella posizione | `argvus projects open N` | Selettore di progetto |
| `SUPER + ALT + S` | Selettore host SSH | `argvus ssh` | SSH |
| `SUPER + ALT + N` | Selettore di snippet | `argvus snippets` | Snippet |
| `SUPER + ALT + G` | Selettore di progetto, poi Git TUI | `argvus git` | Git |
| `SUPER + .` | ARGVUS Emoji | `argvus emoji-picker` | ARGVUS Emoji |
| `SUPER + C` | Calcolatrice | `argvus calculator` | Calcolatrice |

## Lanciatore e ricerca

Il lanciatore principale usa Quickshell/QML con un motore locale Rust per applicazioni, finestre, impostazioni, azioni, progetti, host SSH, file e scorciatoie. L’indicizzazione è inizialmente disattivata e richiede cartelle scelte esplicitamente. Indicizza solo nomi e percorsi, mai il contenuto. I file recenti dipendono dal registro XDG. I file nascosti sono esclusi per impostazione predefinita e i collegamenti simbolici alle cartelle non vengono seguiti. I menu Rofi specializzati restano disponibili. ---
title: Lanciatore e ricerca
description: Lanciatore e ricerca — Quickshell/QML + Rust.
---
Il lanciatore principale usa Quickshell/QML con un motore locale Rust per applicazioni, finestre, impostazioni, azioni, progetti, host SSH, file e scorciatoie. L’indicizzazione è inizialmente disattivata e richiede cartelle scelte esplicitamente. Indicizza solo nomi e percorsi, mai il contenuto. I file recenti dipendono dal registro XDG. I file nascosti sono esclusi per impostazione predefinita e i collegamenti simbolici alle cartelle non vengono seguiti. I menu Rofi specializzati restano disponibili. In Launcher and Search puoi scegliere l’ordine A–Z o Aperte di recente; Aperte di recente è l’impostazione predefinita. **Aperte ora** è disattivato per impostazione predefinita; attivalo in Control Center > Preferences > Launcher and Search per mostrare le finestre correnti quando la ricerca è vuota. Dalla stessa pagina puoi cancellare la cronologia di utilizzo.

Il launcher usa un layout TUI compatto: testo monospaziato, ricerca e categorie allineate, preferiti compatti e aiuto separato in basso. Spessore e arrotondamento dei bordi seguono le impostazioni attive di ARGVUS.

Il launcher usa la lingua dell’interfaccia ARGVUS scelta nel Centro di controllo.

`argvus launcher` · `argvus control-center launcher`

↑↓ Naviga · Enter Apri · Esc Indietro · Ctrl+F Preferito

- Configura ricerca: Applicazioni, Finestre, Impostazioni, Azioni, Progetti, SSH, file, Aiuto.
- Aggiungi cartella indicizzata / Aggiungi esclusione — Percorso assoluto.
- Sospendi indicizzazione / Cancella indice e sospendi / Ricostruisci indice.
- ↑↓ Naviga · Enter Attiva/Aggiungi · Delete Rimuovi · Ctrl+↑↓ Riordina · F5 Aggiorna · Esc Indietro

`argvus config get /launcher --effective`

`$XDG_CONFIG_HOME/argvus/config/launcher.json` → `$XDG_CACHE_HOME/argvus/launcher/index.json`

Quickshell: `launcher/Theme.qml` · Rofi: `launcher/theme.rasi`

`--config` / Rasi: Configura ricerca → `argvus control-center launcher`.

## Configurazione e temi di Rofi

Il pacchetto installa la configurazione di Rofi sotto `/usr/share/argvus/launcher/config/`:

| File | Ruolo |
| --- | --- |
| `config.rasi` | Punto di ingresso utilizzato da ogni menu ARGVUS. Imposta il Rofi `configuration` (font, senza icone, lista ordinata, corrispondenza senza distinzione tra maiuscole e minuscole) e importa `theme.rasi`. |
| `theme.rasi` | Colori e layout della finestra, barra di input e lista. Importa un tema e il file della modalità. |
| `mode.rasi` | Sovrascrittura della modalità. Il file incluso non ha sovrascritture e mantiene la modalità scura. |
| `themes/<family>/theme.rasi` | Tavolozza di una famiglia di temi, per esempio `argvus-dark` o `tokyo-night`. |
| `themes/<family>-spaced/theme.rasi` | Variante con spaziatura della stessa famiglia. |

Il pacchetto fornisce 22 famiglie, e ognuna ha una variante `-spaced`. Il `theme.rasi` incluso importa `argvus-dark`.

### Dove si trova la configurazione attiva

ARGVUS risolve ogni file Rofi tramite `paths_config`. Il primo file esistente tra le sovrascritture dell'utente, la copia dell'utente, le posizioni legacy e l'albero generato viene utilizzato; altrimenti viene usato il file incluso nel pacchetto sotto `/usr/share/argvus/launcher/config/`. La copia utente di un file è `$XDG_CONFIG_HOME/argvus/data/rofi/<file>`: il prefisso `launcher/config/` è memorizzato sotto `rofi/`.

ARGVUS crea una copia utente la prima volta che uno script ARGVUS modifica quel file; `argvus-appearance` fa questo per le modifiche a tema, accento e modalità. I file che non sono mai stati modificati continuano a essere letti dal pacchetto, e una copia utente ha la precedenza sul file incluso nel pacchetto.

Quando `argvus-session` applica il font all'avvio della sessione, riscrive la riga `font:` di `config.rasi` dall'impostazione del font ARGVUS. Questa modifica raggiunge solo la copia dell'utente. Finché la copia non esiste, viene trovato il file pacchettizzato e gli utenti non possono scriverci, quindi la modifica del font ha effetto una volta che il primo cambiamento di aspetto ha creato la copia.

### Cambiare il tema

`argvus-appearance` possiede le modifiche del tema. Quando il tema cambia, riscrive le copie utente in modo che `config.rasi` punti al nuovo `theme.rasi`, e `theme.rasi` importa la palette del launcher della build del tema (`~/.config/argvus/data/generated/theme/current/launcher/theme.rasi`), che ha la famiglia attiva, il layout e il colore di evidenziazione. Senza una build del tema, importa la copia della famiglia e il layout Spaziato seleziona la variante `-spaced` della famiglia attiva. I selettori di tema come il menu del tema e il menu del layout leggono lo stesso `config.rasi`, quindi usano anche lo stile attivo.

Non modificare i file sotto `/usr/share/argvus/launcher/`; vengono sostituiti durante l'aggiornamento del pacchetto. Apporta le modifiche nella copia utente, sotto `$XDG_CONFIG_HOME/argvus/data/rofi/`.

## Selettore di progetto (`SUPER + O`)

`argvus projects` (`SUPER + O`) elenca i progetti che hai aggiunto e apre quello selezionato nel suo workspace Hyprland dedicato, con un `argvus terminal` nella sua directory. Se il workspace del progetto esiste già, lo switcher si limita a concentrarsi su di esso.

Per l'accesso solo tramite tastiera, `SUPER + ALT + 1` a `SUPER + ALT + 9` aprono il progetto in quella posizione della lista, senza il menu. Le posizioni sono i numeri mostrati nel menu. Seguono l'ordine della lista, quindi aggiungere o rimuovere un progetto può modificarle. `argvus projects open <number or directory name>` fa lo stesso da terminale, e i fallimenti vengono mostrati come notifica.

La lista effettiva dei progetti è limitata a 9, poiché è tutto ciò che `SUPER + ALT + 1..9` può gestire. `argvus projects add` (e la pagina Progetti del Control Center, che lo chiama) rifiuta di aggiungere un progetto o una root che porterebbe il totale oltre 9, e segnala invece l'errore.

Un progetto proviene da due luoghi nella sezione `projects` di `argvus-config`:

- `paths`: directory di progetti individuali.
- `roots`: directory i cui sottodirectory immediati sono progetti. Una radice che non esiste viene ignorata.

Nessuna radice o percorso è configurato per impostazione predefinita; aggiungi almeno una prima che `SUPER + O` abbia qualcosa da elencare.

Gestiscili da un terminale:

```sh
argvus projects add ~/Work/api          # one project
argvus projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus projects remove ~/Work/api       # removes it from paths and roots
argvus projects list                    # prints the roots and paths
```
`argvus projects pick` mostra la stessa lista e stampa il percorso scelto invece di aprirlo. Altri strumenti possono usarlo, come fa `argvus git`. Annullando non viene stampato nulla.

Se non esiste una root o un percorso, `SUPER + O` segnala che non sono stati trovati progetti. Un comando editor opzionale, `/projects/editor`, viene avviato nello stesso workspace quando il workspace viene creato.

Le voci vengono lette dalla configurazione effettiva; il launcher non conserva alcuna copia di esse.

Aprire un progetto registra anche il suo percorso come progetto attivo per la sessione, che il blocco telemetria del Dev Dashboard (`argvus widget-telemetry`) legge per riportare il git di quel progetto, le porte in ascolto e i container.

## SSH ("SUPER + ALT + S")

**ARGVUS SSH** · GTK 4 / Wayland · `↑` `↓` `Enter` `Esc`

`SUPER + ALT + S` apre un selezionatore con gli host definiti in `~/.ssh/config`. L'host selezionato si apre in un nuovo terminale ARGVUS eseguendo `ssh <host>`, nel workspace corrente.

### Configurazione

Aggiungere una voce `Host` per ogni server in `~/.ssh/config`:

```ini
Host myhost
    HostName myhost.local
    User boss
    IdentityFile ~/.ssh/myhost
    IdentitiesOnly yes
```
Conferma che `ssh myhost` funzioni prima in un terminale normale. Il launcher esegue solo `ssh`; l'autenticazione, le chiavi e la verifica dell'host sono gestite da OpenSSH.

### Uso

1. Premi `SUPER + ALT + S`.
2. Digita parte del nome dell'host o usa i tasti freccia.
3. Premi `Enter`. Il terminale si apre ed esegue `ssh <host>`.

Quando la sessione termina, la finestra rimane aperta e mostra lo stato di uscita, ad esempio `ssh exited with status 0. Press Enter to close.`. Premi `Enter` per chiuderla. Questo è importante per forgia come GitHub, GitLab e Gitea: ti autenticano e chiudono subito la connessione perché non forniscono una shell. La finestra mantiene il loro messaggio sullo schermo invece di scomparire.

### Regole

- Le voci jolly (`Host *`, `Host *.internal`) sono blocchi di corrispondenza, non obiettivi, e non vengono mai elencate.
- Ogni alias in una riga `Host` viene elencato separatamente (`Host a b` elenca `a` e `b`). I duplicati vengono rimossi.
- Gli host definiti solo nei file caricati con `Include` non vengono elencati; il selezionatore legge solo il file principale.
- Vengono avviati solo alias composti da lettere, cifre, `.`, `-` e `_`. Qualsiasi altro nome viene rifiutato con una notifica.
- Gli a capo di Windows (CRLF) nella configurazione sono accettati.
- `ARGVUS_SSH_CONFIG` sostituisce il percorso del file di configurazione, il che è utile per i test.

### Comandi

```sh
argvus ssh list          # prints the configured hosts, one per line
argvus ssh open myhost   # opens a specific host without the picker
```
### Risoluzione dei problemi

| Sintomo | Causa e soluzione |
| --- | --- |
| Notifica "nessun host trovato in ~/.ssh/config" | Il file è assente oppure non contiene linee `Host`. Esegui `argvus ssh list` per controllare. |
| Un host manca nel selettore | È un carattere jolly, proviene da un file `Include` o ha caratteri fuori dal set consentito. Inseriscilo nel file principale con un alias semplice. |
| La finestra mostra subito uno stato di errore | Esegui `ssh <host>` in un terminale normale per vedere il messaggio completo (host irraggiungibile, chiave sbagliata, ecc.). |
| La finestra mostra `message.ssh_session_ended` invece del testo | Il pacchetto `argvus` installato è più vecchio di questa versione. Aggiorna `argvus`. |

Richiede `openssh` e `argvus` (il comando `argvus terminal`).

## Chiavi SSH (`argvus keys`)

`argvus keys` gestisce le coppie di chiavi in `~/.ssh` e le chiavi detenute dall'ssh-agent. Non ha scorciatoie. La pagina **Chiavi SSH** del Centro di Controllo (Applicazioni) usa gli stessi comandi.

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
Regole che si applicano a ogni comando:

- Un nome chiave diventa un nome file sotto `~/.ssh`, quindi può contenere solo lettere, cifre, punto, trattino e underscore. Non può iniziare con un punto o terminare con `.pub`. Una coppia esistente non viene mai sovrascritta.
- Vengono elencate solo le coppie con un file pubblico (`NAME.pub`), e solo quelle possono essere caricate, scaricate o eliminate.
- Le frasi di passaggio non vengono mai passate come argomenti del comando, scritte in un log o mostrate nel Centro di Controllo. `load` e `generate --passphrase` aprono un terminale ARGVUS, e OpenSSH legge il segreto da quel terminale.
- `list` segnala `unknown` nella colonna `loaded` quando l'agente non può essere raggiunto. Non indovina mai.
- `delete` rimuove definitivamente la chiave privata. Conserva una copia di qualsiasi chiave di cui hai ancora bisogno.
- `ARGVUS_SSH_DIR` sostituisce `~/.ssh`, il che è utile per i test.

L'agente è il servizio utente `argvus-ssh-agent.service` avviato da `argvus-session`. `SSH_AUTH_SOCK` vi punta nella sessione.

Richiede `openssh` (`ssh-keygen` e `ssh-add`) e `argvus` (il comando `argvus terminal`).

| Sintomo | Causa e soluzione |
| --- | --- |
| `load` apre un terminale, ma la chiave non è caricata | Digita la passphrase in quel terminale. Se non viene richiesta, esegui `ssh-add -l` per vedere cosa contiene l'agente. |
| Il terminale mostra `Could not open a connection to your authentication agent` | Hyprland è stato avviato prima dell'agente, quindi i suoi terminali non hanno `SSH_AUTH_SOCK`. Il launcher torna a `$XDG_RUNTIME_DIR/ssh-agent.socket`, quindi aggiorna `argvus-launcher` e apri un nuovo terminale. |
| `list` mostra `unknown` nella colonna `loaded` | L'agente non è raggiungibile. Controlla `systemctl --user status argvus-ssh-agent.service` e la variabile `SSH_AUTH_SOCK`. |
| `delete` segnala che la chiave è caricata | Esegui prima `argvus keys unload NAME`, poi cancellala di nuovo. |
| `generate` segnala che il nome esiste già | Scegli un altro nome. Le coppie esistenti non vengono mai sostituite. |

## Chiavi GPG (`argvus gpg`)

`argvus gpg` elenca, crea ed esporta chiavi GPG e importa chiavi pubbliche. gpg-agent utilizza sempre `pinentry-gtk`: ARGVUS scrive quel pinentry in `gpg-agent.conf` prima di generare una chiave. Non ha scorciatoie. La pagina **Chiavi GPG** del Centro di Controllo utilizza gli stessi comandi.

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
`generate` accetta queste opzioni:

- `--algo rsa|dsa` sceglie l'algoritmo della chiave. Il valore predefinito è `rsa`.
- `--bits` sceglie la dimensione della chiave. RSA accetta `1024`, `2048`, `3072` e `4096`, con `4096` come predefinito. DSA accetta `1024`, `2048` e `3072`, con `2048` come predefinito; gpg non può creare chiavi DSA più grandi, quindi `4096` viene rifiutato prima dell'esecuzione di gpg.
- `--expire` prende `0` per nessuna scadenza, un numero seguito da `d`, `w`, `m` o `y` (come `2y`), oppure una data ISO `YYYY-MM-DD`, che deve essere una data reale.
- `--passphrase-stdin` legge la passphrase dalla prima riga dell'input standard. Il Centro di Controllo lo utilizza. Una linea vuota viene rifiutata.
- `--no-passphrase --yes` crea una chiave non protetta. I due modi di passphrase non possono essere combinati.

Ogni chiave riceve una chiave primaria di certificazione e firma e una chiave secondaria di crittografia, così può criptare file oltre a firmare commit e pacchetti. La chiave secondaria corrisponde alla chiave primaria: `rsa` con la stessa dimensione per RSA, e `elg` con la stessa dimensione per DSA, che è l'accoppiamento richiesto dallo standard DSA.

Regole che si applicano a ogni comando:

- Le frasi di accesso non vengono mai passate come argomenti del comando, scritte in un registro o mostrate nel Centro di Controllo. Con `--passphrase-stdin` la frase di accesso va a gpg sul file descriptor 0 tramite una pipe. Senza quell'opzione, gpg richiede la finestra pinentry, che `gpg-agent` apre.
- `--no-passphrase` memorizza la chiave privata senza protezione. Viene rifiutata a meno che `--yes` sia anche fornita.
- `import` rifiuta qualsiasi file che contenga un pacchetto di chiave segreta, in forma ASCII o binaria. Le chiavi private lasciano il portachiavi solo tramite `export-private`, che richiede `--yes` e scrive in modalità `600`; `import-private` le rimette indietro.
- I comandi che cambiano o pubblicano le chiavi (`export-private`, `delete`, `edit sign`, `edit revoke`, `keyserver send`) necessitano di `--yes`. Il Control Center lo passa solo dopo la propria conferma.
- I comandi che usano la chiave segreta eseguono gpg con `--no-tty`, quindi gpg non tenta mai di aprire un terminale. La passphrase proviene dalla finestra pinentry, tranne in `generate --passphrase-stdin`.
- `generate` fa sì che gpg-agent utilizzi `pinentry-gtk`. Scrive quella riga tra i marcatori `# BEGIN argvus-managed pinentry` e `# END argvus-managed pinentry`, mantiene il resto di `gpg-agent.conf` e salva il file precedente come `gpg-agent.conf.bak`. Quando il blocco nomina già `pinentry-gtk`, il file e gpg-agent rimangono così come sono. Il comando rifiuta di eseguirsi quando `gpg-agent.conf` imposta già `pinentry-program` fuori da quel blocco, in modo che due valori non confliggano mai.
- L'installazione del pacchetto non scrive mai su `~/.gnupg`. La configurazione cambia solo quando viene generata una chiave.
- `GNUPGHOME` sostituisce `~/.gnupg`, il che è utile per i test.

`gnupg` e `pinentry` sono dipendenze necessarie: i comandi della chiave richiedono gpg, e la finestra della passphrase è `pinentry-gtk`.

| Sintomo | Causa e soluzione |
| --- | --- |
| `generate` non apre una finestra per la passphrase | Controlla `argvus gpg status`. `pinentry-gtk` deve essere installato, e la sessione deve esporre `WAYLAND_DISPLAY` o `DISPLAY`. |
| `generate` segnala che `pinentry-gtk` non è installato | Installa il pacchetto `pinentry`. |
| `generate` segnala una riga `pinentry-program` al di fuori del blocco ARGVUS | Rimuovi quella riga da `~/.gnupg/gpg-agent.conf`, quindi esegui nuovamente il comando. |
| `generate` segnala che la dimensione della chiave non è supportata | Controlla la dimensione per l'algoritmo: DSA si ferma a 3072 bit. |
| `generate` segnala che non è stato possibile aggiungere la sottoclave di crittografia | La chiave è stata creata. Aggiungi la sottoclave con `gpg --quick-add-key FINGERPRINT cv25519 encr 2y`, oppure elimina la chiave con `gpg --delete-secret-and-public-key` e genera di nuovo. |
| `import` rifiuta un file | Il file contiene una chiave privata. Esporta solo la chiave pubblica sull'altro computer con `argvus gpg export-public`. |
| `list` non mostra chiavi | Il portachiavi in `GNUPGHOME` (o `~/.gnupg`) è vuoto. Esegui `argvus gpg generate` per creare una chiave. |

## Frammenti (`SUPER + ALT + N`)

**ARGVUS Frammenti** · GTK 4 / Wayland · `↑` `↓` `Enter` `Esc`

`SUPER + ALT + N` apre un selettore con i tuoi frammenti. Il frammento selezionato viene digitato nella finestra attiva, al cursore, invece di passare attraverso gli appunti.

### Configurazione

Aggiungi un frammento con un nome e il suo testo:

```sh
argvus snippets add "email" "you@example.com"
```
Controlla che sia stato archiviato:

```sh
argvus snippets list
```
I frammenti sono conservati nella sezione `snippets` di `argvus config`, come voci `{name, content}`. Puoi leggerli con `argvus config get /snippets/items`.

### Uso

1. Clicca nel campo di testo dell'applicazione che deve ricevere il testo.
2. Premi `SUPER + ALT + N`.
3. Seleziona il frammento per nome e premi `Enter`. Il testo viene digitato dove si trova il cursore.

### Comandi

```sh
argvus snippets add "NAME" "CONTENT"   # adds a snippet, or replaces the one with the same name
argvus snippets remove NAME            # removes a snippet
argvus snippets list                   # prints index and name, one per line
argvus snippets open NAME              # types a snippet by name
argvus snippets open 2                 # types the snippet at position 2 of `list`
argvus snippets                        # opens the picker (same as the shortcut)
argvus snippets --help                 # shows the options and an example
```
### Regole

- I nomi sono unici e sensibili alle maiuscole. Aggiungere uno snippet con un nome esistente sostituisce il suo contenuto.
- Il contenuto non può essere vuoto: uno snippet vuoto viene segnalato come non trovato.
- `open` considera un nome composto solo da cifre come una posizione. Usa nomi con lettere, come `code2`, per evitare ambiguità.
- Una posizione si riferisce all'ordine mostrato da `list`. Rimuovere uno snippet sposta le posizioni di quelli successivi.

### Risoluzione dei problemi

| Sintomo | Causa e soluzione |
| --- | --- |
| Notifica "nessuno snippet" quando si preme la scorciatoia | Non è stato ancora aggiunto alcuno snippet. Esegui prima `argvus snippets add`. |
| `open` segnala che lo snippet non è stato trovato | Il nome non corrisponde esattamente. Confrontalo con `argvus snippets list`. |
| Nulla appare nell'applicazione | La finestra attiva non è un campo di testo, o è un'applicazione X11 che gira sotto XWayland, che può ignorare questo tipo di input. Prova con un'applicazione nativa Wayland. |

Richiede `wtype`, `jq` e `argvus` (il comando `argvus config`).

`wtype` simula la pressione dei tasti a livello di input di Wayland. Alcune applicazioni X11 eseguite sotto XWayland ignorano questi eventi, quindi il testo potrebbe non apparire lì anche se lo snippet è stato trovato.

## Git (`SUPER + ALT + G`)

`SUPER + ALT + G` apre lo stesso selettore di progetti di `SUPER + O`. Scegliere un progetto apre `lazygit` (o `gitui`) direttamente in esso, in un nuovo terminale ARGVUS sul workspace corrente. Non c'è un passaggio separato per scegliere prima il progetto.

### Configurazione

Installa uno dei due strumenti. Entrambi sono dipendenze opzionali di questo pacchetto:

```sh
sudo pacman -S lazygit   # or: sudo pacman -S gitui
```
### Uso

1. Premi `SUPER + ALT + G`.
2. Scegli un progetto nella lista, o premi `Esc` per annullare. L'annullamento non apre nulla.
3. Il terminale si apre nella directory del progetto e avvia il TUI.

Un progetto che non è un repository git mostra una notifica e non apre nulla. Per saltare il selezionatore, passa una directory:

```sh
argvus git ~/Projects/api
```
### Scegliere lo strumento

`argvus-git` utilizza `lazygit` quando è installato, e `gitui` altrimenti. Per preferire `gitui`, impostare `ARGVUS_GIT_TUI` per il comando:

```sh
ARGVUS_GIT_TUI=gitui argvus git
```
La variabile viene letta dall'ambiente del comando che esegue lo script. Non è memorizzata nella configurazione ARGVUS.

### Risoluzione dei problemi

| Sintomo | Causa e soluzione |
| --- | --- |
| Notifica "not a git repository" | Il progetto scelto non è un repository git, oppure la sua directory è stata spostata. Rimuovilo o riparalo con `argvus projects remove`. |
| Notifica "install lazygit or gitui" | Nessuno dei due strumenti è presente su `PATH`. Installa uno di essi. |
| Il selettore mostra nessun progetto | Nessun progetto è stato aggiunto. Usa `argvus projects add`. |

## Selettore di emoji (`SUPER + .`)

`SUPER + .` → **ARGVUS Emoji** (`argvus emoji-picker`). ←↑↓→  Tab   / Cerca per nome o parola chiave   Enter Inserisci   Ctrl+C Copia   Ctrl+D Preferiti   Esc.

Il selettore si apre su Tutti. Tab cambia categoria e le frecce si spostano nella griglia.

## Calcolatrice (`SUPER + C`)

`SUPER + C` → `argvus calculator` (ARGVUS / GTK4).

## Altri menu che utilizzano la configurazione Rofi

La configurazione del launcher è condivisa con componenti appartenenti ad altri pacchetti:

- I selettori di tema, accento e layout in `argvus-appearance` aprono Rofi con `config.rasi`.
- Le regole delle finestre di Hyprland riconoscono gli spazi dei nomi `argvus-launcher` e `rofi`, quindi i menu ricevono il trattamento della superficie del launcher.

## Confezionamento e dipendenze

Il pacchetto `argvus-launcher` è indipendente dall'architettura e installa:

- `argvus launcher`, `argvus-snippets`, `argvus-ssh` e `argvus-git`, nella stessa directory;
- `/usr/share/argvus/launcher/config/`, con la configurazione di Rofi e i temi;

Dipendenze richieste: `argvus-session`, `argvus-appearance`, `argvus`, `bash`, `jq`, `hyprland`, `libnotify`, `quickshell`, `qt6-declarative`, `wl-clipboard`, `wtype`, `gnupg` e `pinentry` (che fornisce `pinentry-gtk`). Dipendenze opzionali: `openssh`, per il selettore SSH e il gestore di chiavi SSH; `lazygit` e `gitui`, per il TUI di git.

L'installazione del pacchetto non scrive in `$HOME`. La configurazione utente viene creata all'avvio della sessione, come descritto in [Rofi configuration and themes](#where-the-active-configuration-lives).

## Risoluzione dei problemi

| Sintomo | Causa e soluzione |
| --- | --- |
| `SUPER + D` non apre nulla | `argvus launcher` · `argvus control-center launcher` · `quickshell` · `argvus` |
| `SUPER + D` non elenca alcuna applicazione | Le applicazioni non hanno una voce desktop. Vengono mostrati solo le applicazioni con un file `.desktop`. |
| I menu usano un font vecchio | La riga `font:` viene riscritta all'avvio della sessione. Riavvia la sessione dopo aver cambiato il font. |
| Un cambio di tema non raggiunge i menu di Rofi | Controlla se la copia utente di `config.rasi` in `$XDG_CONFIG_HOME/argvus/data/rofi/` punta ancora al tema pacchettizzato. Applica di nuovo il tema da `argvus-appearance`. |
| `SUPER + O` segnala che non sono stati trovati progetti | Nessuna root o percorso è configurato, o le directory non esistono più. Esegui `argvus projects list`. |
| `SUPER + C` / `SUPER + .` | `argvus`, `wl-clipboard`, `wtype` |
| `SUPER + H` non mostra nulla | La cronologia è vuota, o il registratore degli appunti di `argvus-session` non ha ancora memorizzato nulla. |

## Componenti correlati

| Componente | Responsabilità |
| --- | --- |
| `argvus-hyprland` | Dichiara le scorciatoie e le regole delle finestre di Hyprland per i menu. |
| `argvus-appearance` | Cambia il tema attivo, l'accento e il layout, e riscrive i riferimenti al tema Rofi. |
| `argvus` (`argvus config`) | Memorizza i progetti, gli snippet e l'impostazione del launcher predefinito. |
| `argvus-session` | Copia la configurazione iniziale di Rofi e imposta il suo carattere all'avvio della sessione. |
| `argvus` (`argvus terminal`) | Apre sessioni SSH, terminali di progetto e prompt per la passphrase di `argvus keys`. |
| `argvus` (`argvus widget-telemetry`) | Legge il progetto attivo scritto da `argvus projects`. |
| `argvus` (`argvus i18n`) | Fornisce i messaggi tradotti utilizzati dagli script del launcher. |
| `argvus` (`argvus control-center`) | Modifica la lista dei progetti tramite `argvus projects`. |

Rofi sfoca tutto il monitor del menu, incluse barre e margini, in Sticky e Spaced. Il menu resta centrato e rispetta l’impostazione globale della sfocatura.


`/launcher/show_icons`: `true` / `false`.

`/launcher/selected_category`: `""` (All), `applications`, `windows`, `settings`, `actions`, `projects`, `ssh`, `files`, `help`.

`/launcher/application_sort`: `recent` (Aperte di recente, predefinito) oppure `alphabetical` (A–Z).

Il testo segue Applications Font in Control Center → Appearance → Desktop Style → Fonts. Le applicazioni GTK ereditano gtk-font-name; le dimensioni di numeri e titoli restano. Il launcher legge apps_family generato e segue le modifiche.

**ARGVUS Appunti** · `argvus clipboard` · `Super + H` · `↑` `↓` (Naviga) · `/` (Cerca) · `Enter` (Copia) · `Delete` (Cancella cronologia) · `Esc` (Chiudi)
