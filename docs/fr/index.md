---
title: Lanceur d'application
description: Lancez des applications, ouvrez des projets, des hôtes SSH et des extraits, choisissez des emojis, calculez et lisez des feuilles de triche via les menus Rofi d'ARGVUS.
---
`argvus-launcher` fournit la configuration de Rofi, les thèmes et les menus que ARGVUS utilise pour ouvrir des éléments depuis le clavier. Il contient :

- le lanceur d'applications (`SUPER + D`) ;
- la configuration et les thèmes de Rofi partagés par tous les menus Rofi d'ARGVUS ;
- le sélecteur de projet, le sélecteur SSH et le sélecteur de snippets (`argvus projects`, `argvus ssh`, `argvus snippets`) ;
- le gestionnaire de clés SSH (`argvus keys`), qui crée, liste, charge et supprime des paires de clés ;
- le gestionnaire de clés GPG (`argvus gpg`), qui liste, crée et exporte des clés et configure pinentry-gtk pour gpg-agent ;
- le sélecteur d'emoji, le visualiseur de cheatsheet et le menu de calculatrice.

Les raccourcis sont déclarés par `argvus-hyprland`. Ce paquet fournit les commandes et les menus qui les accompagnent.

## Raccourcis

| Raccourci | Action | Commande | Section |
| --- | --- | --- | --- |
| `SUPER + D` | Lanceur d'application | `argvus launcher` | Lanceur d'application |
| `SUPER + O` | Sélecteur de projet | `argvus projects` | Sélecteur de projet |
| `SUPER + ALT + 1` à `9` | Ouvrir le projet à cette position | `argvus projects open N` | Sélecteur de projet |
| `SUPER + ALT + S` | Sélecteur d'hôte SSH | `argvus ssh` | SSH |
| `SUPER + ALT + N` | Sélecteur de snippet | `argvus snippets` | Snippets |
| `SUPER + ALT + G` | Sélecteur de projet, puis TUI git | `argvus git` | Git |
| `SUPER + .` | Sélecteur d'émoji | `emoji-picker.sh` | Sélecteur d'émoji |
| `SUPER + C` | Calculatrice | `rofi -show calc` | Calculatrice |
| `SUPER + SHIFT + /` | Fiche de référence Hyprland | `cheatsheets.sh hypr` | Fiches de référence |
| `SUPER + CTRL + /` | Fiche de référence Kitty | `cheatsheets.sh kitty` | Fiches de référence |

## Lanceur d'application (`SUPER + D`)

`SUPER + D` exécute `argvus launcher`, qui ouvre Rofi en mode `drun`. Il liste les applications graphiques installées avec une entrée de bureau, et celle sélectionnée démarre lorsque vous appuyez sur `Enter`.

1. Appuyez sur `SUPER + D`.
2. Tapez une partie du nom de l'application. La liste est triée et le filtre ignore la casse.
3. Appuyez sur `Enter` pour démarrer l'application, ou sur `Esc` pour fermer le menu.

```sh
argvus launcher                  # opens the application menu
argvus launcher --config PATH    # uses another Rofi configuration file
```
Tout autre argument est transmis à `rofi`. `--config` sans valeur s'arrête avec une erreur.

Hyprland exécute `argvus launcher --config <Rofi configuration>` lorsque le lanceur par défaut est `rofi`, ce qui est le défaut. Si le `launcher` par défaut dans les applications par défaut est défini sur un autre programme, Hyprland exécute `<program> --show drun` à la place. Définissez-le dans les applications par défaut du Centre de contrôle, qui stocke la valeur dans `argvus-config`.

Seules les applications avec une entrée de bureau apparaissent dans la liste. Une application qui n'installe aucun fichier `.desktop` ne peut pas être trouvée ici.

## Configuration et thèmes de Rofi

Le paquet installe la configuration de Rofi sous `/usr/share/argvus/launcher/config/` :

