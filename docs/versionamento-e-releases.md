# Versionamento e Processo de Releases

Este documento descreve como o **skills-fish** gerencia versões, atualizações para usuários e automação de releases no GitHub.

---

## 1. Padrão SemVer

O projeto segue estritamente o [Semantic Versioning 2.0.0](https://semver.org):

- **`0.y.z`**: Fase de desenvolvimento e evolução inicial.
- **MAJOR (`X.0.0`)**: Mudanças incompatíveis na interface CLI.
- **MINOR (`0.X.0`)**: Novas funcionalidades compatíveis com versões anteriores.
- **PATCH (`0.0.X`)**: Correções de bugs, ajustes de compatibilidade ou melhorias de performance.

---

## 2. Onde a Versão Fica Registrada

Como gerenciadores de plugins Fish (como o Fisher) copiam os arquivos `.fish` sem manter a pasta `.git` na máquina do usuário, a versão local ativa fica registrada na variável `_version` em `functions/skills.fish`:

```fish
function skills --description "Gerenciador de skills (plugins) e integrações de ferramentas de IA para o Fish shell"
    set -l _version "0.6.1"
    ...
```

---

## 3. Passo a Passo para Criar um Novo Release

O projeto conta com um alvo de automação no [Makefile](file:///Users/ribeiroevandro/workspace/opensource/skills-fish/Makefile) que executa todo o fluxo de release com um único comando:

```bash
make release v=0.7.0
```

### O que o `make release` faz automaticamente:
1. Atualiza `_version` em `functions/skills.fish`.
2. Atualiza as asserções de versão em `tests/skills.test.fish`.
3. Executa a validação de sintaxe e os testes com `fishtape`.
4. Cria o commit `chore: bump version to <v>`.
5. Cria a tag anotada `v<v>`.
6. Envia o commit para a branch `main` e a tag para o GitHub.
7. O GitHub Actions (`.github/workflows/release.yml`) detecta a tag e publica a **Release oficial** com notas geradas automaticamente.

---

## 4. Como o Usuário Recebe a Atualização

1. **Detecção:** Na próxima execução de qualquer comando `skills`, a função `_skills_check_update` consulta o endpoint de release mais recente no GitHub (respeitando o cache local de 24h e usando redirect HTTP para evitar rate limits).
2. **Aviso:** Se houver versão superior, o usuário visualiza:
   ```text
   💡 Nova versão do skills-fish disponível: v0.7.0
      Atualize com: fisher update ribeiroevandro/skills-fish
   ```
3. **Atualização:** O usuário executa `fisher update ribeiroevandro/skills-fish`. O Fisher baixa o novo snapshot e atualiza os arquivos em `~/.config/fish/functions/`.
