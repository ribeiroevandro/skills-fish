# Vincula uma skill instalada globalmente (~/.agents/skills) às skills globais do Antigravity.
# Recebe o alvo de instalação (dono/repo@skill) e usa só o nome após o último "@".
# Não faz nada se a pasta da skill não existir.
function _add_skill_sync
    set -l folder_name (string split --right --max 1 @ -- $argv[1])[-1]
    set -l source ~/.agents/skills/$folder_name
    set -l target ~/.gemini/antigravity-cli/skills

    test -d $source; or return 0

    mkdir -p $target
    and ln -sfn $source $target/$folder_name
    and echo "Skill '$folder_name' vinculada ao Antigravity ($target/$folder_name)"
end
