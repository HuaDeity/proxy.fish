# --- Default Plugin Configuration ---
# Users can override these in their main config.fish if they load the plugin manually
# or if the plugin manager doesn't handle this scope.
# For Fisher, these will be scoped to the plugin unless -g is used by the user beforehand.

# Define which proxy types to manage. 'all' is often used for SOCKS or a general proxy.
if not set -q FISH_PROXY_TYPES
    set -g FISH_PROXY_TYPES http https all no
end

# Define which integrations (plugins) to activate.
if not set -q FISH_PROXY_PLUGINS
    set -g FISH_PROXY_PLUGINS shell
end

# Automatically apply proxy settings on shell startup.
# Set to "yes" to enable. Default is "no".
if not set -q FISH_PROXY_AUTO
    set -g FISH_PROXY_AUTO no
end

# --- Auto-run Proxy ---
# If FISH_PROXY_AUTO is set to "yes", call the proxy function.
if test "$FISH_PROXY_AUTO" = yes
    if functions -q proxy
        proxy
    else
        echo "proxy.fish: Error: 'proxy' function not found. Cannot auto-apply settings." >&2
    end
end