| Fichier | Rôle |
| --- | --- |
| `config.rasi` | Point d’entrée utilisé par tous les menus ARGVUS. Configure le Rofi `configuration` (police, sans icônes, liste triée, correspondance insensible à la casse) et importe `theme.rasi`. |
| `theme.rasi` | Couleurs et disposition de la fenêtre, de la barre de saisie et de la liste. Importe un thème et le fichier de mode. |
| `mode.rasi` | Surcharge de mode. Le fichier fourni n’a pas de surcharges et conserve le mode sombre. |
| `themes/<family>/theme.rasi` | Palette d’une famille de thèmes, par exemple `argvus-dark` ou `tokyo-night`. |
| `themes/<family>-spaced/theme.rasi` | Variante espacée de la même famille. |

Le paquet fournit 22 familles, et chacune a une variante `-spaced`. Le `theme.rasi` fourni importe `argvus-dark`.

### Où se trouve la configuration active

ARGVUS résout chaque fichier Rofi via `paths_config`. Le premier fichier existant parmi les remplacements utilisateur, la copie utilisateur, les emplacements hérités et l'arborescence générée prévaut ; sinon, le fichier empaqueté sous `/usr/share/argvus/launcher/config/` est utilisé. La copie utilisateur d'un fichier est `$XDG_CONFIG_HOME/argvus/data/rofi/<file>` : le préfixe `launcher/config/` est stocké sous `rofi/`.

ARGVUS crée une copie utilisateur la première fois qu'un script ARGVUS modifie ce fichier ; `argvus-appearance` fait cela pour les modifications de thème, d'accent et de mode. Les fichiers qui n'ont jamais été modifiés continuent d'être lus depuis le package, et une copie utilisateur a la priorité sur le fichier empaqueté.

Lorsque `argvus-session` applique la police au démarrage de la session, il réécrit la ligne `font:` de `config.rasi` à partir du paramètre de police ARGVUS. Cette modification n'atteint que la copie de l'utilisateur. Tant que la copie n'existe pas, le fichier empaqueté est celui trouvé, et les utilisateurs ne peuvent pas y écrire, donc le changement de police prend effet une fois que le premier changement d'apparence a créé la copie.

### Changer le thème

`argvus-appearance` possède les changements de thème. Lorsque le thème change, il réécrit les copies utilisateur de sorte que `config.rasi` pointe vers le nouveau `theme.rasi`, et `theme.rasi` importe la palette de lanceur de la construction du thème (`~/.config/argvus/data/generated/theme/current/launcher/theme.rasi`), qui contient la famille active, la disposition et la couleur de surbrillance. Sans une construction de thème, il importe la copie de la famille, et la disposition espacée sélectionne la variante `-spaced` de la famille active. Les sélecteurs de thème tels que le menu de thème et le menu de disposition lisent le même `config.rasi`, donc ils utilisent également le style actif.

Ne modifiez pas les fichiers sous `/usr/share/argvus/launcher/` ; ils sont remplacés lors de la mise à jour du paquet. Faites des modifications dans la copie utilisateur, sous `$XDG_CONFIG_HOME/argvus/data/rofi/`.

## Sélecteur de projet (`SUPER + O`)

`argvus projects` (`SUPER + O`) répertorie les projets que vous avez ajoutés et ouvre celui sélectionné dans son propre espace de travail Hyprland, avec un `argvus terminal` dans son répertoire. Si l'espace de travail du projet existe déjà, le sélecteur se contente de le focaliser.

Pour un accès uniquement au clavier, `SUPER + ALT + 1` à `SUPER + ALT + 9` ouvrent le projet à cette position dans la liste, sans le menu. Les positions correspondent aux numéros affichés dans le menu. Ils suivent l'ordre de la liste, donc ajouter ou supprimer un projet peut les modifier. `argvus projects open <number or directory name>` fait de même depuis un terminal, et les échecs sont affichés sous forme de notification.

La liste effective des projets est limitée à 9, puisque c'est tout ce que `SUPER + ALT + 1..9` peut gérer. `argvus projects add` (ainsi que la page Projets du Centre de Contrôle, qui l'appelle) refuse d'ajouter un projet ou un répertoire racine qui ferait dépasser le total de 9, et signale l'erreur à la place.

Un projet provient de deux endroits dans la section `projects` de `argvus-config` :

