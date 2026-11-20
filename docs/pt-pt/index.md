---
title: Launcher e Pesquisa
description: Launcher e Pesquisa — Quickshell/QML + Rust.
slug: de/argvus-launcher/docs/pt-pt/index.md
---

O launcher principal usa Quickshell/QML com um motor local de pesquisa em Rust. Pesquisa aplicações, janelas abertas, definições, ações, projetos, hosts SSH, ficheiros e atalhos. A indexação começa desativada; escolha as pastas explicitamente. Apenas nomes e caminhos são indexados, nunca o conteúdo dos documentos. Ficheiros recentes dependem do registo XDG. Ficheiros ocultos são excluídos por predefinição e ligações simbólicas de diretórios não são seguidas. SSH e Snippets usam GTK 4. Em Launcher and Search, escolha a ordem A–Z ou Abertas recentemente; Abertas recentemente é a predefinição. A categoria guardada continua a filtrar os restantes resultados; desative a origem Windows nas definições de pesquisa para ocultar este grupo.

- o lançador de aplicações (`SUPER + D`);
- o seletor de projetos, o seletor de hosts SSH e o seletor de snippets (`argvus projects`, `argvus ssh`, `argvus snippets`);
- o gestor de chaves SSH (`argvus keys`), que cria, lista, carrega e apaga pares de chaves;
- o gestor de chaves GPG (`argvus gpg`), que lista, cria e exporta chaves e configura o pinentry-gtk para o gpg-agent;
- o seletor de emojis e o menu da calculadora.

Os atalhos são declarados pelo `argvus-hyprland`. Este pacote fornece os comandos e os menus por trás deles.

## Atalhos

| Atalho | Ação | Comando | Seção |
| --- | --- | --- | --- |
| `SUPER + D` | ARGVUS Launcher | `argvus launcher` | Lançador de aplicações |
| `SUPER + O` | Seletor de projetos | `argvus projects` | Seletor de projetos |
| `SUPER + ALT + 1` a `9` | Abre o projeto nessa posição | `argvus projects open N` | Seletor de projetos |
| `SUPER + ALT + S` | Seletor de hosts SSH | `argvus ssh` | SSH |
| `SUPER + ALT + N` | Seletor de snippets | `argvus snippets` | Snippets |
| `SUPER + ALT + G` | Seletor de projetos, depois a TUI de git | `argvus git` | Git |
| `SUPER + .` | ARGVUS Emoji | `argvus emoji-picker` | ARGVUS Emoji |
| `SUPER + C` | Calculadora | `argvus calculator` | Calculadora |

## Launcher e Pesquisa

O launcher principal usa Quickshell/QML com um motor local de pesquisa em Rust. Pesquisa aplicações, janelas abertas, definições, ações, projetos, hosts SSH, ficheiros e atalhos. A indexação começa desativada; escolha as pastas explicitamente. Apenas nomes e caminhos são indexados, nunca o conteúdo dos documentos. Ficheiros recentes dependem do registo XDG. Ficheiros ocultos são excluídos por predefinição e ligações simbólicas de diretórios não são seguidas. SSH e Snippets usam GTK 4. Em Launcher and Search, escolha a ordem A–Z ou Abertas recentemente; Abertas recentemente é a predefinição. **Abertas agora** está desativado por predefinição; ative em Control Center > Preferences > Launcher and Search para mostrar as janelas atuais quando a pesquisa estiver vazia. O histórico de utilização pode ser limpo nessa mesma página.

O lançador usa um layout TUI compacto: texto monoespaçado, pesquisa e categorias alinhadas, favoritos compactos e rodapé de ajuda separado. A espessura e o arredondamento das margens seguem as definições de layout ativas do ARGVUS.

O launcher segue o idioma da interface do ARGVUS escolhido no Control Center.

`argvus launcher` · `argvus control-center launcher`

↑↓ Navegar · Enter Abrir · Esc Voltar · Ctrl+F Favorito

- Configurar pesquisa: Aplicações, Janelas, Configurações, Acções, Projectos, SSH, arquivos, Ajuda.
- Adicionar pasta indexada / Adicionar exclusão — Caminho absoluto.
- Pausar indexação / Apagar índice e pausar / Reconstruir índice.
- ↑↓ Navegar · Enter Alternar/Adicionar · Delete Remover · Ctrl+↑↓ Reordenar · F5 Atualizar · Esc Voltar

