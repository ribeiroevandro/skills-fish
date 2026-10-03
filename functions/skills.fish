function skills --description "Gerenciador de skills (plugins) e integrações de ferramentas de IA para o Fish shell"
    set -l _version "0.3.0"

    set -l missing
    if not command -q gum
        set missing gum (_skills_gum_hint)
    else if not command -q npx
        set missing npx "instale o Node.js: https://nodejs.org"
    end

    if set -q missing[1]
        set_color $skills_color_error >&2
        echo "skills: o comando '$missing[1]' não foi encontrado." >&2
        set_color normal >&2
        echo "Para instalar: $missing[2]" >&2
        return 127
    end

    # Check for update in background
    _skills_check_update $_version

    # Intercepta -v / --version
    if contains -- -v $argv; or contains -- --version $argv
        echo "skills-fish $_version"
        echo "(wraps npx skills "(npx skills -v)")"
        return 0
    end

    # Intercepta ajuda ou nenhum argumento para mostrar nossa interface
    if test (count $argv) -eq 0; or contains -- -h $argv; or contains -- --help $argv
        echo "Uso: skills <comando> [opções]"
        echo ""
        echo "Um gerenciador e instalador interativo para skills de IA."
        echo ""
        echo "Comandos Principais:"
        echo "  add, a     Adiciona uma skill interativamente (ex: skills add)"
        echo "  list, ls   Lista as skills instaladas no projeto atual"
        echo "  remove, rm Remove skills instaladas"
        echo "  update     Atualiza as skills instaladas"
        echo "  find       Busca skills no diretório"
        echo ""
        echo "Opções da CLI (skills-fish):"
        echo "  -h, --help     Mostra esta ajuda"
        echo "  -v, --version  Mostra a versão do plugin (e do npx skills base)"
        echo ""
        echo "Nota: Qualquer outro comando ou flag é repassado diretamente ao 'npx skills'."
        echo "Dica: Digite 'npx skills -h' para ver a lista completa de comandos avançados."
        return 0
    end

    set -l subcommand $argv[1]

    # Intercept 'add' or 'a' to provide interactive search
    if contains -- $subcommand add a
        # Separate flags from arguments
        set -l flags
        set -l targets
        for arg in $argv[2..-1]
            if string match -q -- "-*" $arg
                set -a flags $arg
            else
                set -a targets $arg
            end
        end

        set -l install_target $targets[1]

        # If there is exactly one target and it's not a URL or explicit owner/repo format
        if set -q install_target[1]; and not string match -q '*@*' -- $install_target; and not string match -q 'http*' -- $install_target
            set install_target (_skills_select $install_target)
            if not set -q install_target[1]
                gum style --foreground=$skills_color_error "Instalação cancelada. Saindo..."
                return 1
            end
            echo "Selecionado: $install_target"
            
            npx skills $subcommand $flags $install_target; or return

            set -l folder_name (string split --right --max 1 @ -- $install_target)[-1]
            if test -d ~/.agents/skills/$folder_name
                _skills_sync $install_target
            end
            return 0
        end
    end

    # Pass everything else directly to npx skills
    npx skills $argv
end
