# Imprime o comando de instalação do gum para o gerenciador de pacotes disponível.
# Sem gerenciador com pacote direto (ex.: apt, zypper), aponta para a documentação oficial.
function _skills_gum_hint
    if command -q brew
        echo "brew install gum"
    else if command -q pacman
        echo "sudo pacman -S gum"
    else if command -q dnf
        echo "sudo dnf install gum"
    else if command -q nix-env
        echo "nix-env -iA nixpkgs.gum"
    else if command -q pkg
        echo "sudo pkg install gum"
    else
        echo "veja https://github.com/charmbracelet/gum#installation"
    end
end
