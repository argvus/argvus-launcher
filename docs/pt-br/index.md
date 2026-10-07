---
title: Launcher
description: Inicie aplicativos e menus utilitários.
slug: pt/0.4.0/docs/user-guide/applications/launcher
---

## Seletor de projetos

`argvus-projects` (`SUPER + O`) lista os projetos que você adicionou e abre o escolhido em um workspace próprio do Hyprland, com um `argvus-terminal` no diretório dele. Se o workspace do projeto já existir, apenas o seleciona.

Para acesso só pelo teclado, `SUPER + ALT + 1` a `SUPER + ALT + 9` abrem o projeto dessa posição da lista, sem o menu. As posições são os números mostrados no menu. Elas seguem a ordem da lista, então incluir ou remover um projeto pode mudá-las. `argvus-projects open <número ou nome do diretório>` faz o mesmo pelo terminal, e as falhas aparecem como notificação.

Um projeto vem de dois lugares da seção `projects` do `argvus-config`:

- `paths`: diretórios de projeto individuais.
- `roots`: diretórios cujos subdiretórios imediatos são projetos. O padrão é `~/Projects`. Uma raiz que não existe é ignorada.

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