- `paths` : répertoires de projet individuels.
- `roots` : répertoires dont les sous-répertoires immédiats sont des projets. Une racine qui n'existe pas est ignorée.

Aucune racine ni chemin n'est configuré par défaut ; ajoutez au moins un avant que `SUPER + O` ait quelque chose à lister.

Gérez-les depuis un terminal :

```sh
argvus projects add ~/Work/api          # one project
argvus projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus projects remove ~/Work/api       # removes it from paths and roots
argvus projects list                    # prints the roots and paths
```
`argvus projects pick` affiche la même liste et imprime le chemin choisi au lieu de l'ouvrir. D'autres outils peuvent l'utiliser, comme le fait `argvus git`. Annuler n'imprime rien.

Si aucune racine ou chemin n'existe, `SUPER + O` signale qu'aucun projet n'a été trouvé. Une commande d'éditeur optionnelle, `/projects/editor`, démarre dans le même espace de travail lorsque l'espace de travail est créé.

Les entrées sont lues à partir de la configuration effective ; le lanceur n'en garde aucune copie.

Ouvrir un projet enregistre également son chemin comme projet actif pour la session, que le bloc de télémétrie du Dev Dashboard (`argvus widget-telemetry`) lit pour signaler le git de ce projet, les ports d'écoute et les conteneurs.

## SSH (`SUPER + ALT + S`)

`SUPER + ALT + S` ouvre un sélecteur avec les hôtes définis dans `~/.ssh/config`. L'hôte sélectionné s'ouvre dans un nouveau terminal ARGVUS exécutant `ssh <host>`, dans l'espace de travail actuel.

### Configuration

Ajoutez une entrée `Host` pour chaque serveur à `~/.ssh/config` :

```ini
Host myhost
    HostName myhost.local
    User boss
    IdentityFile ~/.ssh/myhost
    IdentitiesOnly yes
```
Confirmez que `ssh myhost` fonctionne d'abord dans un terminal normal. Le lanceur ne lance que `ssh` ; l'authentification, les clés et la vérification de l'hôte sont gérées par OpenSSH.

### Utilisation

1. Appuyez sur `SUPER + ALT + S`.
2. Tapez une partie du nom de l'hôte, ou utilisez les touches fléchées.
3. Appuyez sur `Enter`. Le terminal s'ouvre et exécute `ssh <host>`.

Lorsque la session se termine, la fenêtre reste ouverte et affiche le statut de sortie, par exemple `ssh exited with status 0. Press Enter to close.`. Appuyez sur `Enter` pour la fermer. Cela est important pour des plateformes comme GitHub, GitLab et Gitea : elles vous authentifient et ferment la connexion immédiatement car elles ne fournissent pas de shell. La fenêtre conserve leur message à l'écran au lieu de disparaître.

### Règles

- Les entrées génériques (`Host *`, `Host *.internal`) sont des blocs de correspondance, pas des cibles, et ne sont jamais listées.
- Chaque alias sur une ligne `Host` est listé séparément (`Host a b` liste `a` et `b`). Les doublons sont supprimés.
- Les hôtes définis uniquement dans des fichiers chargés avec `Include` ne sont pas listés ; le sélecteur lit seulement le fichier principal.
- Seuls les alias composés de lettres, chiffres, `.`, `-` et `_` sont lancés. Tout autre nom est refusé avec une notification.
- Les fins de ligne Windows (CRLF) dans la configuration sont acceptées.
- `ARGVUS_SSH_CONFIG` remplace le chemin du fichier de configuration, ce qui est utile pour les tests.

### Commandes

```sh
argvus ssh list          # prints the configured hosts, one per line
argvus ssh open myhost   # opens a specific host without the picker
```
### Dépannage