`argvus config get /launcher --effective`

`$XDG_CONFIG_HOME/argvus/config/launcher.json` → `$XDG_CACHE_HOME/argvus/launcher/index.json`

Quickshell: `launcher/Theme.qml`

Configurar pesquisa → `argvus control-center launcher`.

## Seletor de projetos (`SUPER + O`)

`argvus projects` (`SUPER + O`) lista os projetos que você adicionou e abre o escolhido em um workspace próprio do Hyprland, com um `argvus terminal` no diretório dele. Se o workspace do projeto já existir, o seletor apenas o foca.

Para acesso só pelo teclado, `SUPER + ALT + 1` a `SUPER + ALT + 9` abrem o projeto dessa posição da lista, sem o menu. As posições são os números mostrados no menu. Elas seguem a ordem da lista, então incluir ou remover um projeto pode mudá-las. `argvus projects open <número ou nome do diretório>` faz o mesmo pelo terminal, e as falhas aparecem como notificação.

A lista efetiva de projetos é limitada a 9, já que é só isso que `SUPER + ALT + 1..9` conseguem endereçar. `argvus projects add` (e a página Projects do Control Center, que o chama) recusa adicionar um projeto ou raiz que levaria o total além de 9, e mostra o erro correspondente.

Um projeto vem de dois lugares da seção `projects` do `argvus config`:

- `paths`: diretórios de projeto individuais.
- `roots`: diretórios cujos subdiretórios imediatos são projetos. Uma raiz que não existe é ignorada.

Nenhuma raiz ou caminho vem configurado por padrão; adicione pelo menos um antes de o `SUPER + O` ter algo para listar.

Gerencie a lista pelo terminal:

```sh
argvus projects add ~/Work/api          # um projeto
argvus projects add --root ~/Clientes   # todos os subdiretórios de ~/Clientes
argvus projects remove ~/Work/api       # remove de paths e roots
argvus projects list                    # mostra as raízes e os caminhos
```

`argvus projects pick` mostra a mesma lista e imprime o caminho escolhido em vez de abri-lo. Outras ferramentas podem usá-lo, como o `argvus git` faz. Cancelar não imprime nada.

Se nenhuma raiz ou caminho existir, `SUPER + O` informa que nenhum projeto foi encontrado. Um editor opcional, `/projects/editor`, é iniciado no mesmo workspace quando ele é criado.

As entradas são lidas da configuração efetiva; o launcher não mantém cópia delas.

Abrir um projeto também registra o caminho dele como o projeto ativo da sessão, que o bloco de telemetria Dev Dashboard (`argvus widget-telemetry`) lê para relatar o git, as portas em escuta e os containers desse projeto.

## SSH (`SUPER + ALT + S`)

**ARGVUS SSH** · GTK 4 / Wayland · `↑` `↓` `Enter` `Esc`

`SUPER + ALT + S` abre um seletor com os hosts definidos em `~/.ssh/config`. O host escolhido abre em um novo terminal ARGVUS executando `ssh <host>`, no workspace atual.

### Configuração

Adicione uma entrada `Host` para cada servidor em `~/.ssh/config`:

```ini
Host myhost
    HostName myhost.local
    User boss
    IdentityFile ~/.ssh/myhost
    IdentitiesOnly yes
```

Antes, confirme que `ssh myhost` funciona em um terminal comum. O launcher apenas executa `ssh`; autenticação, chaves e verificação do host são feitas pelo OpenSSH.

### Uso

1. Prima `SUPER + ALT + S`.
2. Introduza parte do nome do host, ou use as setas.
3. Prima `Enter`. O terminal abre e executa `ssh <host>`.

Quando a sessão termina, a janela continua aberta e mostra o status de saída, por exemplo `ssh encerrou com status 0. Pressione Enter para fechar.` Prima `Enter` para fechá-la. Isso importa para forges como GitHub, GitLab e Gitea: eles autenticam você e encerram a conexão logo em seguida, porque não oferecem shell. A janela mantém a mensagem deles no ecrã em vez de fechar.

