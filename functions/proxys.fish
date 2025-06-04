function proxys --description "Show current proxy settings for all configured plugins"
    # Iterate through each configured plugin (e.g., shell, git).
    for plugin_name in $FISH_PROXY_PLUGINS
        echo -e "\033[1mPlugin: $plugin_name\033[0m" # Bold plugin name

        # Flag to check if any proxy is set for this plugin
        set -l found_proxy_for_plugin false

        # Iterate through each proxy type (e.g., http, https, all, no).
        for proxy_type in $FISH_PROXY_TYPES
            # Construct the name of the getter function for the current plugin and type.
            # e.g., _get_shell_proxy, _get_git_proxy
            set -l getter_func "_get_"$plugin_name"_proxy"

            # Check if the getter function exists.
            if functions -q $getter_func
                # Call the getter function, passing the proxy type, and capture its output.
                set -l proxy_value ($getter_func "$proxy_type")

                # If the getter function returned a non-empty value, display it.
                if test -n "$proxy_value"
                    echo "  $proxy_type: $proxy_value"
                    set found_proxy_for_plugin true
                end
            else
                # Optional: Notify if a getter function is missing, though for display,
                # it might be better to just skip.
                # echo "proxy.fish: Info: Getter function '$getter_func' not found for plugin '$plugin_name'." >&2
            end
        end

        if not $found_proxy_for_plugin
            echo "  (No proxy settings found for this plugin)"
        end
        echo "" # Add a blank line for readability between plugins
    end
end