| Symptom | Cause et solution |
| --- | --- |
| Notification "aucun hôte trouvé dans ~/.ssh/config" | Le fichier est manquant ou ne contient pas de lignes `Host`. Exécutez `argvus ssh list` pour vérifier. |
| Un hôte est manquant dans le sélecteur | C'est un caractère générique, provient d'un fichier `Include`, ou contient des caractères en dehors du jeu autorisé. Mettez-le dans le fichier principal avec un alias simple. |
| La fenêtre montre immédiatement un statut d'erreur | Exécutez `ssh <host>` dans un terminal normal pour voir le message complet (hôte inaccessible, mauvaise clé, etc.). |
| La fenêtre affiche `message.ssh_session_ended` au lieu du texte | Le paquet `argvus` installé est plus ancien que cette version. Mettez à jour `argvus`. |

Nécessite `openssh` et `argvus` (la commande `argvus terminal`).

## Clés SSH (`argvus keys`)

`argvus keys` gère les paires de clés dans `~/.ssh` et les clés détenues par l'agent ssh. Il n'a pas de raccourci. La page **Clés SSH** du Centre de Contrôle (Applications) utilise les mêmes commandes.

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
Règles qui s'appliquent à chaque commande :

- Un nom de clé devient un nom de fichier sous `~/.ssh`, il ne peut donc contenir que des lettres, des chiffres, un point, un tiret et un underscore. Il ne peut pas commencer par un point ni se terminer par `.pub`. Une paire existante n'est jamais écrasée.
- Seules les paires avec un fichier public (`NAME.pub`) sont listées, et seules celles-ci peuvent être chargées, déchargées ou supprimées.
- Les phrases de passe ne sont jamais passées en tant qu'arguments de commande, écrites dans un journal ou affichées dans le centre de contrôle. `load` et `generate --passphrase` ouvrent un terminal ARGVUS, et OpenSSH lit le secret à partir de ce terminal.
- `list` rapporte `unknown` dans la colonne `loaded` lorsque l'agent est injoignable. Il ne fait jamais de suppositions.
- `delete` supprime définitivement la clé privée. Conservez une copie de toute clé dont vous avez encore besoin.
- `ARGVUS_SSH_DIR` remplace `~/.ssh`, ce qui est utile pour les tests.

L'agent est le service utilisateur `argvus-ssh-agent.service` démarré par `argvus-session`. `SSH_AUTH_SOCK` pointe vers lui dans la session.

Nécessite `openssh` (`ssh-keygen` et `ssh-add`) et `argvus` (la commande `argvus terminal`).

| Symptôme | Cause et solution |
| --- | --- |
| `load` ouvre un terminal, mais la clé n'est pas chargée | Tapez la phrase de passe dans ce terminal. Si elle n'a pas été demandée, exécutez `ssh-add -l` pour voir ce que l'agent contient. |
| Le terminal affiche `Could not open a connection to your authentication agent` | Hyprland a démarré avant l'agent, donc ses terminaux n'ont pas `SSH_AUTH_SOCK`. Le lanceur revient à `$XDG_RUNTIME_DIR/ssh-agent.socket`, donc mettez à jour `argvus-launcher` et ouvrez un nouveau terminal. |
| `list` montre `unknown` dans la colonne `loaded` | L'agent n'est pas accessible. Vérifiez `systemctl --user status argvus-ssh-agent.service` et la variable `SSH_AUTH_SOCK`. |
| `delete` rapporte que la clé est chargée | Exécutez d'abord `argvus keys unload NAME`, puis supprimez-la de nouveau. |
| `generate` rapporte que le nom existe déjà | Choisissez un autre nom. Les paires existantes ne sont jamais remplacées. |

## Clés GPG (`argvus gpg`)

`argvus gpg` liste, crée et exporte des clés GPG et importe des clés publiques. gpg-agent utilise toujours `pinentry-gtk` : ARGVUS écrit ce pinentry dans `gpg-agent.conf` avant de générer une clé. Il n'a pas de raccourci. La page **Clés GPG** du Centre de Contrôle utilise les mêmes commandes.

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
`generate` prend ces options :

