# Busca skills por nome e mostra um menu para escolher uma delas.
# Imprime o alvo de instalação (dono/repo@skill) em stdout.
# Retorna 1 se nada for escolhido ou a busca não tiver resultados.
function _add_skill_select
    set -l skill_name $argv[1]

    set -l selection (gum spin \
        --spinner=dot \
        --title="Buscando opções para "(set_color -o $add_skill_color_title)$skill_name(set_color normal)"..." \
        -- npx skills find $skill_name \
        | perl -pe 's/\x1b\[[0-9;]*[mGK]//g' \
        | grep -E ".*@.*installs" \
        | awk '{printf "%-70s %s %s\n", $1, $2, $3}' \
        | gum choose \
            --header "Selecione a skill para instalar:" \
            --header.foreground=$add_skill_color_header \
            --item.foreground=$add_skill_color_unselected \
            --selected.foreground=$add_skill_color_error \
            --cursor.foreground=$add_skill_color_selected \
            --cursor="❯ ")

    set -q selection[1]; or return 1

    printf '%s\n' "$selection" \
        | perl -pe 's/\x1b\[[0-9;]*[mGK]//g' \
        | grep -Eo "[^ ]+@[^ ]+" \
        | sed 's/\xC2\xA0//g'
end
