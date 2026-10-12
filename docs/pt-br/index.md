---
title: Launcher
description: Abra aplicativos, projetos, hosts SSH e snippets, escolha emojis, faça contas e consulte cheatsheets pelos menus Rofi do ARGVUS.
slug: de/argvus-launcher/docs/pt-br/index.md
---

`argvus-launcher` fornece a configuração Rofi, os temas e os menus que o ARGVUS usa para abrir coisas pelo teclado. Ele contém:

- o lançador de aplicativos (`SUPER + D`);
- a configuração e os temas do Rofi, compartilhados por todos os menus Rofi do ARGVUS;
- o seletor de projetos, o seletor de hosts SSH e o seletor de snippets (`argvus projects`, `argvus ssh`, `argvus snippets`);
- o gerenciador de chaves SSH (`argvus keys`), que cria, lista, carrega e apaga pares de chaves;
- o seletor de emojis, o visualizador de cheatsheets e o menu da calculadora.

Os atalhos são declarados pelo `argvus-hyprland`. Este pacote fornece os comandos e os menus por trás deles.

## Atalhos

| Atalho | Ação | Comando | Seção |
| --- | --- | --- | --- |
| `SUPER + D` | Lançador de aplicativos | `argvus launcher` | Lançador de aplicativos |
| `SUPER + O` | Seletor de projetos | `argvus projects` | Seletor de projetos |
| `SUPER + ALT + 1` a `9` | Abre o projeto nessa posição | `argvus projects open N` | Seletor de projetos |
| `SUPER + ALT + S` | Seletor de hosts SSH | `argvus ssh` | SSH |
| `SUPER + ALT + N` | Seletor de snippets | `argvus snippets` | Snippets |
| `SUPER + ALT + G` | Seletor de projetos, depois a TUI de git | `argvus git` | Git |
| `SUPER + .` | Seletor de emojis | `emoji-picker.sh` | Seletor de emojis |
| `SUPER + C` | Calculadora | `rofi -show calc` | Calculadora |
| `SUPER + SHIFT + /` | Cheatsheet do Hyprland | `cheatsheets.sh hypr` | Cheatsheets |
| `SUPER + CTRL + /` | Cheatsheet do Kitty | `cheatsheets.sh kitty` | Cheatsheets |

## Lançador de aplicativos (`SUPER + D`)

`SUPER + D` executa `argvus launcher`, que abre o Rofi no modo `drun`. Ele lista os aplicativos gráficos instalados com uma entrada de desktop, e o escolhido é iniciado ao pressionar `Enter`.

1. Pressione `SUPER + D`.
2. Digite parte do nome do aplicativo. A lista é ordenada e o filtro ignora maiúsculas e minúsculas.
3. Pressione `Enter` para iniciar o aplicativo, ou `Esc` para fechar o menu.

```sh
argvus launcher                  # abre o menu de aplicativos
argvus launcher --config CAMINHO # usa outro arquivo de configuração do Rofi
```

Qualquer outro argumento é repassado ao `rofi`. `--config` sem valor termina com erro.

O Hyprland executa `argvus launcher --config <configuração Rofi>` quando o lançador padrão é `rofi`, que é o padrão. Se o `launcher` nos aplicativos padrão for outro programa, o Hyprland executa `<programa> --show drun`. Defina essa preferência nos aplicativos padrão do Control Center, que a grava no `argvus-config`.

Só aparecem na lista os aplicativos com uma entrada de desktop. Um aplicativo que não instala arquivo `.desktop` não é encontrado aqui.

## Configuração e temas do Rofi

O pacote instala a configuração do Rofi em `/usr/share/argvus/launcher/config/`:

| Arquivo | Função |
| --- | --- |
| `config.rasi` | Ponto de entrada usado por todos os menus do ARGVUS. Define o `configuration` do Rofi (fonte, sem ícones, lista ordenada, correspondência sem diferenciar maiúsculas) e importa o `theme.rasi`. |
| `theme.rasi` | Cores e layout da janela, da barra de entrada e da lista. Importa um tema e o arquivo de modo. |
| `mode.rasi` | Ajuste de modo. O arquivo empacotado não tem ajustes e mantém o modo Dark. |
| `themes/<família>/theme.rasi` | Paleta de uma família de temas, por exemplo `argvus-dark` ou `tokyo-night`. |
| `themes/<família>-float/theme.rasi` | Variante Float da mesma família. |