- `--algo rsa|dsa` choisit l'algorithme de clé. Par défaut, c'est `rsa`.
- `--bits` choisit la taille de la clé. RSA accepte `1024`, `2048`, `3072` et `4096`, avec `4096` par défaut. DSA accepte `1024`, `2048` et `3072`, avec `2048` par défaut ; gpg ne peut pas créer de clés DSA plus grandes, donc `4096` est refusé avant l'exécution de gpg.
- `--expire` prend `0` pour aucune expiration, un nombre suivi de `d`, `w`, `m` ou `y` (tel que `2y`), ou une date ISO `YYYY-MM-DD`, qui doit être une date réelle.
- `--passphrase-stdin` lit la phrase de passe depuis la première ligne de l'entrée standard. Le Centre de Contrôle l'utilise. Une ligne vide est refusée.
- `--no-passphrase --yes` crée une clé non protégée. Les deux modes de phrase de passe ne peuvent pas être combinés.

Chaque clé reçoit une clé principale de certification et de signature et une sous-clé de chiffrement, afin qu'elle puisse à la fois chiffrer des fichiers et signer des commits et des paquets. La sous-clé correspond à la clé principale : `rsa` avec la même taille pour RSA, et `elg` avec la même taille pour DSA, ce qui est le couplage requis par la norme DSA.

Règles qui s'appliquent à chaque commande :

- Les phrases de passe ne sont jamais passées comme arguments de commande, écrites dans un journal ou affichées dans le Centre de Contrôle. Avec `--passphrase-stdin`, la phrase de passe est transmise à gpg sur le descripteur de fichier 0 depuis un pipe. Sans cette option, gpg demande la fenêtre pinentry, que `gpg-agent` ouvre.
- `--no-passphrase` stocke la clé privée sans protection. Elle est refusée à moins que `--yes` soit également fourni.
- `import` refuse tout fichier contenant un paquet de clé secrète, en forme ASCII ou binaire. Les clés privées quittent le trousseau uniquement via `export-private`, qui nécessite `--yes` et le mode d’écriture `600` ; `import-private` les ramène.
- Les commandes qui modifient ou publient des clés (`export-private`, `delete`, `edit sign`, `edit revoke`, `keyserver send`) nécessitent `--yes`. Le Centre de Contrôle ne le transmet qu'après sa propre confirmation.
- Les commandes qui utilisent la clé secrète exécutent gpg avec `--no-tty`, donc gpg n'essaie jamais d'ouvrir un terminal. La phrase de passe provient de la fenêtre pinentry, sauf dans `generate --passphrase-stdin`.
- `generate` fait en sorte que gpg-agent utilise `pinentry-gtk`. Il écrit cette ligne entre les marqueurs `# BEGIN argvus-managed pinentry` et `# END argvus-managed pinentry`, conserve le reste de `gpg-agent.conf`, et sauvegarde le fichier précédent sous `gpg-agent.conf.bak`. Lorsque le bloc nomme déjà `pinentry-gtk`, le fichier et gpg-agent sont laissés tels quels. La commande refuse de s'exécuter lorsque `gpg-agent.conf` définit déjà `pinentry-program` en dehors de ce bloc, afin que deux valeurs ne soient jamais en conflit.
- L'installation du paquet n'écrit jamais dans `~/.gnupg`. La configuration ne change que lorsqu'une clé est générée. 
- `GNUPGHOME` remplace `~/.gnupg`, ce qui est utile pour les tests.

`gnupg` et `pinentry` sont des dépendances requises : les commandes de clé nécessitent gpg, et la fenêtre de mot de passe est `pinentry-gtk`.

| Symptôme | Cause et solution |
| --- | --- |
| `generate` n'ouvre pas de fenêtre de mot de passe | Vérifiez `argvus gpg status`. `pinentry-gtk` doit être installé, et la session doit exposer `WAYLAND_DISPLAY` ou `DISPLAY`. |
| `generate` indique que `pinentry-gtk` n'est pas installé | Installez le paquet `pinentry`. |
| `generate` signale une ligne `pinentry-program` en dehors du bloc ARGVUS | Supprimez cette ligne de `~/.gnupg/gpg-agent.conf`, puis exécutez à nouveau la commande. |
| `generate` indique que la taille de la clé n'est pas prise en charge | Vérifiez la taille pour l'algorithme : DSA s'arrête à 3072 bits. |
| `generate` signale que le sous-clé de chiffrement n'a pas pu être ajoutée | La clé a été créée. Ajoutez le sous-clé avec `gpg --quick-add-key FINGERPRINT cv25519 encr 2y`, ou supprimez la clé avec `gpg --delete-secret-and-public-key` et générez-la à nouveau. |
| `import` refuse un fichier | Le fichier contient une clé privée. Exportez uniquement la clé publique sur l'autre machine avec `argvus gpg export-public`. |
| `list` ne montre aucune clé | L'anneau de clés dans `GNUPGHOME` (ou `~/.gnupg`) est vide. Exécutez `argvus gpg generate` pour créer une clé. |

