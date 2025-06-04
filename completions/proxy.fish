complete -c set_proxy -n __fish_use_subcommand -a "shells git" -d "Plugin type"
complete -c set_proxy -n "__fish_seen_subcommand_from shells" -a "http https socks no" -d "Proxy type"
complete -c set_proxy -n "__fish_seen_subcommand_from git" -a "http https" -d "Git proxy type"

complete -c unset_proxy -n __fish_use_subcommand -a "shells git" -d "Plugin type"
complete -c unset_proxy -n "__fish_seen_subcommand_from shells" -a "http https socks no" -d "Proxy type"
complete -c unset_proxy -n "__fish_seen_subcommand_from git" -a "http https" -d "Git proxy type"
