source conf.d/skills.fish
source functions/_skills_gum_hint.fish
source functions/_skills_select.fish
source functions/_skills_sync.fish
source functions/_skills_check_update.fish
source functions/skills.fish

@test "função de sync retorna 0 com segurança quando a skill não existe localmente" (
    _skills_sync "owner/repo@nonexistent-skill-xyz"
    echo $status
) = 0

@test "checagem de atualização sai com status 0 quando desativada por variável" (
    set -l skills_fish_check_update 0
    _skills_check_update 0.3.0
    echo $status
) = 0

@test "detector de gum hint retorna comando não vazio" (
    _skills_gum_hint
) != ""
