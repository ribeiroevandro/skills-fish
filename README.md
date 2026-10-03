# skills-fish

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

## Desinstalação

```fish
fisher remove ribeiroevandro/skills-fish
```
