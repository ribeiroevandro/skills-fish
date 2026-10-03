function add-skill --description "Busca interativa, instala e sincroniza skills do skills.sh"
    set -l _version "0.1.0"
    argparse h/help v/version g/global p/project -- $argv; or return 1

    if set -q _flag_version
        echo "add-skill $_version"
        return 0
    end

    if set -q _flag_help
        echo "Uso: add-skill [opções] <nome-da-skill | dono/repo@skill>"
        echo ""
        echo "Opções:"
        echo "  -g, --global   Instala globalmente (~/.agents/skills)"
        echo "  -p, --project  Instala no projeto atual (.agents/skills)"
        echo "  -v, --version  Mostra a versão do plugin"
        echo "  -h, --help     Mostra esta ajuda"
        return 0
    end

    _add_skill_check_update $_version

    if set -q _flag_global; and set -q _flag_project
        set_color $add_skill_color_error >&2
        echo "add-skill: escolha apenas uma forma de instalação: --global ou --project." >&2
        set_color normal >&2
        return 1
    end

    if not set -q argv[1]
        echo "Uso: add-skill [opções] <nome-da-skill | dono/repo@skill>" >&2
        return 1
    end

    set -l missing
    if not command -q gum
        set missing gum (_add_skill_gum_hint)
    else if not command -q npx
        set missing npx "instale o Node.js: https://nodejs.org"
    end

    if set -q missing[1]
        set_color $add_skill_color_error >&2
        echo "add-skill: o comando '$missing[1]' não foi encontrado." >&2
        set_color normal >&2
        echo "Para instalar: $missing[2]" >&2
        return 127
    end

    set -l install_target $argv[1]

    if not string match --quiet '*@*' -- $install_target
        set install_target (_add_skill_select $install_target)
        if not set -q install_target[1]
            gum style --foreground=$add_skill_color_error "Instalação cancelada. Saindo..."
            return 1
        end
        echo "Selecionado: $install_target"
    end

    set -l is_global 0
    if set -q _flag_global
        set is_global 1
    else if not set -q _flag_project
        set -l scope_choice (printf "%s\n%s\n" "Global (~/.agents/skills)" "Projeto (.agents/skills)" | gum choose \
            --header "Onde deseja instalar a skill?" \
            --header.foreground=$add_skill_color_header \
            --item.foreground=$add_skill_color_unselected \
            --selected.foreground=$add_skill_color_error \
            --cursor.foreground=$add_skill_color_selected \
            --cursor="❯ ")

        if not set -q scope_choice[1]
            gum style --foreground=$add_skill_color_error "Instalação cancelada. Saindo..."
            return 1
        end

        if string match --quiet "Global*" -- $scope_choice
            set is_global 1
        end
    end

    if test $is_global -eq 1
        npx skills add -g $install_target; or return
        _add_skill_sync $install_target
    else
        npx skills add $install_target; or return
    end
end
