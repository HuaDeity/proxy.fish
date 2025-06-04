function _get_git_proxy --description "Get current Git global proxy setting"
    set -l proxy_type $argv[1] # Expected: http or https
    set -l value_to_return ""

    switch "$proxy_type"
        case http https
            set -l git_config_key "$proxy_type.proxy"
            if type -q git # Check if git command is available
                # Get the git config value. Suppress errors if not set.
                set value_to_return (git config --global --get "$git_config_key" 2>/dev/null)
            end
        case "*"
            # Not applicable for other types.
            return 1
    end

    echo -n "$value_to_return"
end
