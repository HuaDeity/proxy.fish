function set_proxy --description "Set a specific proxy for a given plugin and type"
    # Expected arguments: plugin_name proxy_type proxy_value
    # Example: set_proxy shell http http://myproxy.com:8080

    if test (count $argv) -ne 3
        echo "Usage: set_proxy <plugin_name> <proxy_type> <proxy_value>" >&2
        echo "Example: set_proxy shell http http://myproxy.com:8080" >&2
        return 1
    end

    set -l plugin_name $argv[1]
    set -l proxy_type $argv[2]
    set -l proxy_value $argv[3]

    # Construct the name of the setter function.
    # e.g., _set_shell_proxy
    set -l setter_func "_set_"$plugin_name"_proxy"

    # Check if the specified plugin is in the configured list of plugins.
    if not contains $plugin_name $FISH_PROXY_PLUGINS
        echo "proxy.fish: Error: Plugin '$plugin_name' is not configured in FISH_PROXY_PLUGINS." >&2
        return 1
    end

    # Check if the specified proxy type is in the configured list of types.
    # Although individual setters might handle specific types, this provides a general guard.
    if not contains $proxy_type $FISH_PROXY_TYPES
        echo "proxy.fish: Error: Proxy type '$proxy_type' is not configured in FISH_PROXY_TYPES." >&2
        # Allow proceeding if it's a custom type the plugin might support, but warn.
        # Or, enforce strictly: return 1
    end

    # Check if the setter function exists.
    if functions -q $setter_func
        # Call the setter function with the proxy type and value.
        $setter_func "$proxy_type" "$proxy_value"
        echo "proxy.fish: Set $proxy_type proxy for $plugin_name to '$proxy_value'."
    else
        echo "proxy.fish: Error: Setter function '$setter_func' not found for plugin '$plugin_name'." >&2
        return 1
    end
end
