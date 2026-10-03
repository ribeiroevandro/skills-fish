# Auto-completamento para o comando skills (wrapper do npx skills)
complete --command skills --no-files

# Sugere os subcomandos principais do skills.sh
complete --command skills --condition "not __fish_seen_subcommand_from add a use remove rm list ls find update experimental_install init experimental_sync" --arguments "add" --description "Add a skill package"
complete --command skills --condition "not __fish_seen_subcommand_from add a use remove rm list ls find update experimental_install init experimental_sync" --arguments "use" --description "Generate a prompt for using a skill"
complete --command skills --condition "not __fish_seen_subcommand_from add a use remove rm list ls find update experimental_install init experimental_sync" --arguments "remove" --description "Remove installed skills"
complete --command skills --condition "not __fish_seen_subcommand_from add a use remove rm list ls find update experimental_install init experimental_sync" --arguments "list" --description "List installed skills"
complete --command skills --condition "not __fish_seen_subcommand_from add a use remove rm list ls find update experimental_install init experimental_sync" --arguments "find" --description "Search for skills interactively"
complete --command skills --condition "not __fish_seen_subcommand_from add a use remove rm list ls find update experimental_install init experimental_sync" --arguments "update" --description "Update skills to latest versions"

# Flags globais comuns
complete --command skills --short-option h --long-option help --description 'Mostra a ajuda'
complete --command skills --short-option v --long-option version --description 'Mostra a versão'

# Flags específicas para o subcomando list/ls
complete --command skills --condition "__fish_seen_subcommand_from list ls" --short-option g --long-option global --description 'List global skills'
complete --command skills --condition "__fish_seen_subcommand_from list ls" --short-option a --long-option agent --description 'Filter by specific agents'
complete --command skills --condition "__fish_seen_subcommand_from list ls" --long-option json --description 'Output as JSON'

# Flags específicas para o subcomando add
complete --command skills --condition "__fish_seen_subcommand_from add a" --short-option g --long-option global --description 'Install skill globally'
complete --command skills --condition "__fish_seen_subcommand_from add a" --short-option a --long-option agent --description 'Specify agents to install to'
complete --command skills --condition "__fish_seen_subcommand_from add a" --short-option y --long-option yes --description 'Skip confirmation prompts'

# Flags específicas para o subcomando remove/rm
complete --command skills --condition "__fish_seen_subcommand_from remove rm" --short-option g --long-option global --description 'Remove from global scope'
complete --command skills --condition "__fish_seen_subcommand_from remove rm" --short-option a --long-option agent --description 'Remove from specific agents'
complete --command skills --condition "__fish_seen_subcommand_from remove rm" --short-option y --long-option yes --description 'Skip confirmation prompts'
