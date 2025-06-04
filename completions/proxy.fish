# --- Helper function to get configured plugins and types ---
# This avoids repeating the logic in each complete command.
function __fish_proxy_get_configured_plugins
    if set -q FISH_PROXY_PLUGINS
        for plugin in $FISH_PROXY_PLUGINS
            echo $plugin
        end
    else
        # Default if not set, though config.fish should set it
        echo shell
    end
end

function __fish_proxy_get_configured_types
    if set -q FISH_PROXY_TYPES
        for type in $FISH_PROXY_TYPES
            echo $type
        end
    else
        # Default if not set
        echo http https all no
    end
end

# --- Completions for `proxy` ---
complete -c proxy -n "not __fish_seen_subcommand_from proxy" -d "Auto-configure proxies from settings"

# --- Completions for `noproxy` ---
complete -c noproxy -n "not __fish_seen_subcommand_from noproxy" -d "Clear all proxy settings"

# --- Completions for `proxys` ---
complete -c proxys -n "not __fish_seen_subcommand_from proxys" -d "Show current proxy settings"

# --- Completions for `set_proxy` ---
# Usage: set_proxy <plugin_name> <proxy_type> <proxy_value>

# Argument 1: plugin_name
complete -c set_proxy -n "__fish_seen_subcommand_from set_proxy; and not __fish_seen_argument_from (__fish_proxy_get_configured_plugins)" \
    -a "(__fish_proxy_get_configured_plugins)" -d "Plugin Name (e.g., shell, git)"

# Argument 2: proxy_type
complete -c set_proxy -n "__fish_seen_subcommand_from set_proxy; and __fish_seen_argument_from (__fish_proxy_get_configured_plugins); and not __fish_seen_argument_from (__fish_proxy_get_configured_types)" \
    -a "(__fish_proxy_get_configured_types)" -d "Proxy Type (e.g., http, https, all, no)"

# Argument 3: proxy_value (No specific completions, but provide description)
complete -c set_proxy -n "__fish_seen_subcommand_from set_proxy; and __fish_seen_argument_from (__fish_proxy_get_configured_plugins); and __fish_seen_argument_from (__fish_proxy_get_configured_types)" \
    -d "Proxy Value (e.g., http://host:port or user@host for SOCKS)" -r

# --- Completions for `unset_proxy` ---
# Usage: unset_proxy <plugin_name> <proxy_type>

# Argument 1: plugin_name
complete -c unset_proxy -n "__fish_seen_subcommand_from unset_proxy; and not __fish_seen_argument_from (__fish_proxy_get_configured_plugins)" \
    -a "(__fish_proxy_get_configured_plugins)" -d "Plugin Name (e.g., shell, git)"

# Argument 2: proxy_type
complete -c unset_proxy -n "__fish_seen_subcommand_from unset_proxy; and __fish_seen_argument_from (__fish_proxy_get_configured_plugins); and not __fish_seen_argument_from (__fish_proxy_get_configured_types)" \
    -a "(__fish_proxy_get_configured_types)" -d "Proxy Type (e.g., http, https, all, no)"
