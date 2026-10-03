function skills --description "Gerenciador de skills (plugins) e integrações de ferramentas de IA para o Fish shell"
    set -l _version "0.6.1"

    # Intercepta -v / --version
    if test "$argv[1]" = "-v"; or test "$argv[1]" = "--version"
        echo "skills-fish $_version"
        return 0
    end

    # Intercepta ajuda ou nenhum argumento para mostrar nossa interface
    if test (count $argv) -eq 0; or test "$argv[1]" = "-h"; or test "$argv[1]" = "--help"
        echo "Uso: skills <comando> [opções]"
        echo ""
        echo "Um gerenciador e instalador interativo para skills de IA."
        echo ""
        echo "Comandos Principais:"
        echo "  add, a     Adiciona uma skill interativamente (ex: skills add)"
        echo "  list, ls   Lista as skills instaladas no projeto atual (use -g para globais)"
        echo "  remove, rm Remove skills instaladas"
        echo "  update     Atualiza as skills instaladas"
        echo "  find       Busca skills no diretório"
        echo ""
        echo "Opções da CLI (skills-fish):"
        echo "  -h, --help     Mostra esta ajuda"
        echo "  -v, --version  Mostra a versão do plugin (e do npx skills base)"
        echo ""
        echo "Nota: Este plugin é 100% compatível com a CLI nativa."
        echo "Dica: Qualquer comando ou flag do 'npx skills' pode ser usado diretamente aqui."
        echo "      (ex: skills find react --owner vercel)"
        return 0
    end

    set -l missing
    if not type -q gum
        set missing gum (_skills_gum_hint)
    else if not type -q npx
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

    set -l subcommand $argv[1]

    # Intercept 'add' or 'a' to provide interactive search
    if contains -- $subcommand add a
        # Separate flags from arguments
        set -l flags (string match -e -r '^-' -- $argv[2..-1])
        set -l targets (string match -v -r '^-' -- $argv[2..-1])

        set -l install_target $targets[1]

        if not set -q install_target[1]
            echo "Uso: skills $subcommand <nome-da-skill | dono/repo@skill>" >&2
            echo "Dica: use 'skills find' para buscar." >&2
            return 1
        end

        # If it's a simple name (not a URL or explicit owner/repo format), search interactively
        if not string match -q '*@*' -- $install_target; and not string match -q 'http*' -- $install_target
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
