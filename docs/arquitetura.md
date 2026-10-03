# Arquitetura do skills-fish

O **skills-fish** é um plugin para o [Fish Shell](https://fishshell.com) desenhado para integrar o ecossistema aberto de skills ([skills.sh](https://skills.sh)) com assistentes de IA — em especial o **Antigravity** e o **Gemini CLI**.

---

## 1. Estrutura de Diretórios

O projeto segue a especificação canônica do Fish e do gerenciador [Fisher](https://github.com/jorgebucaran/fisher):

```text
skills-fish/
├── conf.d/
│   └── add-skill.fish          # Variáveis globais e tema (executado no startup do shell)
├── functions/
│   ├── add-skill.fish          # Ponto de entrada público do comando
│   ├── _add_skill_select.fish  # Busca e menu interativo (gum choose)
│   ├── _add_skill_sync.fish    # Symlink para o Antigravity (~/.gemini/antigravity-cli/skills)
│   ├── _add_skill_check_update.fish # Verificação periódica de releases no GitHub
│   └── _add_skill_gum_hint.fish # Dicas de instalação do gum por gerenciador de pacotes
├── completions/
│   └── add-skill.fish          # Autocompletar no Fish (-g, -p, -v, -h)
└── docs/                       # Documentação técnica do projeto
```

---

## 2. Fluxo de Execução (`add-skill`)

```
[Início] add-skill <query | alvo>
   │
   ├─► Flags imediatas?
   │      -v / --version  ──► Exibe versão e sai
   │      -h / --help     ──► Exibe ajuda e sai
   │
   ├─► Verificação de Atualização (_add_skill_check_update)
   │      - Consulta cache em ~/.cache/skills-fish/ (TTL: 24h)
   │      - Se expirado, consulta /releases/latest no GitHub (timeout: 1s)
   │      - Se houver versão superior, exibe banner amarelo não bloqueante
   │
   ├─► Verificação de Dependências
   │      - gum (renderização dos menus)
   │      - npx / Node.js
   │
   ├─► Resolução do Alvo
   │      - Se já contém '@' (ex: dono/repo@skill) ──► Usa direto
   │      - Se for apenas termo (ex: react)        ──► Abre menu via gum choose
   │
   ├─► Definição do Escopo de Instalação
   │      - Se passou -g/--global  ──► Global
   │      - Se passou -p/--project ──► Projeto atual
   │      - Sem flag ──────────────► Pergunta interativamente via gum choose
   │
   ├─► Execução da Instalação
   │      - Global:  npx skills add -g <alvo>
   │      - Projeto: npx skills add <alvo>
   │
   └─► Sincronização (_add_skill_sync)
          - Se Global: cria link simbólico em ~/.gemini/antigravity-cli/skills/
          - Se Projeto: dispensa links (Antigravity já lê ./.agents/skills)
```

---

## 3. Separação de Responsabilidades das Funções

- **`add-skill`**: Orquestrador principal. Valida flags via `argparse`, dispara verificações de atualização e dependências, e coordena a instalação.
- **`_add_skill_select`**: Executa `npx skills find` sob um spinner (`gum spin`), limpa códigos de escape ANSI com `perl`, formata as colunas com `awk` e exibe a seleção com cursor customizado.
- **`_add_skill_sync`**: Garante que skills instaladas globalmente em `~/.agents/skills/` fiquem visíveis para a CLI do Antigravity (`agy`) sem provocar duplicação ou conflito com o Gemini CLI.
- **`_add_skill_check_update`**: Realiza checagem SemVer pura e assíncrona/cacheada contra a API do GitHub Releases com zero impacto de latência para o usuário.
- **`_add_skill_gum_hint`**: Detecta qual gerenciador de pacotes do sistema está presente (`brew`, `pacman`, `dnf`, `nix-env`, `pkg`) para orientar a instalação do `gum` com o comando exato.