### Regras

- Entradas com wildcard (`Host *`, `Host *.internal`) são blocos de correspondência, não destinos, e nunca aparecem na lista.
- Cada alias em uma linha `Host` aparece separadamente (`Host a b` lista `a` e `b`). Duplicatas são removidas.
- Hosts definidos apenas em ficheiros carregados por `Include` não aparecem; o seletor lê somente o ficheiro principal.
- Só são abertos aliases formados por letras, dígitos, `.`, `-` e `_`. Qualquer outro nome é recusado com uma notificação.
- Quebras de linha no formato Windows (CRLF) no ficheiro de configuração são aceitas.
- `ARGVUS_SSH_CONFIG` substitui o caminho do ficheiro de configuração, útil para testes.

### Comandos

```sh
argvus ssh list          # mostra os hosts configurados, um por linha
argvus ssh open myhost   # abre um host específico sem o seletor
```

### Solução de problemas

| Sintoma | Causa e solução |
| --- | --- |
| Notificação "nenhum host encontrado em ~/.ssh/config" | O ficheiro não existe ou não tem linhas `Host`. Execute `argvus ssh list` para verificar. |
| Um host não aparece no seletor | Ele é um wildcard, vem de um ficheiro `Include` ou tem caracteres fora do conjunto permitido. Coloque-o no ficheiro principal com um alias simples. |
| A janela mostra um status de erro logo de início | Execute `ssh <host>` em um terminal comum para ver a mensagem completa (host inacessível, chave errada etc.). |
| A janela mostra `message.ssh_session_ended` em vez de texto | O pacote `argvus` instalado é mais antigo que esta versão. Atualize o `argvus`. |

Requer `openssh` e `argvus` (o comando `argvus terminal`).

## Chaves SSH (`argvus keys`)

`argvus keys` gerencia os pares de chaves em `~/.ssh` e as chaves carregadas no ssh-agent. Não tem atalho. A página **Chaves SSH** do Control Center (Aplicações) usa os mesmos comandos.

```sh
argvus keys                              # mostra as opções e um exemplo
argvus keys list                         # um par por linha: nome, tipo, impressão digital, comentário, senha, carregada
argvus keys generate NOME                # cria ~/.ssh/NOME em ed25519, sem senha
argvus keys generate NOME --type rsa     # RSA de 4096 bits
argvus keys generate NOME --comment C    # comentário: letras, dígitos e . _ @ + -
argvus keys generate NOME --passphrase   # o ssh-keygen pede a senha em um terminal ARGVUS
argvus keys load NOME                    # adiciona a chave ao agente; abre um terminal ARGVUS só se ela tiver senha
argvus keys unload NOME                  # remove a chave do agente
argvus keys unload-all                   # remove todas as chaves do agente
argvus keys delete NOME                  # apaga os dois arquivos; recusado enquanto a chave estiver carregada
```

Regras que valem para todos os comandos:

- O nome da chave vira nome de ficheiro em `~/.ssh`, então só pode ter letras, dígitos, ponto, hífen e sublinhado. Não pode começar com ponto nem terminar em `.pub`. Um par existente nunca é sobrescrito.
- Só são listados, carregados, descarregados ou apagados os pares que têm ficheiro de chave pública (`NOME.pub`).
- A palavra-passe nunca é passada como argumento de comando, gravada em log nem exibida no Control Center. `load` e `generate --passphrase` abrem um terminal ARGVUS, e o OpenSSH lê o segredo desse terminal.
- `list` mostra `unknown` na coluna `carregada` quando o agente não pode ser alcançado. Ele nunca adivinha.
- `delete` remove a chave privada de forma definitiva. Guarde uma cópia de qualquer chave que ainda seja necessária.
- `ARGVUS_SSH_DIR` substitui `~/.ssh`, o que é útil para testes.

O agente é o serviço de utilizador `argvus-ssh-agent.service`, iniciado pelo `argvus-session`. Na sessão, `SSH_AUTH_SOCK` aponta para ele.

Requer `openssh` (`ssh-keygen` e `ssh-add`) e `argvus` (o comando `argvus terminal`).

