# Verifica se há uma versão mais recente do plugin no GitHub (com cache de 24h e timeout de 1s).
# Pode ser desativado definindo: set -g skills_fish_check_update 0
function _add_skill_check_update
    test "$skills_fish_check_update" = "0"; and return 0

    set -l current_version $argv[1]
    test -n "$current_version"; or return 0

    set -l cache_dir (set -q XDG_CACHE_HOME; and echo $XDG_CACHE_HOME; or echo ~/.cache)/skills-fish
    set -l cache_file $cache_dir/latest_tag
    set -l now (date +%s)
    set -l last_check 0
    set -l cached_tag ""

    if test -f $cache_file
        read -l last_check cached_tag < $cache_file
    end

    set -l latest_tag $cached_tag

    # Se nunca checou ou o cache expirou (24 horas = 86400 segundos)
    if test -z "$last_check" -o (math "$now - $last_check") -ge 86400
        set -l fetched (curl -s -m 1 "https://api.github.com/repos/ribeiroevandro/skills-fish/tags" 2>/dev/null \
            | string match -r -m 1 -g '"name":\s*"([^"]+)"')
        if test -n "$fetched"
            set latest_tag $fetched
        end
        mkdir -p $cache_dir 2>/dev/null
        echo "$now $latest_tag" > $cache_file 2>/dev/null
    end

    test -n "$latest_tag"; or return 0

    # Compara SemVer (remote vs current)
    set -l rem (string split . -- (string replace -r '^v' '' -- $latest_tag))
    set -l loc (string split . -- (string replace -r '^v' '' -- $current_version))
    set -l is_newer 0

    for i in 1 2 3
        set -l r (test -n "$rem[$i]"; and echo $rem[$i]; or echo 0)
        set -l l (test -n "$loc[$i]"; and echo $loc[$i]; or echo 0)
        if test $r -gt $l
            set is_newer 1
            break
        else if test $r -lt $l
            break
        end
    end

    if test $is_newer -eq 1
        set -l title_color (set -q add_skill_color_title; and echo $add_skill_color_title; or echo cyan)
        set -l header_color (set -q add_skill_color_header; and echo $add_skill_color_header; or echo blue)

        echo
        set_color yellow
        echo -n "💡 Nova versão do skills-fish disponível: "
        set_color -o $title_color
        echo $latest_tag
        set_color normal
        echo -n "   Atualize com: "
        set_color $header_color
        echo "fisher update ribeiroevandro/skills-fish"
        set_color normal
        echo
    end
end
