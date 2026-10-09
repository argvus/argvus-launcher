---
title: Launcher
description: Inicie aplicativos e menus utilitários.
slug: pt/0.4.0/docs/user-guide/applications/launcher
---

## Seletor de projetos

`argvus-projects` (`SUPER + O`) lista os projetos que você adicionou e abre o escolhido em um workspace próprio do Hyprland, com um `argvus-terminal` no diretório dele. Se o workspace do projeto já existir, apenas o seleciona.

Para acesso só pelo teclado, `SUPER + ALT + 1` a `SUPER + ALT + 9` abrem o projeto dessa posição da lista, sem o menu. As posições são os números mostrados no menu. Elas seguem a ordem da lista, então incluir ou remover um projeto pode mudá-las. `argvus-projects open <número ou nome do diretório>` faz o mesmo pelo terminal, e as falhas aparecem como notificação.

A lista efetiva de projetos é limitada a 9, já que é só isso que `SUPER + ALT + 1..9` conseguem endereçar. `argvus-projects add` (e a página Projects do Control Center, que o chama) recusa adicionar um projeto ou raiz que levaria o total além de 9, e mostra o erro correspondente.

Um projeto vem de dois lugares da seção `projects` do `argvus-config`:

- `paths`: diretórios de projeto individuais.
- `roots`: diretórios cujos subdiretórios imediatos são projetos. Uma raiz que não existe é ignorada.

Nenhuma raiz ou caminho vem configurado por padrão; adicione pelo menos um antes de o `SUPER + O` ter algo para listar.

Gerencie a lista pelo terminal:

```sh
argvus-projects add ~/Work/api          # um projeto
argvus-projects add --root ~/Clientes   # todos os subdiretórios de ~/Clientes
argvus-projects remove ~/Work/api       # remove de paths e roots
argvus-projects list                    # mostra as raízes e os caminhos
```

Se nenhuma raiz ou caminho existir, `SUPER + O` informa que nenhum projeto foi encontrado. Um editor opcional, `/projects/editor`, é iniciado no mesmo workspace quando ele é criado.

As entradas são lidas da configuração efetiva; o launcher não mantém cópia delas.

Abrir um projeto também registra o caminho dele como o projeto ativo da sessão, que o bloco de telemetria Dev Dashboard (`argvus-widget-telemetry`) lê para relatar o git, as portas em escuta e os containers desse projeto.

`argvus-launcher` fornece a configuração Rofi e menus utilitários do ARGVUS. O `argvus-config` projeta os temas, o modo e a configuração do Rofi em `data/generated/rofi/`, então toda troca de tema mantém os menus visualmente consistentes; o launcher não é dono de nenhuma saída de tema.

## SSH (`SUPER + ALT + S`)

`SUPER + ALT + S` abre um seletor com os hosts definidos em `~/.ssh/config`. O host escolhido abre em um novo terminal ARGVUS executando `ssh <host>`, no workspace atual.

### Configuração

Adicione uma entrada `Host` para cada servidor em `~/.ssh/config`:

```sshconfig
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
argvus-ssh list          # mostra os hosts configurados, um por linha
argvus-ssh open myhost    # abre um host específico sem o seletor
```

### Solução de problemas

| Sintoma | Causa e solução |
| --- | --- |
| Notificação "nenhum host encontrado em ~/.ssh/config" | O arquivo não existe ou não tem linhas `Host`. Rode `argvus-ssh list` para verificar. |
| Um host não aparece no seletor | Ele é um wildcard, vem de um arquivo `Include` ou tem caracteres fora do conjunto permitido. Coloque-o no arquivo principal com um alias simples. |
| A janela mostra um status de erro logo de início | Rode `ssh <host>` em um terminal comum para ver a mensagem completa (host inacessível, chave errada etc.). |
| A janela mostra `message.ssh_session_ended` em vez de texto | O catálogo do `argvus-i18n` instalado é mais antigo que esta versão. Reinstale o `argvus-i18n`. |

Requer `openssh` e `argvus-terminal`.

## Snippets (`SUPER + ALT + N`)

`SUPER + ALT + N` abre um seletor com seus snippets. O snippet escolhido é digitado na janela em foco, na posição do cursor, em vez de passar pela área de transferência.

### Configuração

Adicione um snippet com um nome e o texto dele:

```sh
argvus-snippets add "email" "voce@example.com"
```

Confira se ele foi gravado:

```sh
argvus-snippets list
```

Os snippets ficam na seção `snippets` do `argvus-config`, como entradas `{name, content}`. Você pode lê-los com `argvus-config get /snippets/items`.

### Uso

1. Clique no campo de texto do aplicativo que deve receber o texto.
2. Pressione `SUPER + ALT + N`.
3. Selecione o snippet pelo nome e pressione `Enter`. O texto é digitado onde está o cursor.

### Comandos

```sh
argvus-snippets add "NOME" "CONTEÚDO"  # adiciona um snippet, ou substitui o de mesmo nome
argvus-snippets remove NOME            # remove um snippet
argvus-snippets list                   # mostra índice e nome, um por linha
argvus-snippets open NOME              # digita um snippet pelo nome
argvus-snippets open 2                 # digita o snippet na posição 2 de `list`
argvus-snippets                        # abre o seletor (igual ao atalho)
argvus-snippets --help                 # mostra as opções e um exemplo
```

### Regras

- Os nomes são únicos e diferenciam maiúsculas de minúsculas. Adicionar um snippet com nome existente substitui o conteúdo dele.
- O conteúdo não pode ser vazio: um snippet vazio é informado como não encontrado.
- `open` trata um nome formado só por dígitos como posição. Use nomes com letras, como `codigo2`, para evitar ambiguidade.
- A posição segue a ordem mostrada por `list`. Remover um snippet desloca as posições dos seguintes.

### Solução de problemas

| Sintoma | Causa e solução |
| --- | --- |
| Notificação "nenhum snippet" ao pressionar o atalho | Nenhum snippet foi adicionado ainda. Rode `argvus-snippets add` primeiro. |
| `open` informa que o snippet não foi encontrado | O nome não confere exatamente. Compare com `argvus-snippets list`. |
| Nada aparece no aplicativo | A janela em foco não é um campo de texto, ou é um aplicativo X11 rodando sob XWayland, que pode ignorar esse tipo de entrada. Teste com um aplicativo Wayland nativo. |

Requer `wtype`, `rofi`, `jq` e `argvus-config`.

O `wtype` simula pressionamentos de tecla no nível de entrada do Wayland. Alguns aplicativos X11 rodando sob XWayland ignoram esses eventos, então o texto pode não aparecer neles mesmo com o snippet encontrado.