| Sintoma | Causa e correção |
| --- | --- |
| `load` abre um terminal, mas a chave não é carregada | Introduza a palavra-passe nesse terminal. Se ela não foi pedida, Execute `ssh-add -l` para ver o que o agente tem. |
| O terminal mostra `Could not open a connection to your authentication agent` | O Hyprland foi iniciado antes do agente, então os terminais dele não têm `SSH_AUTH_SOCK`. O launcher usa `$XDG_RUNTIME_DIR/ssh-agent.socket` como alternativa; atualize o `argvus-launcher` e abra um terminal novo. |
| `list` mostra `unknown` na coluna `carregada` | O agente não está acessível. Verifique `systemctl --user status argvus-ssh-agent.service` e a variável `SSH_AUTH_SOCK`. |
| `delete` informa que a chave está carregada | Execute antes `argvus keys unload NOME` e depois apague de novo. |
| `generate` informa que o nome já existe | Escolha outro nome. Pares existentes nunca são substituídos. |

## Chaves GPG (`argvus gpg`)

`argvus gpg` lista, cria e exporta chaves GPG e importa chaves públicas. O gpg-agent usa sempre o `pinentry-gtk`: o ARGVUS grava esse pinentry no `gpg-agent.conf` antes de gerar uma chave. Não tem atalho. A página **Chaves GPG** do Control Center usa os mesmos comandos.

```sh
argvus gpg                                         # mostra as opções e um exemplo
argvus gpg list                                    # uma chave por linha: impressão digital, id, tipo, validade, secreta, confiança, identidade
argvus gpg generate "Nome <voce@example.com>"      # chave RSA 4096, válida por 2 anos; o pinentry pede a senha
argvus gpg generate "Nome <voce@example.com>" --algo dsa --bits 2048 --expire 2031-06-30
argvus gpg generate "Nome <voce@example.com>" --expire 0                       # nunca expira
printf '%s\n' "$SENHA" | argvus gpg generate "Nome <voce@example.com>" --passphrase-stdin
argvus gpg generate "Nome <voce@example.com>" --no-passphrase --yes   # chave privada sem proteção; --yes é obrigatório
argvus gpg export-public voce@example.com ~/publica.asc   # chave pública em ASCII armor, modo 600
argvus gpg export-public voce@example.com ~/publica.asc --force        # substitui um arquivo existente
argvus gpg import ~/colega.asc                     # importa chaves públicas; chaves privadas são recusadas
argvus gpg status                                  # se o gnupg está instalado e qual pinentry está em uso (argvus, usuário ou padrão)
argvus gpg export-public voce@example.com -         # imprime a chave pública na saída padrão (usada pela ação de copiar)
argvus gpg export-private IMPRESSAO_DIGITAL ~/privada.asc --yes   # chave privada em ASCII armor, modo 600; --yes é obrigatório
argvus gpg import-private ~/privada.asc            # importa um arquivo que contém chave privada
argvus gpg delete IMPRESSAO_DIGITAL --yes         # exclui a chave e a parte secreta; --yes é obrigatório
argvus gpg edit expire IMPRESSAO_DIGITAL 2y        # nova validade da chave e de cada subchave (0, Nd/Nw/Nm/Ny ou AAAA-MM-DD)
argvus gpg edit passwd IMPRESSAO_DIGITAL           # altera a senha; o pinentry pede a antiga e a nova
argvus gpg edit sign IMPRESSAO_DIGITAL ASSINANTE --yes   # certifica a chave com a chave privada de ASSINANTE
argvus gpg edit revoke IMPRESSAO_DIGITAL --reason unused --yes   # revoga; motivo none, compromised, superseded ou unused
argvus gpg edit trust IMPRESSAO_DIGITAL full       # confiança none, marginal, full ou ultimate
argvus gpg keyserver send IMPRESSAO_DIGITAL --yes  # publica a chave no servidor de chaves do gpg.conf
argvus gpg keyserver recv IMPRESSAO_DIGITAL        # busca a chave nesse servidor
```

`generate` aceita estas opções:

- `--algo rsa|dsa` escolhe o algoritmo da chave. O padrão é `rsa`.
- `--bits` escolhe o tamanho da chave. RSA aceita `1024`, `2048`, `3072` e `4096`, com `4096` como padrão. DSA aceita `1024`, `2048` e `3072`, com `2048` como padrão; o gpg não cria chaves DSA maiores, então `4096` é recusado antes de o gpg rodar.
- `--expire` aceita `0` para nenhuma validade, um número seguido de `d`, `w`, `m` ou `y` (como `2y`), ou uma data ISO `AAAA-MM-DD`, que precisa ser uma data real.
- `--passphrase-stdin` lê a palavra-passe da primeira linha da entrada padrão. A Control Center usa essa opção. Uma linha vazia é recusada.
- `--no-passphrase --yes` cria uma chave sem proteção. As duas formas de palavra-passe não podem ser combinadas.

Toda chave recebe uma chave primária de certificação e assinatura e uma subchave de criptografia, então pode criptografar ficheiros além de assinar commits e pacotes. A subchave acompanha a chave primária: `rsa` com o mesmo tamanho para RSA, e `elg` com o mesmo tamanho para DSA, que é o par exigido pelo padrão DSA.

Regras que valem para todos os comandos:

- As palavras-passe nunca são passadas como argumentos de comando, gravadas em log ou exibidas no Control Center. Com `--passphrase-stdin`, a palavra-passe vai ao gpg no descritor de ficheiro 0, por um pipe. Sem essa opção, o gpg pede a palavra-passe à janela do pinentry, que o `gpg-agent` abre.
- `--no-passphrase` grava a chave privada sem proteção. Ela é recusada sem `--yes`.
- `import` recusa qualquer ficheiro que contenha um pacote de chave secreta, em ASCII ou binário. Chaves privadas saem do chaveiro só por `export-private`, que exige `--yes` e grava modo `600`; `import-private` as traz de volta.
- Comandos que alteram ou publicam chaves (`export-private`, `delete`, `edit sign`, `edit revoke`, `keyserver send`) exigem `--yes`. A Control Center o passa só depois da própria confirmação.
- Comandos que usam a chave secreta rodam o gpg com `--no-tty`, para que ele nunca tente abrir um terminal. A palavra-passe vem da janela do pinentry, exceto em `generate --passphrase-stdin`.
- `generate` faz o gpg-agent usar o `pinentry-gtk`. Ele grava essa linha entre os marcadores `# BEGIN argvus-managed pinentry` e `# END argvus-managed pinentry`, mantém o resto do `gpg-agent.conf` e salva o ficheiro anterior como `gpg-agent.conf.bak`. Quando o bloco já indica `pinentry-gtk`, o ficheiro e o gpg-agent ficam como estão. O comando se recusa a rodar quando o `gpg-agent.conf` já define `pinentry-program` fora desse bloco, para que dois valores nunca entrem em conflito.
- Instalar o pacote nunca escreve em `~/.gnupg`. A configuração só muda quando uma chave é gerada.
- `GNUPGHOME` substitui `~/.gnupg`, o que é útil para testes.

`gnupg` e `pinentry` são dependências obrigatórias: os comandos de chave precisam do gpg, e a janela de palavra-passe é o `pinentry-gtk`.

| Sintoma | Causa e correção |
| --- | --- |
| `generate` não abre a janela de palavra-passe | Execute `argvus gpg status`. O `pinentry-gtk` precisa estar instalado, e a sessão precisa expor `WAYLAND_DISPLAY` ou `DISPLAY`. |
| `generate` avisa que o `pinentry-gtk` não está instalado | Instale o pacote `pinentry`. |
| `generate` avisa sobre uma linha `pinentry-program` fora do bloco do ARGVUS | Remova essa linha de `~/.gnupg/gpg-agent.conf` e Execute o comando de novo. |
| `generate` avisa que o tamanho da chave não é suportado | Confira o tamanho para o algoritmo: DSA vai até 3072 bits. |
| `generate` avisa que a subchave de criptografia não foi adicionada | A chave foi criada. Adicione a subchave com `gpg --quick-add-key IMPRESSÃO_DIGITAL cv25519 encr 2y`, ou apague a chave com `gpg --delete-secret-and-public-key` e gere de novo. |
| `import` recusa um ficheiro | O ficheiro contém uma chave privada. Exporte só a chave pública na outra máquina com `argvus gpg export-public`. |
| `list` não mostra chaves | O keyring em `GNUPGHOME` (ou em `~/.gnupg`) está vazio. Execute `argvus gpg generate` para criar uma chave. |

