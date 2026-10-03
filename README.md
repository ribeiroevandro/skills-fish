# skills-fish

[![Latest Release](https://img.shields.io/github/v/release/ribeiroevandro/skills-fish?color=blue&label=release)](https://github.com/ribeiroevandro/skills-fish/releases/latest)
[![Fisher](https://img.shields.io/badge/fisher-compatible-blue?logo=fishshell&logoColor=white)](https://github.com/jorgebucaran/fisher)
[![Fish Shell](https://img.shields.io/badge/fish-%E2%89%A53.0-orange?logo=fishshell&logoColor=white)](https://fishshell.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Plugin para o [Fish Shell](https://fishshell.com) que busca, instala e sincroniza skills do [skills.sh](https://skills.sh) de forma interativa.

O comando `add-skill`:

1. busca skills com `npx skills find` e mostra os resultados em um menu interativo (`gum choose`);
2. pergunta onde instalar (global ou no projeto) se nenhuma flag for informada;
3. instala a skill escolhida com `npx skills add` (com `-g` se global);
4. se instalada globalmente, cria um link simbólico da skill em `~/.gemini/antigravity-cli/skills/`, deixando-a disponível no Antigravity sem conflito com o Gemini CLI.

## Dependências

- [Fish](https://fishshell.com) 3.x ou superior
- [gum](https://github.com/charmbracelet/gum) (`brew install gum`)
- [Node.js](https://nodejs.org) (para o `npx`)
- `perl`, `grep`, `awk` e `sed` (já vêm no macOS e na maioria das distribuições Linux)

Se o `gum` ou o `npx` não estiver instalado, o `add-skill` encerra e mostra como instalar. Para o `gum`, o comando sugerido depende do gerenciador de pacotes encontrado (`brew`, `pacman`, `dnf`, `nix-env` ou `pkg`). Sem nenhum deles (por exemplo, no Debian/Ubuntu com `apt`), aparece o link da [documentação oficial](https://github.com/charmbracelet/gum#installation).

## Instalação

Com o [Fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install ribeiroevandro/skills-fish
```

## Uso

```fish
# Busca interativa por nome (pergunta o escopo: global ou projeto)
add-skill react

# Instalação direta com escopo explícito via flag
add-skill -g dono/repo@nome-da-skill
add-skill -p dono/repo@nome-da-skill

# Ajuda e versão
add-skill --help
add-skill --version
```

## Personalização de cores

As cores padrão são definidas em `conf.d/add-skill.fish` e só são aplicadas quando você ainda não definiu a variável. Para mudar alguma, defina-a no seu `~/.config/fish/config.fish`:

```fish
set -g add_skill_color_header "#cba6f7"
```

| Variável | Padrão | Uso |
|---|---|---|
| `add_skill_color_unselected` | `#6c7086` | Itens não selecionados no menu |
| `add_skill_color_header` | `#89b4fa` | Cabeçalho do menu |
| `add_skill_color_selected` | `#94e2d5` | Cursor do menu |
| `add_skill_color_error` | `#f38ba8` | Item selecionado e mensagens de erro |
| `add_skill_color_title` | `#74c7ec` | Nome da skill no spinner de busca |

## Verificação de atualizações

O `add-skill` verifica periodicamente (a cada 24 horas, via cache local em `~/.cache/skills-fish/`) se existe uma versão mais recente no GitHub e avisa quando houver. Para desativar essa checagem, adicione ao seu `~/.config/fish/config.fish`:

```fish
set -g skills_fish_check_update 0
```

## Documentação

Para aprofundar na arquitetura e funcionamento interno do plugin:

- [Arquitetura do Plugin](docs/arquitetura.md) — fluxo do comando `add-skill` e estrutura de funções.
- [Interoperabilidade com Assistentes de IA](docs/interoperabilidade-ia.md) — comparativo entre ferramentas e prevenção de conflitos de symlink.
- [Versionamento e Releases](docs/versionamento-e-releases.md) — SemVer, automação no GitHub Actions e publicação.

## Desinstalação

```fish
fisher remove ribeiroevandro/skills-fish
```