O pacote traz 22 famílias, e cada uma tem uma variante `-float`. O `theme.rasi` empacotado importa `argvus-dark`.

### Onde fica a configuração ativa

O ARGVUS resolve cada arquivo do Rofi por meio de `paths_config`. Vale o primeiro arquivo existente entre os overrides do usuário, a cópia do usuário, os locais legados e a árvore gerada; caso contrário, usa-se o arquivo empacotado em `/usr/share/argvus/launcher/config/`. A cópia do usuário de um arquivo é `$XDG_CONFIG_HOME/argvus/data/rofi/<arquivo>`: o prefixo `launcher/config/` é guardado em `rofi/`.

O ARGVUS cria uma cópia do usuário na primeira vez que um script do ARGVUS altera o arquivo; o `argvus-appearance` faz isso nas mudanças de tema, accent e modo. Arquivos nunca alterados continuam sendo lidos do pacote, e a cópia do usuário tem precedência sobre o arquivo empacotado.

Quando o `argvus-session` aplica a fonte na inicialização da sessão, ele reescreve a linha `font:` do `config.rasi` com a fonte definida nas configurações do ARGVUS. Essa edição só chega à cópia do usuário. Enquanto a cópia não existir, o arquivo encontrado é o empacotado, que o usuário não pode alterar; assim, a mudança de fonte passa a valer depois que a primeira mudança de aparência criar a cópia.

### Trocando o tema

O `argvus-appearance` é quem muda o tema. Ao trocar, ele reescreve as cópias do usuário para que o `config.rasi` aponte para o novo `theme.rasi`, e o `theme.rasi` importe a família escolhida. O layout Float seleciona a variante `-float` da família ativa. Os seletores de tema e de layout leem o mesmo `config.rasi`, então também usam o estilo ativo.

Não edite os arquivos em `/usr/share/argvus/launcher/`: eles são substituídos na atualização do pacote. Faça as alterações na cópia do usuário, em `$XDG_CONFIG_HOME/argvus/data/rofi/`.

## Seletor de projetos (`SUPER + O`)

`argvus projects` (`SUPER + O`) lista os projetos que você adicionou e abre o escolhido em um workspace próprio do Hyprland, com um `argvus terminal` no diretório dele. Se o workspace do projeto já existir, o seletor apenas o foca.

Para acesso só pelo teclado, `SUPER + ALT + 1` a `SUPER + ALT + 9` abrem o projeto dessa posição da lista, sem o menu. As posições são os números mostrados no menu. Elas seguem a ordem da lista, então incluir ou remover um projeto pode mudá-las. `argvus projects open <número ou nome do diretório>` faz o mesmo pelo terminal, e as falhas aparecem como notificação.

A lista efetiva de projetos é limitada a 9, já que é só isso que `SUPER + ALT + 1..9` conseguem endereçar. `argvus projects add` (e a página Projects do Control Center, que o chama) recusa adicionar um projeto ou raiz que levaria o total além de 9, e mostra o erro correspondente.

Um projeto vem de dois lugares da seção `projects` do `argvus-config`:

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

Abrir um projeto também registra o caminho dele como o projeto ativo da sessão, que o bloco de telemetria Dev Dashboard (`argvus-widget-telemetry`) lê para relatar o git, as portas em escuta e os containers desse projeto.

## SSH (`SUPER + ALT + S`)

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

1. Pressione `SUPER + ALT + S`.
2. Digite parte do nome do host, ou use as setas.
3. Pressione `Enter`. O terminal abre e executa `ssh <host>`.

Quando a sessão termina, a janela continua aberta e mostra o status de saída, por exemplo `ssh encerrou com status 0. Pressione Enter para fechar.` Pressione `Enter` para fechá-la. Isso importa para forges como GitHub, GitLab e Gitea: eles autenticam você e encerram a conexão logo em seguida, porque não oferecem shell. A janela mantém a mensagem deles na tela em vez de fechar.