## Excertos (`SUPER + ALT + N`)

**ARGVUS Trechos** · GTK 4 / Wayland · `↑` `↓` `Enter` `Esc`

`SUPER + ALT + N` abre um seletor com seus snippets. O snippet escolhido é digitado na janela em foco, na posição do cursor, em vez de passar pela área de transferência.

### Configuração

Adicione um snippet com um nome e o texto dele:

```sh
argvus snippets add "email" "voce@example.com"
```

Confira se ele foi gravado:

```sh
argvus snippets list
```

Os snippets ficam na seção `snippets` do `argvus config`, como entradas `{name, content}`. Você pode lê-los com `argvus config get /snippets/items`.

### Uso

1. Clique no campo de texto da aplicação que deve receber o texto.
2. Prima `SUPER + ALT + N`.
3. Selecione o snippet pelo nome e Prima `Enter`. O texto é digitado onde está o cursor.

### Comandos

```sh
argvus snippets add "NOME" "CONTEÚDO"  # adiciona um snippet, ou substitui o de mesmo nome
argvus snippets remove NOME            # remove um snippet
argvus snippets list                   # mostra índice e nome, um por linha
argvus snippets open NOME              # digita um snippet pelo nome
argvus snippets open 2                 # digita o snippet na posição 2 de `list`
argvus snippets                        # abre o seletor (igual ao atalho)
argvus snippets --help                 # mostra as opções e um exemplo
```

### Regras

- Os nomes são únicos e diferenciam maiúsculas de minúsculas. Adicionar um snippet com nome existente substitui o conteúdo dele.
- O conteúdo não pode ser vazio: um snippet vazio é informado como não encontrado.
- `open` trata um nome formado só por dígitos como posição. Use nomes com letras, como `codigo2`, para evitar ambiguidade.
- A posição segue a ordem mostrada por `list`. Remover um snippet desloca as posições dos seguintes.

### Solução de problemas

| Sintoma | Causa e solução |
| --- | --- |
| Notificação "nenhum snippet" ao pressionar o atalho | Nenhum snippet foi adicionado ainda. Execute `argvus snippets add` primeiro. |
| `open` informa que o snippet não foi encontrado | O nome não confere exatamente. Compare com `argvus snippets list`. |
| Nada aparece na aplicação | A janela em foco não é um campo de texto, ou é uma aplicação X11 a executar sob XWayland, que pode ignorar esse tipo de entrada. Teste com uma aplicação Wayland nativa. |

Requer `wtype`, `jq` e `argvus` (o comando `argvus config`).

O `wtype` simula pressionamentos de tecla no nível de entrada do Wayland. Alguns aplicações X11 a executar sob XWayland ignoram esses eventos, então o texto pode não aparecer neles mesmo com o snippet encontrado.

## Git (`SUPER + ALT + G`)

`SUPER + ALT + G` abre o mesmo seletor de projetos do `SUPER + O`. Ao escolher um projeto, o `lazygit` (ou o `gitui`) abre direto nele, em um novo terminal ARGVUS no workspace atual. Não há uma etapa separada para escolher o projeto antes.

### Configuração

Instale uma das duas ferramentas. As duas são dependências opcionais deste pacote:

```sh
sudo pacman -S lazygit   # ou: sudo pacman -S gitui
```

### Uso

1. Prima `SUPER + ALT + G`.
2. Escolha um projeto na lista, ou Prima `Esc` para cancelar. Cancelar não abre nada.
3. O terminal abre no diretório do projeto e inicia a TUI.

Um projeto que não é repositório git mostra uma notificação e não abre nada. Para pular o seletor, passe um diretório:

```sh
argvus git ~/Projects/api
```

### Escolha da ferramenta

O `argvus-git` usa o `lazygit` quando ele está instalado, e o `gitui` caso contrário. Para preferir o `gitui`, defina `ARGVUS_GIT_TUI` no comando:

```sh
ARGVUS_GIT_TUI=gitui argvus git
```

A variável é lida do ambiente do comando que executa o script. Ela não é gravada na configuração do ARGVUS.

