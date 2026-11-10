---
title: Lanzador de aplicaciones
description: Lanza aplicaciones, abre proyectos, hosts SSH y fragmentos, elige emojis, calcula y consulta hojas de trucos a través de los menús de ARGVUS Rofi.
---
`argvus-launcher` proporciona la configuración de Rofi, temas y menús que ARGVUS usa para abrir cosas desde el teclado. Contiene:

- el lanzador de aplicaciones (`SUPER + D`);
- la configuración de Rofi y los temas compartidos por todos los menús de Rofi de ARGVUS;
- el conmutador de proyectos, selector de SSH y selector de snippets (`argvus projects`, `argvus ssh`, `argvus snippets`);
- el gestor de claves SSH (`argvus keys`), que crea, lista, carga y elimina pares de claves;
- el gestor de claves GPG (`argvus gpg`), que lista, crea y exporta claves y configura pinentry-gtk para gpg-agent;
- el selector de emojis, el visor de hojas de trucos y el menú de calculadora.

Los atajos se declaran mediante `argvus-hyprland`. Este paquete proporciona los comandos y los menús detrás de ellos.

## Atajos

| Atajo | Acción | Comando | Sección |
| --- | --- | --- | --- |
| `SUPER + D` | Lanzador de aplicaciones | `argvus launcher` | Lanzador de aplicaciones |
| `SUPER + O` | Cambiador de proyectos | `argvus projects` | Cambiador de proyectos |
| `SUPER + ALT + 1` a `9` | Abrir el proyecto en esa posición | `argvus projects open N` | Cambiador de proyectos |
| `SUPER + ALT + S` | Selector de host SSH | `argvus ssh` | SSH |
| `SUPER + ALT + N` | Selector de fragmentos | `argvus snippets` | Fragmentos |
| `SUPER + ALT + G` | Selector de proyectos, luego TUI de git | `argvus git` | Git |
| `SUPER + .` | Selector de emojis | `emoji-picker.sh` | Selector de emojis |
| `SUPER + C` | Calculadora | `rofi -show calc` | Calculadora |
| `SUPER + SHIFT + /` | Hoja de trucos de Hyprland | `cheatsheets.sh hypr` | Hojas de trucos |
| `SUPER + CTRL + /` | Hoja de trucos de Kitty | `cheatsheets.sh kitty` | Hojas de trucos |

## Lanzador de aplicaciones (`SUPER + D`)

`SUPER + D` ejecuta `argvus launcher`, que abre Rofi en modo `drun`. Lista las aplicaciones gráficas instaladas con una entrada de escritorio, y la seleccionada se inicia cuando presionas `Enter`.

1. Presiona `SUPER + D`.
2. Escribe parte del nombre de la aplicación. La lista está ordenada y el filtro no distingue mayúsculas de minúsculas.
3. Presiona `Enter` para iniciar la aplicación, o `Esc` para cerrar el menú.

```sh
argvus launcher                  # opens the application menu
argvus launcher --config PATH    # uses another Rofi configuration file
```
Cualquier otro argumento se pasa a `rofi`. `--config` sin un valor termina con un error.

Hyprland ejecuta `argvus launcher --config <Rofi configuration>` cuando el lanzador predeterminado es `rofi`, que es el predeterminado. Si el `launcher` predeterminado en las aplicaciones predeterminadas está configurado a otro programa, Hyprland ejecuta `<program> --show drun` en su lugar. Configúralo en las aplicaciones predeterminadas del Centro de Control, que almacena el valor en `argvus-config`.

Solo las aplicaciones con una entrada de escritorio aparecen en la lista. Una aplicación que no instala ningún archivo `.desktop` no puede ser encontrada aquí.

## Configuración y temas de Rofi

El paquete instala la configuración de Rofi bajo `/usr/share/argvus/launcher/config/`:

| Archivo | Función |
| --- | --- |
| `config.rasi` | Punto de entrada usado por cada menú ARGVUS. Configura el Rofi `configuration` (fuente, sin iconos, lista ordenada, coincidencia sin distinción de mayúsculas) e importa `theme.rasi`. |
| `theme.rasi` | Colores y diseño de la ventana, barra de entrada y lista. Importa un tema y el archivo de modo. |
| `mode.rasi` | Sobrescritura de modo. El archivo empaquetado no tiene sobrescrituras y mantiene el modo Oscuro. |
| `themes/<family>/theme.rasi` | Paleta de una familia de temas, por ejemplo `argvus-dark` o `tokyo-night`. |
| `themes/<family>-spaced/theme.rasi` | Variante espaciada de la misma familia. |

El paquete proporciona 22 familias, y cada una tiene una variante `-spaced`. El `theme.rasi` empaquetado importa `argvus-dark`.

### Dónde vive la configuración activa

ARGVUS resuelve cada archivo Rofi a través de `paths_config`. El primer archivo existente entre las anulaciones del usuario, la copia del usuario, las ubicaciones heredadas y el árbol generado gana; de lo contrario, se usa el archivo empaquetado bajo `/usr/share/argvus/launcher/config/`. La copia de un archivo por el usuario es `$XDG_CONFIG_HOME/argvus/data/rofi/<file>`: el prefijo `launcher/config/` se almacena bajo `rofi/`.

ARGVUS crea una copia de usuario la primera vez que un script de ARGVUS cambia ese archivo; `argvus-appearance` hace esto para cambios de tema, acento y modo. Los archivos que nunca se han cambiado continúan siendo leídos desde el paquete, y una copia de usuario tiene precedencia sobre el archivo empaquetado.

Cuando `argvus-session` aplica la fuente al inicio de la sesión, reescribe la línea `font:` de `config.rasi` desde la configuración de fuente ARGVUS. Esa edición solo llega a la copia del usuario. Hasta que la copia exista, el archivo empaquetado es el que se encuentra, y los usuarios no pueden escribir en él, por lo que el cambio de fuente surte efecto una vez que el primer cambio de apariencia ha creado la copia.

### Cambiando el tema

`argvus-appearance` posee los cambios de tema. Cuando el tema cambia, reescribe las copias de usuario para que `config.rasi` apunte al nuevo `theme.rasi`, y `theme.rasi` importa la paleta del lanzador de la versión de tema (`~/.config/argvus/data/generated/theme/current/launcher/theme.rasi`), que tiene la familia activa, diseño y color de resaltado. Sin una versión de tema, importa la copia de la familia, y el diseño Espaciado selecciona la variante `-spaced` de la familia activa. Los selectores de tema, como el menú de tema y el menú de diseño, leen el mismo `config.rasi`, por lo que también usan el estilo activo.

No edite los archivos bajo `/usr/share/argvus/launcher/`; se reemplazan en la actualización del paquete. Haga los cambios en la copia de usuario, bajo `$XDG_CONFIG_HOME/argvus/data/rofi/`.

## Cambiador de proyectos (`SUPER + O`)

`argvus projects` (`SUPER + O`) lista los proyectos que agregaste y abre el seleccionado en su propio espacio de trabajo de Hyprland, con un `argvus terminal` en su directorio. Si el espacio de trabajo del proyecto ya existe, el conmutador solo se enfoca en él.

Para acceso solo por teclado, `SUPER + ALT + 1` a `SUPER + ALT + 9` abren el proyecto en esa posición de la lista, sin el menú. Las posiciones son los números mostrados en el menú. Siguen el orden de la lista, por lo que agregar o quitar un proyecto puede cambiarlas. `argvus projects open <number or directory name>` hace lo mismo desde un terminal, y los errores se muestran como una notificación.

La lista efectiva de proyectos está limitada a 9, ya que eso es todo lo que `SUPER + ALT + 1..9` puede direccionar. `argvus projects add` (y la página de Proyectos del Centro de Control, que lo llama) se niega a agregar un proyecto o raíz que haga superar el total de 9, y reporta el error en su lugar.

