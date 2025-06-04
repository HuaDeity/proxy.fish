function noproxy --description "Unset all configured proxies"
    # Iterate through each configured plugin (e.g., shell, git).
    for plugin_name in $FISH_PROXY_PLUGINS
        # Iterate through each proxy type (e.g., http, https, all, no).
        for proxy_type in $FISH_PROXY_TYPES
            # Construct the name of the unsetter function for the current plugin and type.
            # e.g., _unset_shell_proxy, _unset_git_proxy
            set -l unsetter_func "_unset_"$plugin_name"_proxy"

            # Check if the unsetter function exists.
            if functions -q $unsetter_func
                # Call the unsetter function, passing the proxy type.
                # The unsetter function is responsible for knowing how to clear
                # the proxy settings for its specific plugin and type.
                $unsetter_func "$proxy_type"
            else
                # Optional: Warn if an unsetter function is expected but not found.
                # echo "fish-proxy: Warning: Unsetter function '$unsetter_func' not found for plugin '$plugin_name'." >&2
            end
        end
    end
end