### Regras

- Entradas com wildcard (`Host *`, `Host *.internal`) são blocos de correspondência, não destinos, e nunca aparecem na lista.
- Cada alias em uma linha `Host` aparece separadamente (`Host a b` lista `a` e `b`). Duplicatas são removidas.
- Hosts definidos apenas em arquivos carregados por `Include` não aparecem; o seletor lê somente o arquivo principal.
- Só são abertos aliases formados por letras, dígitos, `.`, `-` e `_`. Qualquer outro nome é recusado com uma notificação.
- Quebras de linha no formato Windows (CRLF) no arquivo de configuração são aceitas.
- `ARGVUS_SSH_CONFIG` substitui o caminho do arquivo de configuração, útil para testes.

### Comandos

```sh
argvus ssh list          # mostra os hosts configurados, um por linha
argvus ssh open myhost   # abre um host específico sem o seletor
```

### Solução de problemas

| Sintoma | Causa e solução |
| --- | --- |
| Notificação "nenhum host encontrado em ~/.ssh/config" | O arquivo não existe ou não tem linhas `Host`. Rode `argvus ssh list` para verificar. |
| Um host não aparece no seletor | Ele é um wildcard, vem de um arquivo `Include` ou tem caracteres fora do conjunto permitido. Coloque-o no arquivo principal com um alias simples. |
| A janela mostra um status de erro logo de início | Rode `ssh <host>` em um terminal comum para ver a mensagem completa (host inacessível, chave errada etc.). |
| A janela mostra `message.ssh_session_ended` em vez de texto | O catálogo do `argvus-i18n` instalado é mais antigo que esta versão. Reinstale o `argvus-i18n`. |

Requer `openssh` e `argvus-terminal`.

## Chaves SSH (`argvus keys`)

`argvus keys` gerencia os pares de chaves em `~/.ssh` e as chaves carregadas no ssh-agent. Não tem atalho. A página **Chaves SSH** do Control Center (Aplicativos) usa os mesmos comandos.

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

- O nome da chave vira nome de arquivo em `~/.ssh`, então só pode ter letras, dígitos, ponto, hífen e sublinhado. Não pode começar com ponto nem terminar em `.pub`. Um par existente nunca é sobrescrito.
- Só são listados, carregados, descarregados ou apagados os pares que têm arquivo de chave pública (`NOME.pub`).
- A senha nunca é passada como argumento de comando, gravada em log nem exibida no Control Center. `load` e `generate --passphrase` abrem um terminal ARGVUS, e o OpenSSH lê o segredo desse terminal.
- `list` mostra `unknown` na coluna `carregada` quando o agente não pode ser alcançado. Ele nunca adivinha.
- `delete` remove a chave privada de forma definitiva. Guarde uma cópia de qualquer chave que ainda seja necessária.
- `ARGVUS_SSH_DIR` substitui `~/.ssh`, o que é útil para testes.

O agente é o serviço de usuário `argvus-ssh-agent.service`, iniciado pelo `argvus-session`. Na sessão, `SSH_AUTH_SOCK` aponta para ele.

Requer `openssh` (`ssh-keygen` e `ssh-add`) e `argvus-terminal`.

| Sintoma | Causa e correção |
| --- | --- |
| `load` abre um terminal, mas a chave não é carregada | Digite a senha nesse terminal. Se ela não foi pedida, rode `ssh-add -l` para ver o que o agente tem. |
| O terminal mostra `Could not open a connection to your authentication agent` | O Hyprland foi iniciado antes do agente, então os terminais dele não têm `SSH_AUTH_SOCK`. O launcher usa `$XDG_RUNTIME_DIR/ssh-agent.socket` como alternativa; atualize o `argvus-launcher` e abra um terminal novo. |
| `list` mostra `unknown` na coluna `carregada` | O agente não está acessível. Verifique `systemctl --user status argvus-ssh-agent.service` e a variável `SSH_AUTH_SOCK`. |
| `delete` informa que a chave está carregada | Rode antes `argvus keys unload NOME` e depois apague de novo. |
| `generate` informa que o nome já existe | Escolha outro nome. Pares existentes nunca são substituídos. |

