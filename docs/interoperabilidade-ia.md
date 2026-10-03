# Interoperabilidade de Skills entre Assistentes de IA

Este documento explica como diferentes assistentes de IA localizam skills e como o **skills-fish** garante compatibilidade total sem conflitos.

---

## 1. O Padrão Agent Skills

O ecossistema utiliza o padrão aberto [Agent Skills](https://agentskills.io/specification). Qualquer skill compatível possui a estrutura:

```text
minha-skill/
├── SKILL.md        # Obrigatório: YAML frontmatter + instruções em Markdown
├── scripts/        # Opcional: scripts auxiliares executáveis
├── references/     # Opcional: documentação complementar
└── assets/         # Opcional: templates, diagramas ou recursos estáticos
```

No cabeçalho (`SKILL.md`):
```yaml
---
name: minha-skill
description: O que a skill faz e quando o assistente deve ativá-la.
---
```

**Carregamento sob demanda (Progressive Disclosure):** os assistentes leem apenas o `name` e a `description` no início da sessão (~100 tokens). O corpo completo só entra na janela de contexto se o assistente julgar necessário ou se o usuário invocá-la diretamente.

---

## 2. Onde Cada Ferramenta Procura Skills

| Ferramenta | Skills do Projeto (Workspace) | Skills Globais (Usuário) | Invocação Direta |
|---|---|---|---|
| **Antigravity (`agy`)** | `.agents/skills/`, `.agent/skills/` | `~/.gemini/antigravity-cli/skills/` | Ativação automática ou via prompt |
| **Gemini CLI** | `.gemini/skills/` ou `.agents/skills/` | `~/.gemini/skills/` ou `~/.agents/skills/` | Comandos `gemini skills ...` |
| **Claude Code** | `.claude/skills/` | `~/.claude/skills/` | `/nome-da-skill` |
| **Codex** | `.agents/skills/` | `~/.agents/skills/` | `$nome` ou `/skills` |
| **Cursor** | `.cursor/skills/` | `~/.cursor/skills/` | `/nome-da-skill` no chat |
| **GitHub Copilot** | `.github/skills/` | `~/.copilot/skills/` | `/nome-da-skill` |
| **Windsurf** | `.windsurf/skills/` | `~/.codeium/windsurf/skills/` | Interface (Cascade → Skills) |

---

## 3. O Problema Resolvido: Antigravity vs. Gemini CLI

Ao rodar `npx skills add -g <skill>`, o CLI oficial instala a skill em:
```text
~/.agents/skills/<nome-da-skill>
```

### O Risco do Conflito:
- A **Gemini CLI** lê nativamente tanto `~/.agents/skills/` quanto `~/.gemini/skills/`.
- Se criássemos um link simbólico da skill em `~/.gemini/skills/`, a Gemini CLI detectaria a mesma skill em dois diretórios ao mesmo tempo e emitiria erros como:
  ```text
  Skill conflict detected: "nome-da-skill" is overriding the same skill
  ```

### A Solução do skills-fish:
O Antigravity possui diretórios segregados:
- **Global exclusivo (`agy`):** `~/.gemini/antigravity-cli/skills/`
- **Compartilhado (Gemini CLI):** `~/.gemini/skills/`

A função `_add_skill_sync` do `skills-fish` aponta o link simbólico exclusivamente para `~/.gemini/antigravity-cli/skills/`:
```text
~/.agents/skills/<skill>  ──►  ~/.gemini/antigravity-cli/skills/<skill> (symlink)
```

**Resultado:**
1. A **Gemini CLI** lê diretamente de `~/.agents/skills/` sem encontrar duplicatas.
2. O **Antigravity** enxerga a skill em suas skills Globais imediatamente.
3. Não há poluição cruzada nem conflito de sobreposição.