Un proyecto proviene de dos lugares en la sección `projects` de `argvus-config`:

- `paths`: directorios de proyectos individuales.
- `roots`: directorios cuyos subdirectorios inmediatos son proyectos. Se ignora cualquier raíz que no exista.

Por defecto no se configura ninguna raíz o ruta; agrega al menos una antes de que `SUPER + O` tenga algo que mostrar.

Gestionarlos desde una terminal:

```sh
argvus projects add ~/Work/api          # one project
argvus projects add --root ~/Clients    # every subdirectory of ~/Clients
argvus projects remove ~/Work/api       # removes it from paths and roots
argvus projects list                    # prints the roots and paths
```
`argvus projects pick` muestra la misma lista e imprime la ruta elegida en lugar de abrirla. Otras herramientas pueden usarla, como lo hace `argvus git`. Cancelar no imprime nada.

Si no existe una raíz o ruta, `SUPER + O` informa que no se encontraron proyectos. Un comando de editor opcional, `/projects/editor`, se inicia en el mismo espacio de trabajo cuando se crea el espacio de trabajo.

Las entradas se leen de la configuración efectiva; el lanzador no conserva ninguna copia de ellas.

Abrir un proyecto también registra su ruta como el proyecto activo para la sesión, que el bloque de telemetría del Dev Dashboard (`argvus widget-telemetry`) lee para informar sobre el git de ese proyecto, los puertos de escucha y los contenedores.

## SSH (`SUPER + ALT + S`)

`SUPER + ALT + S` abre un selector con los hosts definidos en `~/.ssh/config`. El host seleccionado se abre en un nuevo terminal ARGVUS ejecutando `ssh <host>`, en el espacio de trabajo actual.

### Configuración

Agrega una entrada `Host` para cada servidor a `~/.ssh/config`:

```ini
Host myhost
    HostName myhost.local
    User boss
    IdentityFile ~/.ssh/myhost
    IdentitiesOnly yes
```
Confirma que `ssh myhost` funciona primero en un terminal normal. El lanzador solo ejecuta `ssh`; la autenticación, las claves y la verificación del host son manejadas por OpenSSH.

### Uso

1. Presiona `SUPER + ALT + S`.
2. Escribe parte del nombre del host, o usa las teclas de flecha.
3. Presiona `Enter`. El terminal se abre y ejecuta `ssh <host>`.

Cuando la sesión termina, la ventana permanece abierta y muestra el estado de salida, por ejemplo `ssh exited with status 0. Press Enter to close.`. Presiona `Enter` para cerrarla. Esto es importante para plataformas como GitHub, GitLab y Gitea: te autentican y cierran la conexión de inmediato porque no proporcionan un shell. La ventana mantiene su mensaje en pantalla en lugar de desaparecer.

### Reglas

- Las entradas comodín (`Host *`, `Host *.internal`) son bloques de coincidencia, no objetivos, y nunca se listan.
- Cada alias en una línea `Host` se lista por separado (`Host a b` lista `a` y `b`). Se eliminan los duplicados.
- Los hosts definidos únicamente en archivos cargados con `Include` no se listan; el selector solo lee el archivo principal.
- Solo se lanzan alias compuestos de letras, dígitos, `.`, `-` y `_`. Cualquier otro nombre se rechaza con una notificación.
- Se aceptan finales de línea de Windows (CRLF) en la configuración.
- `ARGVUS_SSH_CONFIG` reemplaza la ruta del archivo de configuración, lo cual es útil para pruebas.

### Comandos

```sh
argvus ssh list          # prints the configured hosts, one per line
argvus ssh open myhost   # opens a specific host without the picker
```
### Solución de problemas