## Extraits (`SUPER + ALT + N`)

`SUPER + ALT + N` ouvre un sélecteur avec vos extraits. L'extrait sélectionné est saisi dans la fenêtre active, au niveau du curseur, au lieu de passer par le presse-papier.

### Configuration

Ajoutez un extrait avec un nom et son texte:

```sh
argvus snippets add "email" "you@example.com"
```
Vérifiez qu'il a été stocké :

```sh
argvus snippets list
```
Les extraits sont stockés dans la section `snippets` de `argvus config`, en tant qu'entrées `{name, content}`. Vous pouvez les lire avec `argvus config get /snippets/items`.

### Utilisation

1. Cliquez dans le champ de texte de l'application qui doit recevoir le texte.
2. Appuyez sur `SUPER + ALT + N`.
3. Sélectionnez l'extrait par nom et appuyez sur `Enter`. Le texte est tapé à l'endroit du curseur.

### Commandes

```sh
argvus snippets add "NAME" "CONTENT"   # adds a snippet, or replaces the one with the same name
argvus snippets remove NAME            # removes a snippet
argvus snippets list                   # prints index and name, one per line
argvus snippets open NAME              # types a snippet by name
argvus snippets open 2                 # types the snippet at position 2 of `list`
argvus snippets                        # opens the picker (same as the shortcut)
argvus snippets --help                 # shows the options and an example
```
### Règles

- Les noms sont uniques et sensibles à la casse. Ajouter un extrait avec un nom existant remplace son contenu.
- Le contenu ne peut pas être vide : un extrait vide est signalé comme introuvable.
- `open` considère qu'un nom composé uniquement de chiffres est une position. Utilisez des noms avec des lettres, tels que `code2`, pour éviter toute ambiguïté.
- Une position fait référence à l'ordre affiché par `list`. Supprimer un extrait décale les positions de ceux qui suivent.

### Dépannage

| Symptôme | Cause et solution |
| --- | --- |
| Notification "pas d'extraits" lors de l'appui sur le raccourci | Aucun extrait n'a encore été ajouté. Exécutez `argvus snippets add` d'abord. |
| `open` signale que l'extrait est introuvable | Le nom ne correspond pas exactement. Comparez avec `argvus snippets list`. |
| Rien n'apparaît dans l'application | La fenêtre focalisée n'est pas un champ de texte, ou il s'agit d'une application X11 fonctionnant sous XWayland, qui peut ignorer ce type d'entrée. Testez avec une application native Wayland. |

Nécessite `wtype`, `rofi`, `jq` et `argvus` (la commande `argvus config`).

`wtype` simule des pressions de touches au niveau de l'entrée Wayland. Certaines applications X11 exécutées sous XWayland ignorent ces événements, donc le texte peut ne pas apparaître là-même si l'extrait a été trouvé.

## Git (`SUPER + ALT + G`)

`SUPER + ALT + G` ouvre le même sélecteur de projet que `SUPER + O`. Choisir un projet ouvre `lazygit` (ou `gitui`) directement dans celui-ci, dans un nouveau terminal ARGVUS sur l'espace de travail actuel. Il n'y a pas d'étape séparée pour sélectionner d'abord le projet.

### Configuration

Installez l'un des deux outils. Les deux sont des dépendances optionnelles de ce paquet :

```sh
sudo pacman -S lazygit   # or: sudo pacman -S gitui
```
### Utilisation

