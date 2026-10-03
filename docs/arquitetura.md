# Arquitetura do skills-fish

O **skills-fish** é um plugin para o [Fish Shell](https://fishshell.com) que atua como um wrapper completo para o [skills.sh](https://skills.sh) (`npx skills`), integrando-o de forma nativa e ergonômica com assistentes de IA — em especial o **Antigravity** e o **Gemini CLI**.

---

## 1. Estrutura de Diretórios

O projeto segue a especificação canônica do Fish e do gerenciador [Fisher](https://github.com/jorgebucaran/fisher):

```text
skills-fish/
├── conf.d/
│   └── skills.fish             # Variáveis globais e paleta de cores (startup)
├── functions/
│   ├── skills.fish             # Ponto de entrada público do comando wrapper
│   ├── _skills_select.fish     # Busca e menu interativo (gum choose)
│   ├── _skills_sync.fish       # Symlink para o Antigravity (~/.gemini/antigravity-cli/skills)
│   ├── _skills_check_update.fish # Verificação de releases (redirect HTTP, sem rate limit)
│   └── _skills_gum_hint.fish   # Dicas de instalação do gum por gerenciador de pacotes
├── completions/
│   └── skills.fish             # Autocompletar completo para todos os comandos e flags
├── tests/
│   └── skills.test.fish        # Suíte de testes com fishtape (TAP v13)
├── Makefile                    # Automação de testes, dev, deploy e releases
└── docs/                       # Documentação técnica do projeto
```

---

## 2. Fluxo de Execução (`skills`)

```
[Início] skills [subcomando] [opções / alvos]
   │
   ├─► Flags imediatas?
   │      -v / --version  ──► Exibe versão do skills-fish e do npx skills e sai
   │      -h / --help     ──► Exibe ajuda e sai
   │      (sem argumentos)──► Exibe ajuda amigável da CLI
   │
   ├─► Verificação de Dependências
   │      - gum (renderização dos menus)
   │      - npx / Node.js
   │
   ├─► Verificação de Atualização (_skills_check_update)
   │      - Consulta cache em ~/.cache/skills-fish/ (TTL: 24h)
   │      - Se expirado, consulta redirect de /releases/latest no GitHub
   │      - Se houver versão superior, exibe banner amarelo não bloqueante
   │
   ├─► O subcomando é 'add' ou 'a'?
   │      │
   │      ├─► SIM:
   │      │    1. Separa flags (-g, -y, etc.) de alvos (dono/repo@skill ou nome)
   │      │    2. Se for nome simples: busca interativamente via _skills_select
   │      │    3. Executa: npx skills add [flags] <alvo>
   │      │    4. Se instalado em ~/.agents/skills (escopo global):
   │      │       executa _skills_sync para vincular ao Antigravity
   │      │
   │      └─► NÃO:
   │           Repassa todos os argumentos diretamente:
   │           npx skills $argv
```

---

## 3. Separação de Responsabilidades das Funções

- **`skills`**: Ponto de entrada e orquestrador principal. Trata ajuda, versão, dependências, checagem de updates e delega para o `_skills_select` ou repassa para o binário `npx skills`.
- **`_skills_select`**: Executa `npx skills find` com spinner (`gum spin`), remove códigos de escape ANSI com `perl`, alinha colunas com `awk` e renderiza a seleção com `gum choose`.
- **`_skills_sync`**: Cria o link simbólico das skills instaladas globalmente (`~/.agents/skills/<skill>`) diretamente em `~/.gemini/antigravity-cli/skills/<skill>`, deixando-as disponíveis no Antigravity CLI sem conflito com o Gemini CLI.
- **`_skills_check_update`**: Compara SemVer da versão local contra a release oficial no GitHub utilizando redirect HTTP (`curl -sIL`) para contornar limitações de taxa (rate limit) de chamadas de API não autenticadas.
- **`_skills_gum_hint`**: Detecta o gerenciador de pacotes da máquina (`brew`, `pacman`, `dnf`, `nix-env`, `pkg`) para instruir a instalação do `gum` caso ausente.