| Síntoma | Causa y solución |
| --- | --- |
| Notificación "no hosts found in ~/.ssh/config" | El archivo falta o no tiene líneas `Host`. Ejecute `argvus ssh list` para comprobar. |
| Falta un host en el selector | Es un comodín, proviene de un archivo `Include`, o tiene caracteres fuera del conjunto permitido. Colóquelo en el archivo principal con un alias simple. |
| La ventana muestra un estado de error de inmediato | Ejecute `ssh <host>` en una terminal normal para ver el mensaje completo (host inalcanzable, clave incorrecta, etc.). |
| La ventana muestra `message.ssh_session_ended` en lugar de texto | El paquete `argvus` instalado es más antiguo que esta versión. Actualice `argvus`. |

Requiere `openssh` y `argvus` (el comando `argvus terminal`).

## Claves SSH (`argvus keys`)

`argvus keys` gestiona los pares de claves en `~/.ssh` y las claves mantenidas por el ssh-agent. No tiene atajo. La página **Claves SSH** del Centro de Control (Aplicaciones) utiliza los mismos comandos.

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
Reglas que se aplican a cada comando:

- Un nombre de clave se convierte en un nombre de archivo bajo `~/.ssh`, por lo que solo puede contener letras, dígitos, punto, guion y guion bajo. No puede comenzar con un punto ni terminar con `.pub`. Un par existente nunca se sobrescribe.
- Solo se listan los pares con un archivo público (`NAME.pub`), y solo esos pueden ser cargados, descargados o eliminados.
- Las contraseñas nunca se pasan como argumentos de comando, se escriben en un registro ni se muestran en el Centro de Control. `load` y `generate --passphrase` abren una terminal ARGVUS, y OpenSSH lee el secreto desde esa terminal.
- `list` informa `unknown` en la columna `loaded` cuando no se puede alcanzar al agente. Nunca adivina.
- `delete` elimina la clave privada de forma definitiva. Mantén una copia de cualquier clave que aún necesites.
- `ARGVUS_SSH_DIR` reemplaza `~/.ssh`, lo cual es útil para pruebas.

El agente es el servicio de usuario `argvus-ssh-agent.service` iniciado por `argvus-session`. `SSH_AUTH_SOCK` apunta a esto en la sesión.

Requiere `openssh` (`ssh-keygen` y `ssh-add`) y `argvus` (el comando `argvus terminal`).

| Síntoma | Causa y solución |
| --- | --- |
| `load` abre un terminal, pero la clave no está cargada | Escriba la frase de contraseña en ese terminal. Si no se solicitó, ejecute `ssh-add -l` para ver qué tiene el agente. |
| El terminal muestra `Could not open a connection to your authentication agent` | Hyprland se inició antes que el agente, por lo que sus terminales carecen de `SSH_AUTH_SOCK`. El lanzador recurre a `$XDG_RUNTIME_DIR/ssh-agent.socket`, así que actualice `argvus-launcher` y abra un nuevo terminal. |
| `list` muestra `unknown` en la columna `loaded` | El agente no es accesible. Verifique `systemctl --user status argvus-ssh-agent.service` y la variable `SSH_AUTH_SOCK`. |
| `delete` informa que la clave está cargada | Ejecute `argvus keys unload NAME` primero, luego elimínela de nuevo. |
| `generate` informa que el nombre ya existe | Elija otro nombre. Los pares existentes nunca se reemplazan. |

## Claves GPG (`argvus gpg`)

`argvus gpg` lista, crea y exporta claves GPG e importa claves públicas. gpg-agent siempre usa `pinentry-gtk`: ARGVUS escribe ese pinentry en `gpg-agent.conf` antes de generar una clave. No tiene un acceso directo. La página de **claves GPG** del Centro de Control usa los mismos comandos.

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
`generate` toma estas opciones:

- `--algo rsa|dsa` elige el algoritmo de clave. El valor predeterminado es `rsa`.
- `--bits` elige el tamaño de la clave. RSA acepta `1024`, `2048`, `3072` y `4096`, siendo `4096` el predeterminado. DSA acepta `1024`, `2048` y `3072`, siendo `2048` el predeterminado; gpg no puede crear claves DSA más grandes, por lo que `4096` se rechaza antes de ejecutar gpg.
- `--expire` toma `0` para que no caduque, un número seguido de `d`, `w`, `m` o `y` (como `2y`), o una fecha ISO `YYYY-MM-DD`, que debe ser una fecha real.
- `--passphrase-stdin` lee la frase de contraseña de la primera línea de la entrada estándar. El Centro de Control la utiliza. Se rechaza una línea vacía.
- `--no-passphrase --yes` crea una clave no protegida. Los dos modos de frase de contraseña no se pueden combinar.

Cada clave obtiene una clave primaria de certificar y firmar y una subclave de cifrado, para que pueda cifrar archivos así como firmar commits y paquetes. La subclave coincide con la clave primaria: `rsa` con el mismo tamaño para RSA, y `elg` con el mismo tamaño para DSA, que es el emparejamiento que requiere el estándar DSA.

Reglas que se aplican a cada comando:

- Las contraseñas nunca se pasan como argumentos de comando, se escriben en un registro ni se muestran en el Centro de Control. Con `--passphrase-stdin` la contraseña se envía a gpg en el descriptor de archivo 0 desde una tubería. Sin esa opción, gpg solicita la ventana de pinentry, que `gpg-agent` abre.
- `--no-passphrase` almacena la clave privada sin protección. Se rechaza a menos que `--yes` también se proporcione.
- `import` rechaza cualquier archivo que contenga un paquete de clave secreta, en forma ASCII o binaria. Las claves privadas solo salen del llavero mediante `export-private`, que necesita `--yes` y escribe en modo `600`; `import-private` las trae de vuelta.
- Los comandos que cambian o publican claves (`export-private`, `delete`, `edit sign`, `edit revoke`, `keyserver send`) necesitan `--yes`. El Centro de Control lo pasa solo después de su propia confirmación. 
- Los comandos que usan la clave secreta ejecutan gpg con `--no-tty`, por lo que gpg nunca intenta abrir un terminal. La frase de contraseña proviene de la ventana de pinentry, excepto en `generate --passphrase-stdin`. 
- `generate` hace que gpg-agent use `pinentry-gtk`. Escribe esa línea entre los marcadores `# BEGIN argvus-managed pinentry` y `# END argvus-managed pinentry`, mantiene el resto de `gpg-agent.conf` y guarda el archivo anterior como `gpg-agent.conf.bak`. Cuando el bloque ya nombra `pinentry-gtk`, el archivo y gpg-agent se dejan como están. El comando se niega a ejecutarse cuando `gpg-agent.conf` ya establece `pinentry-program` fuera de ese bloque, de modo que dos valores nunca entren en conflicto.
- La instalación del paquete nunca escribe en `~/.gnupg`. La configuración solo cambia cuando se genera una clave.
- `GNUPGHOME` reemplaza a `~/.gnupg`, lo cual es útil para las pruebas.

`gnupg` y `pinentry` son dependencias requeridas: los comandos de claves necesitan gpg, y la ventana de frase de paso es `pinentry-gtk`.

| Síntoma | Causa y solución |
| --- | --- |
| `generate` no abre una ventana de frase de paso | Verifique `argvus gpg status`. `pinentry-gtk` debe estar instalado, y la sesión debe exponer `WAYLAND_DISPLAY` o `DISPLAY`. |
| `generate` informa que `pinentry-gtk` no está instalado | Instale el paquete `pinentry`. |
| `generate` informa una línea `pinentry-program` fuera del bloque ARGVUS | Elimine esa línea de `~/.gnupg/gpg-agent.conf`, luego ejecute el comando nuevamente. |
| `generate` informa que el tamaño de la clave no es compatible | Verifique el tamaño para el algoritmo: DSA se detiene en 3072 bits. |
| `generate` informa que no se pudo agregar la subclave de cifrado | La clave fue creada. Agregue la subclave con `gpg --quick-add-key FINGERPRINT cv25519 encr 2y`, o elimine la clave con `gpg --delete-secret-and-public-key` y genere nuevamente. |
| `import` rechaza un archivo | El archivo contiene una clave privada. Exporte solo la clave pública en la otra máquina con `argvus gpg export-public`. |
| `list` no muestra claves | El llavero en `GNUPGHOME` (o `~/.gnupg`) está vacío. Ejecute `argvus gpg generate` para crear una clave. |