### Solução de problemas

| Sintoma | Causa e solução |
| --- | --- |
| Notificação "não é um repositório git" | O projeto escolhido não é um repositório git, ou o diretório foi movido. Remova-o ou corrija-o com `argvus projects remove`. |
| Notificação "instale o lazygit ou o gitui" | Nenhuma das duas ferramentas está no `PATH`. Instale uma delas. |
| O seletor não mostra projetos | Nenhum projeto foi adicionado. Use `argvus projects add`. |

## Seletor de emojis (`SUPER + .`)

`SUPER + .` → **ARGVUS Emoji** (`argvus emoji-picker`). ←↑↓→  Tab   / Pesquise por nome ou palavra-chave   Enter Inserir   Ctrl+C Copiar   Ctrl+D Favoritos   Esc.

O seletor abre no separador Todos. Tab percorre as categorias e as setas percorrem a grelha de emojis.

## Calculadora (`SUPER + C`)

`SUPER + C` → `argvus calculator` (ARGVUS / GTK4).

## Empacotamento e dependências

O pacote `argvus-launcher` é independente de arquitetura e instala:

- `argvus launcher`, `argvus-snippets`, `argvus-ssh` e `argvus-git`, no mesmo diretório;

Dependências obrigatórias: `argvus-session`, `argvus-appearance`, `argvus`, `bash`, `jq`, `hyprland`, `libnotify`, `quickshell`, `qt6-declarative`, `wl-clipboard`, `wtype`, `gnupg` e `pinentry` (que fornece o `pinentry-gtk`). Dependências opcionais: `openssh`, para o seletor SSH e o gestor de chaves; `lazygit` e `gitui`, para a TUI de git.


## Solução de problemas

| Sintoma | Causa e solução |
| --- | --- |
| `SUPER + D` não abre nada | `argvus launcher` · `argvus control-center launcher` · `quickshell` · `argvus` |
| `SUPER + D` não lista aplicações | As aplicações não têm entrada de desktop. Só aparecem aplicações com um ficheiro `.desktop`. |
| Os menus usam uma fonte antiga | A linha `font:` é reescrita no início da sessão. Reinicie a sessão depois de mudar a fonte. |
| `SUPER + O` informa que nenhum projeto foi encontrado | Nenhuma raiz ou caminho está configurado, ou os diretórios não existem mais. Execute `argvus projects list`. |
| `SUPER + C` / `SUPER + .` | `argvus`, `wl-clipboard`, `wtype` |
| `SUPER + H` não mostra nada | O histórico está vazio, ou o gravador da área de transferência do `argvus-session` ainda não guardou nada. |

## Componentes relacionados

| Componente | Responsabilidade |
| --- | --- |
| `argvus-hyprland` | Declara os atalhos e as regras de janela dos menus. |
| `argvus` (`argvus config`) | Guarda os projetos, os snippets e a preferência de lançador padrão. |
| `argvus` (`argvus terminal`) | Abre as sessões SSH, os terminais dos projetos e os pedidos de palavra-passe do `argvus keys`. |
| `argvus` (`argvus widget-telemetry`) | Lê o projeto ativo gravado pelo `argvus projects`. |
| `argvus` (`argvus i18n`) | Fornece as mensagens traduzidas usadas pelos scripts do launcher. |
| `argvus` (`argvus control-center`) | Edita a lista de projetos por meio do `argvus projects`. |



`/launcher/show_icons`: `true` / `false`.

`/launcher/selected_category`: `""` (All), `applications`, `windows`, `settings`, `actions`, `projects`, `ssh`, `files`, `help`.

`/launcher/application_sort`: `recent` (Abertas recentemente, predefinição) ou `alphabetical` (A–Z).

Os textos das aplicações seguem Applications Font em Control Center → Appearance → Desktop Style → Fonts. As aplicações GTK herdam gtk-font-name; os tamanhos específicos de números e títulos são mantidos. O lançador lê apps_family gerado e acompanha alterações.

**ARGVUS Área de transferência** · `argvus clipboard` · `Super + H` · `↑` `↓` (Navegar) · `/` (Pesquisar) · `Enter` (Copiar) · `Delete` (Limpar histórico) · `Esc` (Fechar)