## Snippets (`SUPER + ALT + N`)

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

1. Clique no campo de texto do aplicativo que deve receber o texto.
2. Pressione `SUPER + ALT + N`.
3. Selecione o snippet pelo nome e pressione `Enter`. O texto é digitado onde está o cursor.

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
| Notificação "nenhum snippet" ao pressionar o atalho | Nenhum snippet foi adicionado ainda. Rode `argvus snippets add` primeiro. |
| `open` informa que o snippet não foi encontrado | O nome não confere exatamente. Compare com `argvus snippets list`. |
| Nada aparece no aplicativo | A janela em foco não é um campo de texto, ou é um aplicativo X11 rodando sob XWayland, que pode ignorar esse tipo de entrada. Teste com um aplicativo Wayland nativo. |

Requer `wtype`, `rofi`, `jq` e `argvus-config`.

O `wtype` simula pressionamentos de tecla no nível de entrada do Wayland. Alguns aplicativos X11 rodando sob XWayland ignoram esses eventos, então o texto pode não aparecer neles mesmo com o snippet encontrado.

## Git (`SUPER + ALT + G`)

`SUPER + ALT + G` abre o mesmo seletor de projetos do `SUPER + O`. Ao escolher um projeto, o `lazygit` (ou o `gitui`) abre direto nele, em um novo terminal ARGVUS no workspace atual. Não há uma etapa separada para escolher o projeto antes.

### Configuração

Instale uma das duas ferramentas. As duas são dependências opcionais deste pacote:

```sh
sudo pacman -S lazygit   # ou: sudo pacman -S gitui
```

### Uso

1. Pressione `SUPER + ALT + G`.
2. Escolha um projeto na lista, ou pressione `Esc` para cancelar. Cancelar não abre nada.
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

`SUPER + .` abre o `rofimoji` com a configuração Rofi do ARGVUS. Procure um emoji pelo nome, pressione `Enter`, e o emoji é copiado para a área de transferência. Cole-o com `Ctrl + V` no aplicativo desejado.

Enquanto o seletor está aberto, a sessão ignora as notificações de troca de layout de teclado que mostraria de outra forma. O launcher grava uma marca de curta duração no diretório de cache do ARGVUS e a remove cerca de um segundo depois que o seletor fecha.

Requer `rofimoji` e `wl-clipboard`.

## Calculadora (`SUPER + C`)

`SUPER + C` abre o modo `calc` do Rofi com a configuração Rofi do ARGVUS. Digite uma expressão, e a lista de resultados é atualizada enquanto você digita. Escolha um resultado conforme o modo `rofi-calc` define.

O pacote do launcher fornece a configuração Rofi e depende do `rofi-calc`. O atalho em si é declarado pelo `argvus-hyprland`.

## Cheatsheets (`SUPER + SHIFT + /` e `SUPER + CTRL + /`)

`cheatsheets.sh` mostra uma lista somente leitura de atalhos em uma janela Rofi grande. Ele recebe o nome do aplicativo como argumento:

```sh
cheatsheets.sh hypr     # atalhos do Hyprland (SUPER + SHIFT + /)
cheatsheets.sh kitty    # atalhos do terminal (SUPER + CTRL + /)
cheatsheets.sh <nome>   # qualquer outro aplicativo com cheatsheet
```

- `hypr` usa `data/generated/hypr/keybindings.txt` da configuração ARGVUS do usuário quando esse arquivo existe. Caso contrário, usa o cheatsheet do Hyprland distribuído com o `argvus-hyprland`.
- `kitty` usa o cheatsheet do terminal distribuído com o `argvus terminal`.
- Qualquer outro nome lê `<nome>/docs/cheatsheets/<idioma>.txt`. Se esse arquivo não existir, nenhuma janela é aberta.

O idioma é português quando o locale do sistema é `pt-BR`, e inglês nos demais casos. `Esc` fecha a janela. Selecionar uma linha apenas fecha a janela; nada é executado.

## Outros menus que usam a configuração Rofi

A configuração do launcher é compartilhada com componentes de outros pacotes:

- O histórico da área de transferência (`SUPER + H`) e o atalho para limpá-lo (`SUPER + SHIFT + H`) são declarados pelo `argvus-hyprland`. Eles enviam a saída do `cliphist` para o Rofi com esta configuração. O `cliphist` vem do `argvus-session`, que executa o gravador da área de transferência que alimenta o histórico; o meta-pacote `argvus` também depende dele.
- Os seletores de tema, de accent e de layout do `argvus-appearance` abrem o Rofi com o `config.rasi`.
- As regras de janela do Hyprland reconhecem os namespaces `argvus-launcher` e `rofi`, então os menus recebem o tratamento de superfície do launcher.

## Empacotamento e dependências

O pacote `argvus-launcher` é independente de arquitetura e instala:

- `/usr/lib/argvus/commands/argvus-launcher`, `argvus-projects`, `argvus-snippets`, `argvus-ssh`, `argvus-keys` e `argvus-git`, no mesmo diretório;
- `/usr/share/argvus/launcher/config/`, com a configuração e os temas do Rofi;
- `/usr/share/argvus/launcher/sh/`, com `cheatsheets.sh` e `emoji-picker.sh`.

Dependências obrigatórias: `argvus-session`, `argvus-appearance`, `argvus-config`, `argvus-i18n`, `argvus-terminal`, `bash`, `jq`, `hyprland`, `libnotify`, `rofi`, `rofi-calc`, `rofimoji`, `wl-clipboard` e `wtype`. Dependências opcionais: `openssh`, para o seletor SSH e o gerenciador de chaves; `lazygit` e `gitui`, para a TUI de git.

A instalação do pacote não grava nada em `$HOME`. A configuração do usuário é criada no início da sessão, como descrito em [Configuração e temas do Rofi](#onde-fica-a-configuração-ativa).

## Solução de problemas

| Sintoma | Causa e solução |
| --- | --- |
| `SUPER + D` não abre nada | Rode `argvus launcher` em um terminal. Confirme que o `rofi` está instalado e que a configuração Rofi existe. |
| `SUPER + D` não lista aplicativos | Os aplicativos não têm entrada de desktop. Só aparecem aplicativos com um arquivo `.desktop`. |
| Os menus usam uma fonte antiga | A linha `font:` é reescrita no início da sessão. Reinicie a sessão depois de mudar a fonte. |
| Uma troca de tema não chega aos menus Rofi | Verifique se a cópia do usuário do `config.rasi`, em `$XDG_CONFIG_HOME/argvus/data/rofi/`, ainda aponta para o tema empacotado. Aplique o tema de novo pelo `argvus-appearance`. |
| `SUPER + O` informa que nenhum projeto foi encontrado | Nenhuma raiz ou caminho está configurado, ou os diretórios não existem mais. Rode `argvus projects list`. |
| `SUPER + C` ou o seletor de emojis não abre | Instale `rofi-calc` ou `rofimoji` (ambos são dependências obrigatórias). |
| Um cheatsheet não abre | O arquivo desse nome e idioma não existe. Confira os caminhos descritos na seção Cheatsheets. |
| `SUPER + H` não mostra nada | O histórico está vazio, ou o gravador da área de transferência do `argvus-session` ainda não guardou nada. |

## Componentes relacionados

| Componente | Responsabilidade |
| --- | --- |
| `argvus-hyprland` | Declara os atalhos e as regras de janela dos menus. |
| `argvus-appearance` | Troca o tema, o accent e o layout ativos, e reescreve as referências de tema do Rofi. |
| `argvus-config` | Guarda os projetos, os snippets e a preferência de lançador padrão. |
| `argvus-session` | Copia a configuração inicial do Rofi e define a fonte no início da sessão. |
| `argvus-terminal` | Abre as sessões SSH, os terminais dos projetos e os pedidos de senha do `argvus keys`. |
| `argvus-widget-telemetry` | Lê o projeto ativo gravado pelo `argvus projects`. |
| `argvus-i18n` | Fornece as mensagens traduzidas usadas pelos scripts do launcher. |
| `argvus-control-center` | Edita a lista de projetos por meio do `argvus projects`. |