## Fragmentos (`SUPER + ALT + N`)

`SUPER + ALT + N` abre un selector con sus fragmentos. El fragmento seleccionado se escribe en la ventana enfocada, en el cursor, en lugar de pasar por el portapapeles.

### Configuración

Agregue un fragmento con un nombre y su texto:

```sh
argvus snippets add "email" "you@example.com"
```
Verifica que se haya guardado:

```sh
argvus snippets list
```
Los fragmentos se guardan en la sección `snippets` de `argvus config`, como entradas `{name, content}`. Puedes leerlos con `argvus config get /snippets/items`.

### Uso

1. Haz clic en el campo de texto de la aplicación que debe recibir el texto.
2. Presiona `SUPER + ALT + N`.
3. Selecciona el fragmento por nombre y presiona `Enter`. El texto se escribirá donde esté el cursor.

### Comandos

```sh
argvus snippets add "NAME" "CONTENT"   # adds a snippet, or replaces the one with the same name
argvus snippets remove NAME            # removes a snippet
argvus snippets list                   # prints index and name, one per line
argvus snippets open NAME              # types a snippet by name
argvus snippets open 2                 # types the snippet at position 2 of `list`
argvus snippets                        # opens the picker (same as the shortcut)
argvus snippets --help                 # shows the options and an example
```
### Reglas

- Los nombres son únicos y distinguen mayúsculas de minúsculas. Añadir un fragmento con un nombre existente reemplaza su contenido.
- El contenido no puede estar vacío: un fragmento vacío se informa como no encontrado.
- `open` trata un nombre compuesto solo por dígitos como una posición. Use nombres con letras, como `code2`, para evitar ambigüedades.
- Una posición se refiere al orden mostrado por `list`. Eliminar un fragmento desplaza las posiciones de los que están después.

### Resolución de problemas

| Síntoma | Causa y solución |
| --- | --- |
| Notificación "no hay fragmentos" al presionar el atajo | Aún no se ha añadido ningún fragmento. Ejecute `argvus snippets add` primero. |
| `open` informa que el fragmento no se encontró | El nombre no coincide exactamente. Compárelo con `argvus snippets list`. |
| No aparece nada en la aplicación | La ventana enfocada no es un campo de texto, o es una aplicación X11 ejecutándose bajo XWayland, que puede ignorar este tipo de entrada. Pruebe con una aplicación nativa de Wayland. |

Requiere `wtype`, `rofi`, `jq` y `argvus` (el comando `argvus config`).

`wtype` simula pulsaciones de teclas a nivel de entrada de Wayland. Algunas aplicaciones X11 que se ejecutan bajo XWayland ignoran estos eventos, por lo que el texto puede no aparecer allí aunque se haya encontrado el fragmento.

## Git (`SUPER + ALT + G`)

`SUPER + ALT + G` abre el mismo selector de proyectos que `SUPER + O`. Elegir un proyecto abre `lazygit` (o `gitui`) directamente en él, en un nuevo terminal ARGVUS en el espacio de trabajo actual. No hay un paso separado para seleccionar el proyecto primero.

### Configuración

Instale una de las dos herramientas. Ambas son dependencias opcionales de este paquete:

```sh
sudo pacman -S lazygit   # or: sudo pacman -S gitui
```
### Uso