1. Appuyez sur `SUPER + ALT + G`.
2. Choisissez un projet dans la liste, ou appuyez sur `Esc` pour annuler. Annuler n'ouvre rien.
3. Le terminal s'ouvre dans le répertoire du projet et démarre l'interface TUI.

Un projet qui n'est pas un dépôt git affiche une notification et n'ouvre rien. Pour sauter le sélecteur, passez un répertoire :

```sh
argvus git ~/Projects/api
```
### Choisir l'outil

`argvus-git` utilise `lazygit` lorsqu'il est installé, et `gitui` sinon. Pour préférer `gitui`, définissez `ARGVUS_GIT_TUI` pour la commande :

```sh
ARGVUS_GIT_TUI=gitui argvus git
```
La variable est lue depuis l'environnement de la commande qui exécute le script. Elle n'est pas stockée dans la configuration ARGVUS.

### Dépannage

| Symptôme | Cause et solution |
| --- | --- |
| Notification "not a git repository" | Le projet choisi n'est pas un dépôt git, ou son répertoire a été déplacé. Supprimez-le ou corrigez-le avec `argvus projects remove`. |
| Notification "install lazygit or gitui" | Aucun des outils n'est sur le `PATH`. Installez-en un. |
| Le sélecteur n'affiche aucun projet | Aucun projet n'a été ajouté. Utilisez `argvus projects add`. |

## Sélecteur d'emojis (`SUPER + .`)

`SUPER + .` ouvre `rofimoji` avec la configuration ARGVUS de Rofi. Recherchez un emoji par son nom, appuyez sur `Enter`, et l'emoji est copié dans le presse-papiers. Collez-le avec `Ctrl + V` dans l'application souhaitée.

Pendant que le sélecteur est ouvert, la session ignore les notifications de disposition du clavier qu'elle afficherait autrement. Le lanceur écrit un marqueur de courte durée dans le répertoire du cache ARGVUS et le supprime environ une seconde après la fermeture du sélecteur.

Nécessite `rofimoji` et `wl-clipboard`.

## Calculatrice (`SUPER + C`)

`SUPER + C` ouvre le mode `calc` de Rofi avec la configuration Rofi ARGVUS. Tapez une expression, et la liste des résultats se met à jour au fur et à mesure de la frappe. Choisissez un résultat comme le définit le mode `rofi-calc`.

Le paquet du lanceur fournit la configuration Rofi et dépend de `rofi-calc`. Le raccourci lui-même est déclaré par `argvus-hyprland`.

## Fiches de référence (`SUPER + SHIFT + /` et `SUPER + CTRL + /`)

`cheatsheets.sh` affiche une liste en lecture seule de raccourcis dans une grande fenêtre Rofi. Il prend le nom de l'application comme argument :

```sh
cheatsheets.sh hypr     # Hyprland shortcuts (SUPER + SHIFT + /)
cheatsheets.sh kitty    # terminal shortcuts (SUPER + CTRL + /)
cheatsheets.sh <name>   # any other application with a cheatsheet
```

- `hypr` utilise `data/generated/hypr/keybindings.txt` à partir de la configuration ARGVUS de l'utilisateur lorsque ce fichier existe. Sinon, il utilise la fiche de référence Hyprland fournie avec `argvus-hyprland`.
- `kitty` utilise la fiche de référence du terminal fournie avec `argvus`.
- Tout autre nom lit `<name>/docs/cheatsheets/<language>.txt`. Si ce fichier n'existe pas, aucune fenêtre ne s'ouvre.

La langue est le portugais lorsque la locale du système est `pt-BR`, et l'anglais sinon. `Esc` ferme la fenêtre. Sélectionner une ligne ne fait que la fermer ; rien n'est exécuté.

## Autres menus qui utilisent la configuration Rofi

La configuration du lanceur est partagée avec des composants appartenant à d'autres paquets :

