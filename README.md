# skills-fish

[![Latest Release](https://img.shields.io/github/v/release/ribeiroevandro/skills-fish?color=blue&label=release)](https://github.com/ribeiroevandro/skills-fish/releases/latest)
[![CI](https://github.com/ribeiroevandro/skills-fish/actions/workflows/ci.yml/badge.svg)](https://github.com/ribeiroevandro/skills-fish/actions/workflows/ci.yml)
[![Fisher](https://img.shields.io/badge/fisher-compatible-blue?logo=fishshell&logoColor=white)](https://github.com/jorgebucaran/fisher)
[![Fish Shell](https://img.shields.io/badge/fish-%E2%89%A53.0-orange?logo=fishshell&logoColor=white)](https://fishshell.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Plugin para o [Fish Shell](https://fishshell.com) que gerencia, busca e sincroniza skills do ecossistema [skills.sh](https://skills.sh) com assistentes de IA (Antigravity, Claude Code, Cursor, Codex, Gemini CLI e outros).

O comando `skills` é um wrapper 100% compatível com a CLI oficial `npx skills`, trazendo melhorias nativas para o terminal Fish:

1. **Busca interativa** com `skills add <termo>` via `gum choose`;
2. **Sincronização automática** com o Antigravity (`~/.gemini/antigravity-cli/skills/`) quando uma skill for instalada globalmente, prevenindo conflitos com o Gemini CLI;
3. **Autocompletar nativo completo** no Fish para todos os comandos e flags;
4. **Verificação periódica e não intrusiva de novas versões**.

## Dependências

- [Fish](https://fishshell.com) 3.x ou superior
- [gum](https://github.com/charmbracelet/gum) (`brew install gum`)
- [Node.js](https://nodejs.org) (para o `npx`)
- `grep` e `awk` (já vêm no macOS e na maioria das distribuições Linux)

Se o `gum` ou o `npx` não estiver instalado, o comando encerra e mostra instruções de instalação para o seu sistema.

## Instalação

Com o [Fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install ribeiroevandro/skills-fish
```

## Uso

```fish
# Busca e instalação interativa
skills add react

# Instalação direta (suporta todas as flags do npx skills)
skills add -g vercel-labs/agent-skills@vercel-optimize

# Listar skills instaladas (projeto ou global)
skills list
skills list -g

# Remover skills
skills remove react

# Atualizar skills
skills update

# Ajuda e versão
skills --help
skills --version
```

## Personalização de cores

As cores padrão são definidas em `conf.d/skills.fish` e preservam personalizações do usuário. Para mudar alguma, defina-a no seu `~/.config/fish/config.fish`:

```fish
set -g skills_color_header "#cba6f7"
```

| Variável | Padrão | Uso |
|---|---|---|
| `skills_color_unselected` | `#6c7086` | Itens não selecionados no menu |
| `skills_color_header` | `#89b4fa` | Cabeçalho do menu |
| `skills_color_selected` | `#94e2d5` | Cursor do menu |
| `skills_color_error` | `#f38ba8` | Item selecionado e mensagens de erro |
| `skills_color_title` | `#74c7ec` | Nome da skill no spinner de busca |

## Verificação de atualizações

O `skills` verifica periodicamente (a cada 24 horas, via cache local em `~/.cache/skills-fish/`) se existe uma versão mais recente no GitHub e avisa de forma não bloqueante. Para desativar essa checagem, adicione ao seu `~/.config/fish/config.fish`:

```fish
set -g skills_fish_check_update 0
```

## Documentação

Para aprofundar na arquitetura e funcionamento interno do plugin:

- [Arquitetura do Plugin](docs/arquitetura.md) — fluxo do comando `skills`, separação de funções e wrapper.
- [Interoperabilidade com Assistentes de IA](docs/interoperabilidade-ia.md) — comparativo entre ferramentas e prevenção de conflitos de symlink.
- [Versionamento e Releases](docs/versionamento-e-releases.md) — SemVer, Makefile, automação no GitHub Actions e publicação.

## Desinstalação

```fish
fisher remove ribeiroevandro/skills-fish
```
