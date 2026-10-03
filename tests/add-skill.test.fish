source conf.d/add-skill.fish
source functions/_add_skill_gum_hint.fish
source functions/_add_skill_select.fish
source functions/_add_skill_sync.fish
source functions/_add_skill_check_update.fish
source functions/add-skill.fish

@test "mostra versão com flag -v" (
    add-skill -v
) = "add-skill 0.2.0"

@test "mostra versão com flag --version" (
    add-skill --version
) = "add-skill 0.2.0"

@test "mostra ajuda com flag -h com status 0" (
    add-skill -h >/dev/null
    echo $status
) = 0

@test "mostra ajuda com flag --help com status 0" (
    add-skill --help >/dev/null
    echo $status
) = 0

@test "ajuda exibe cabeçalho de uso esperado" (
    add-skill -h
)[1] = "Uso: add-skill [opções] <nome-da-skill | dono/repo@skill>"

@test "falha com status 1 quando nenhum argumento é passado" (
    add-skill 2>/dev/null
    echo $status
) = 1

@test "função de sync retorna 0 com segurança quando a skill não existe localmente" (
    _add_skill_sync "owner/repo@nonexistent-skill-xyz"
    echo $status
) = 0

@test "checagem de atualização sai com status 0 quando desativada por variável" (
    set -l skills_fish_check_update 0
    _add_skill_check_update 0.2.0
    echo $status
) = 0

@test "detector de gum hint retorna comando não vazio" (
    _add_skill_gum_hint
) != ""