- L'historique du presse-papiers (`SUPER + H`) et son raccourci de vidage (`SUPER + SHIFT + H`) sont déclarés par `argvus-hyprland`. Ils dirigent `cliphist` vers Rofi avec cette configuration. `cliphist` provient de `argvus-session`, qui exécute l'enregistreur de presse-papiers qui remplit l'historique ; le méta-paquet `argvus` en dépend également.  
- Les sélectionneurs de thème, d'accent et de disposition dans `argvus-appearance` ouvrent Rofi avec `config.rasi`.  
- Les règles de fenêtres Hyprland reconnaissent les espaces de noms `argvus-launcher` et `rofi`, de sorte que les menus reçoivent le traitement de surface du lanceur.  

## Emballage et dépendances

Le paquet `argvus-launcher` est indépendant de l'architecture et installe :  

- `argvus launcher`, `argvus-snippets`, `argvus-ssh` et `argvus-git`, dans le même répertoire ;  
- `/usr/share/argvus/launcher/config/`, avec la configuration et les thèmes de Rofi ;  
- `/usr/share/argvus/launcher/sh/`, avec `cheatsheets.sh` et `emoji-picker.sh`.

Dépendances requises : `argvus-session`, `argvus-appearance`, `argvus`, `bash`, `jq`, `hyprland`, `libnotify`, `rofi`, `rofi-calc`, `rofimoji`, `wl-clipboard`, `wtype`, `gnupg` et `pinentry` (qui fournit `pinentry-gtk`). Dépendances optionnelles : `openssh`, pour le sélecteur SSH et le gestionnaire de clés SSH ; `lazygit` et `gitui`, pour le TUI git.

L'installation du paquet n'écrit pas dans `$HOME`. La configuration utilisateur est créée au démarrage de la session, comme décrit dans [Configuration et thèmes Rofi](#where-the-active-configuration-lives).

## Dépannage

| Symptôme | Cause et solution |
| --- | --- |
| `SUPER + D` n'ouvre rien | Vérifiez `argvus launcher` dans un terminal. Confirmez que `rofi` est installé et que la configuration de Rofi existe. |
| `SUPER + D` ne liste aucune application | Les applications n'ont pas d'entrée sur le bureau. Seules les applications avec un fichier `.desktop` sont affichées. |
| Les menus utilisent une ancienne police | La ligne `font:` est réécrite au démarrage de la session. Redémarrez la session après avoir changé la police. |
| Un changement de thème n'atteint pas les menus Rofi | Vérifiez si la copie utilisateur de `config.rasi` dans `$XDG_CONFIG_HOME/argvus/data/rofi/` pointe toujours vers le thème fourni. Appliquez à nouveau le thème depuis `argvus-appearance`. |
| `SUPER + O` indique qu'aucun projet n'a été trouvé | Aucun root ou chemin n'est configuré, ou les répertoires n'existent plus. Exécutez `argvus projects list`. |
| `SUPER + C` ou le sélecteur d'émojis ne s'ouvre pas | Installez `rofi-calc` ou `rofimoji` (les deux sont des dépendances requises). |
| Une fiche de référence ne s'ouvre pas | Le fichier pour ce nom et cette langue n'existe pas. Vérifiez les chemins décrits dans la section Fiches de référence. |
| `SUPER + H` ne montre rien | L'historique est vide, ou l'enregistreur de presse-papiers de `argvus-session` n'a encore rien stocké. |

## Composants associés

| Composant | Responsabilité |
| --- | --- |
| `argvus-hyprland` | Déclare les raccourcis et les règles de fenêtres Hyprland pour les menus. |
| `argvus-appearance` | Change le thème actif, l'accent et la disposition, et réécrit les références du thème Rofi. |
| `argvus` (`argvus config`) | Stocke les projets, les extraits de code et le paramètre de lanceur par défaut. |
| `argvus-session` | Copie la configuration initiale de Rofi et définit sa police au démarrage de la session. |
| `argvus` (`argvus terminal`) | Ouvre des sessions SSH, des terminaux de projet et les invites de mot de passe de `argvus keys`. |
| `argvus` (`argvus widget-telemetry`) | Lit le projet actif écrit par `argvus projects`. |
| `argvus` (`argvus i18n`) | Fournit les messages traduits utilisés par les scripts du lanceur. |
| `argvus` (`argvus control-center`) | Modifie la liste des projets via `argvus projects`. |
