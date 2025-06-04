function unset_proxy --description "Unset a specific proxy for a given plugin and type"
    # Expected arguments: plugin_name proxy_type
    # Example: unset_proxy shell http

    if test (count $argv) -ne 2
        echo "Usage: unset_proxy <plugin_name> <proxy_type>" >&2
        echo "Example: unset_proxy shell http" >&2
        return 1
    end

    set -l plugin_name $argv[1]
    set -l proxy_type $argv[2]

    # Construct the name of the unsetter function.
    # e.g., _unset_shell_proxy
    set -l unsetter_func "_unset_"$plugin_name"_proxy"

    # Check if the specified plugin is in the configured list of plugins.
    if not contains $plugin_name $FISH_PROXY_PLUGINS
        echo "fish-proxy: Error: Plugin '$plugin_name' is not configured in FISH_PROXY_PLUGINS." >&2
        return 1
    end

    # Check if the specified proxy type is in the configured list of types.
    if not contains $proxy_type $FISH_PROXY_TYPES
        echo "fish-proxy: Warning: Proxy type '$proxy_type' is not in FISH_PROXY_TYPES, but attempting to unset for $plugin_name." >&2
    end

    # Check if the unsetter function exists.
    if functions -q $unsetter_func
        # Call the unsetter function with the proxy type.
        $unsetter_func "$proxy_type"
        echo "fish-proxy: Unset $proxy_type proxy for $plugin_name."
    else
        echo "fish-proxy: Error: Unsetter function '$unsetter_func' not found for plugin '$plugin_name'." >&2
        return 1
    end
end
