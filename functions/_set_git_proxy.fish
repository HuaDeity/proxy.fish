function _set_git_proxy --description "Set Git global proxy configuration"
    set -l proxy_type $argv[1] # Expected: http or https
    set -l proxy_value $argv[2] # e.g., http://proxy.example.com:8080 or "" to unset

    # Git proxy configuration only applies to 'http' and 'https' protocols.
    switch "$proxy_type"
        case http https
            # Construct the git config key (e.g., http.proxy, https.proxy)
            set -l git_config_key "$proxy_type.proxy"

            if type -q git # Check if git command is available
                if test -n "$proxy_value"
                    # Set the git config global value.
                    git config --global "$git_config_key" "$proxy_value"
                    # echo "proxy.fish: (git) Set $git_config_key to $proxy_value"
                else
                    # If proxy_value is empty, unset the git config.
                    # Use --unset-all to remove all occurrences if any.
                    # Suppress errors if the key doesn't exist.
                    git config --global --unset-all "$git_config_key" 2>/dev/null; or true
                    # echo "proxy.fish: (git) Unset $git_config_key"
                end
            else
                # echo "proxy.fish: (git) 'git' command not found. Cannot configure Git proxy." >&2
            end
        case "*"
            # For other types like 'all' or 'no', Git doesn't have a direct equivalent.
            # Silently ignore or log if necessary.
            # echo "proxy.fish: (git) Proxy type '$proxy_type' not applicable for Git configuration."
            return 0
    end
end
