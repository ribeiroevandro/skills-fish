source conf.d/skills.fish
source functions/_skills_gum_hint.fish
source functions/_skills_select.fish
source functions/_skills_sync.fish
source functions/_skills_check_update.fish
source functions/skills.fish

@test "mostra versão do plugin com flag -v" (
    skills -v
)[1] = "skills-fish 0.3.0"

@test "mostra ajuda com status 0 ao passar -h" (
    skills -h >/dev/null
    echo $status
) = 0

@test "mostra ajuda sem argumentos com status 0" (
    skills >/dev/null
    echo $status
) = 0

@test "ajuda exibe cabeçalho de uso esperado" (
    skills -h
)[1] = "Uso: skills <comando> [opções]"

@test "falha com status 1 quando 'add' não recebe argumentos" (
    function gum; end; function npx; end
    skills add 2>/dev/null
    set -l stat $status
    functions -e gum npx
    echo $stat
) = 1

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
