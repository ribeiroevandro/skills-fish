# O argumento é o nome de uma skill, não um arquivo.
complete --command add-skill --no-files
complete --command add-skill --short-option h --long-option help --description 'Mostra a ajuda'
complete --command add-skill --short-option v --long-option version --description 'Mostra a versão'
complete --command add-skill --short-option g --long-option global --description 'Instala globalmente (~/.agents/skills)'
complete --command add-skill --short-option p --long-option project --description 'Instala no projeto atual (.agents/skills)'
