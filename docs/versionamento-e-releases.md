# Versionamento e Processo de Releases

Este documento descreve como o **skills-fish** gerencia versões, atualizações para usuários e automação de releases no GitHub.

---

## 1. Padrão SemVer

O projeto segue estritamente o [Semantic Versioning 2.0.0](https://semver.org):

- **`0.y.z`**: Fase de desenvolvimento e evolução inicial.
- **MAJOR (`X.0.0`)**: Mudanças incompatíveis na interface CLI (ex: renomeação do comando principal ou alteração de flags).
- **MINOR (`0.X.0`)**: Novas funcionalidades compatíveis com versões anteriores (ex: novos comandos ou suporte a novos assistentes).
- **PATCH (`0.0.X`)**: Correções de bugs, ajustes de compatibilidade ou melhorias de performance.

---

## 2. Onde a Versão Fica Registrada

Como gerenciadores de plugins Fish (como o Fisher) copiam os arquivos `.fish` sem manter a pasta `.git` na máquina do usuário, a versão local ativa fica registrada na variável `_version` em `functions/add-skill.fish`:

```fish
function add-skill --description "Busca interativa, instala e sincroniza skills do skills.sh"
    set -l _version "0.1.2"
    ...
```

---

## 3. Passo a Passo para Criar um Novo Release

Para publicar uma nova versão (exemplo: `v0.1.3`):

1. **Atualize a versão no código:**
   Edite a linha 2 de `functions/add-skill.fish`:
   ```fish
   set -l _version "0.1.3"
   ```

2. **Crie o commit de bump:**
   ```bash
   git add functions/add-skill.fish
   git commit -m "chore: bump version to 0.1.3"
   git push origin main
   ```

3. **Crie e envie a tag:**
   ```bash
   git tag -a v0.1.3 -m "Release v0.1.3"
   git push origin v0.1.3
   ```

4. **Automação no GitHub Actions:**
   O workflow `.github/workflows/release.yml` detecta o push da tag `v*` e automaticamente cria a Release no GitHub com as notas dos commits:
   ```yaml
   name: Release
   on:
     push:
       tags:
         - "v*"
   ```

---

## 4. Como o Usuário Recebe a Atualização

1. **Detecção:** Na próxima execução do comando `add-skill`, a função `_add_skill_check_update` consulta o endpoint `releases/latest` do GitHub (respeitando o cache local de 24h).
2. **Aviso:** O usuário visualiza:
   ```text
   💡 Nova versão do skills-fish disponível: v0.1.3
      Atualize com: fisher update ribeiroevandro/skills-fish
   ```
3. **Atualização:** O usuário executa `fisher update ribeiroevandro/skills-fish`. O Fisher baixa o novo snapshot e atualiza os arquivos em `~/.config/fish/functions/`.
