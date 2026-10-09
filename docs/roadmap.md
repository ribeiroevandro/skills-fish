# Roadmap - skills-fish

Este documento lista as ideias e oportunidades de melhoria para o ecossistema do plugin. Ele está dividido entre o que está ativamente planejado para desenvolvimento e o que é apenas desejo (wishlist) ou está em fase de estudo.

## 🎯 Planejado (Roadmap Ativo)

Estas tarefas já estão validadas e aguardam desenvolvimento:

### 1. Melhorias na Experiência do Usuário (UX)
- [ ] **`skills remove` interativo:** Fazer com que a execução de `skills remove` (sem argumentos) abra um menu visual (`gum choose`) listando as skills atualmente instaladas, permitindo a seleção rápida com as setas do teclado.
- [ ] **`skills update` interativo:** Exibir uma lista de skills permitindo seleção múltipla (`gum choose --no-limit`) para que o usuário escolha exatamente quais deseja atualizar.

### 2. Autocompletar Dinâmico (Completions)
- [ ] **Sugestões dinâmicas no `remove` e `update`:** Expandir o script em `completions/skills.fish` para varrer os diretórios `.agents/skills/` (locais e globais) em tempo real. Isso fará com que apertar `<TAB>` sugira os nomes exatos das skills que o usuário realmente possui instaladas.

### 3. Sincronização e Manutenção de Estado
- [ ] **Limpeza de Symlinks Fantasmas:** Adicionar um gatilho ("hook") no comando de remoção para varrer a pasta do Antigravity (`~/.gemini/antigravity-cli/skills/`) e excluir os symlinks quebrados que sobram quando o npx remove a pasta de origem da skill.
- [ ] **Comando utilitário `skills sync`:** Adicionar um subcomando (ou flag) dedicado para forçar uma verificação em lote, recriando todos os atalhos simbólicos entre as skills globais e as ferramentas de IA de uma só vez.

---

## 💡 Wishlist (Em Estudo / Ideias)

Itens nesta lista são boas ideias, mas não possuem prazo ou garantia de que serão implementados. Estão aqui para instigar a comunidade e analisar viabilidade.

### Expansão e Portabilidade do Ecossistema
- [ ] **Suporte a outros Shells (Zsh / Bash):** Estudar a criação de versões do plugin para outros interpretadores (como `skills-zsh`). Avaliar se a manutenção de múltiplos repositórios compensa ou se o público focado em IA estaria mais disposto a migrar para o Fish.