1. Presione `SUPER + ALT + G`.
2. Seleccione un proyecto en la lista, o presione `Esc` para cancelar. Cancelar no abre nada.
3. El terminal se abre en el directorio del proyecto y comienza la TUI.

Un proyecto que no es un repositorio git muestra una notificación y no abre nada. Para omitir el selector, pase un directorio:

```sh
argvus git ~/Projects/api
```

### Elegir la herramienta

`argvus-git` utiliza `lazygit` cuando está instalado, y `gitui` de lo contrario. Para preferir `gitui`, configure `ARGVUS_GIT_TUI` para el comando:

```sh
ARGVUS_GIT_TUI=gitui argvus git
```
La variable se lee desde el entorno del comando que ejecuta el script. No se almacena en la configuración de ARGVUS.

### Solución de problemas

| Síntoma | Causa y solución |
| --- | --- |
| Notificación "no es un repositorio git" | El proyecto elegido no es un repositorio git, o su directorio fue movido. Elimínalo o arréglalo con `argvus projects remove`. |
| Notificación "instala lazygit o gitui" | Ninguna de las herramientas está en `PATH`. Instala una de ellas. |
| El selector no muestra proyectos | No se agregó ningún proyecto. Usa `argvus projects add`. |

## Selector de emojis (`SUPER + .`)

`SUPER + .` abre `rofimoji` con la configuración de Rofi de ARGVUS. Busca un emoji por nombre, presiona `Enter`, y el emoji se copia al portapapeles. Pégalo con `Ctrl + V` en la aplicación que desees.

Mientras el selector está abierto, la sesión ignora las notificaciones de disposición del teclado que de otro modo mostraría. El lanzador escribe un marcador de corta duración en el directorio de caché ARGVUS y lo elimina aproximadamente un segundo después de que el selector se cierre.

Requiere `rofimoji` y `wl-clipboard`.

## Calculadora (`SUPER + C`)

`SUPER + C` abre el modo `calc` de Rofi con la configuración ARGVUS de Rofi. Escribe una expresión, y la lista de resultados se actualiza a medida que escribes. Elige un resultado como define el modo `rofi-calc`.

El paquete del lanzador proporciona la configuración de Rofi y depende de `rofi-calc`. El acceso directo en sí está declarado por `argvus-hyprland`.

## Hojas de trucos (`SUPER + SHIFT + /` y `SUPER + CTRL + /`)

`cheatsheets.sh` muestra una lista de solo lectura de accesos directos en una ventana grande de Rofi. Toma el nombre de la aplicación como su argumento:

```sh
cheatsheets.sh hypr     # Hyprland shortcuts (SUPER + SHIFT + /)
cheatsheets.sh kitty    # terminal shortcuts (SUPER + CTRL + /)
cheatsheets.sh <name>   # any other application with a cheatsheet
```

- `hypr` utiliza `data/generated/hypr/keybindings.txt` de la configuración ARGVUS del usuario cuando ese archivo existe. De lo contrario, utiliza la hoja de trucos de Hyprland incluida con `argvus-hyprland`.
- `kitty` utiliza la hoja de trucos del terminal incluida con `argvus`.
- Cualquier otro nombre lee `<name>/docs/cheatsheets/<language>.txt`. Si ese archivo no existe, no se abre ninguna ventana.

El idioma es portugués cuando la configuración regional del sistema es `pt-BR`, y inglés de lo contrario. `Esc` cierra la ventana. Seleccionar una línea solo la cierra; no se ejecuta nada.

## Otros menús que usan la configuración de Rofi

La configuración del lanzador se comparte con componentes propiedad de otros paquetes:

- El historial del portapapeles (`SUPER + H`) y su atajo para limpiar (`SUPER + SHIFT + H`) son declarados por `argvus-hyprland`. Ellos canalizan `cliphist` en Rofi con esta configuración. `cliphist` proviene de `argvus-session`, que ejecuta el grabador del portapapeles que llena el historial; el meta-paquete `argvus` también depende de él. 
- Los selectores de tema, acento y diseño en `argvus-appearance` abren Rofi con `config.rasi`.
- Las reglas de ventanas de Hyprland reconocen los espacios de nombres `argvus-launcher` y `rofi`, por lo que los menús reciben el tratamiento de superficie de lanzador.

## Empaquetado y dependencias

El paquete `argvus-launcher` es independiente de la arquitectura e instala:

- `argvus launcher`, `argvus-snippets`, `argvus-ssh` y `argvus-git`, bajo el mismo directorio;
- `/usr/share/argvus/launcher/config/`, con la configuración de Rofi y los temas;
- `/usr/share/argvus/launcher/sh/`, con `cheatsheets.sh` y `emoji-picker.sh`.

Dependencias requeridas: `argvus-session`, `argvus-appearance`, `argvus`, `bash`, `jq`, `hyprland`, `libnotify`, `rofi`, `rofi-calc`, `rofimoji`, `wl-clipboard`, `wtype`, `gnupg` y `pinentry` (que proporciona `pinentry-gtk`). Dependencias opcionales: `openssh`, para el selector SSH y el gestor de claves SSH; `lazygit` y `gitui`, para la interfaz TUI de git.

La instalación del paquete no escribe en `$HOME`. La configuración del usuario se crea al iniciar la sesión, como se describe en [Configuración y temas de Rofi](#where-the-active-configuration-lives)].

## Solución de problemas

| Síntoma | Causa y solución |
| --- | --- |
| `SUPER + D` no abre nada | Verifique `argvus launcher` en una terminal. Confirme que `rofi` está instalado y que la configuración de Rofi existe. |
| `SUPER + D` no lista aplicaciones | Las aplicaciones no tienen una entrada de escritorio. Solo se muestran aplicaciones con un archivo `.desktop`. |
| Los menús usan una fuente antigua | La línea `font:` se reescribe al iniciar la sesión. Reinicie la sesión después de cambiar la fuente. |
| Un cambio de tema no se refleja en los menús de Rofi | Verifique si la copia de usuario de `config.rasi` en `$XDG_CONFIG_HOME/argvus/data/rofi/` todavía apunta al tema empaquetado. Aplique el tema desde `argvus-appearance` nuevamente. |
| `SUPER + O` indica que no se encontraron proyectos | No se ha configurado ninguna raíz o ruta, o los directorios ya no existen. Ejecute `argvus projects list`. |
| `SUPER + C` o el selector de emojis no se abre | Instale `rofi-calc` o `rofimoji` (ambos son dependencias requeridas). |
| Una chuleta no se abre | El archivo con ese nombre y idioma no existe. Verifique las rutas descritas en la sección de Chuletas. |
| `SUPER + H` no muestra nada | El historial está vacío, o el grabador de portapapeles de `argvus-session` aún no ha almacenado nada. |

## Componentes relacionados

| Componente | Responsabilidad |
| --- | --- |
| `argvus-hyprland` | Declara los atajos y las reglas de ventanas de Hyprland para los menús. |
| `argvus-appearance` | Cambia el tema activo, el acento y la disposición, y reescribe las referencias del tema de Rofi. |
| `argvus` (`argvus config`) | Almacena los proyectos, los fragmentos y la configuración del lanzador predeterminado. |
| `argvus-session` | Copia la configuración inicial de Rofi y establece su fuente al iniciar la sesión. |
| `argvus` (`argvus terminal`) | Abre sesiones SSH, terminales de proyectos y las solicitudes de contraseña de `argvus keys`. |
| `argvus` (`argvus widget-telemetry`) | Lee el proyecto activo escrito por `argvus projects`. |
| `argvus` (`argvus i18n`) | Proporciona los mensajes traducidos usados por los scripts del lanzador. |
| `argvus` (`argvus control-center`) | Edita la lista de proyectos a través de `argvus projects`. |
