function proxy --description "Set system proxies based on configuration"
    # Create a map (associative array in fish) to store fetched proxy values.
    # Fish doesn't have true associative arrays like bash.
    # We'll store them as individual variables or use a list of key=value pairs.
    set -l proxy_values_map

    # Iterate through defined proxy types and get their values.
    for type in $FISH_PROXY_TYPES
        set -l val (_get_proxy $type) # Call helper to get specific proxy value
        if test -n "$val"
            # Store as type=value, e.g., http=http://proxy.example.com:8080
            set -a proxy_values_map "$type=$val"
        else
            # Store an empty value if not found, to ensure unsetting later if needed
            set -a proxy_values_map "$type="
        end
    end

    # Apply these values using the registered plugin setters.
    for plugin_name in $FISH_PROXY_PLUGINS
        for type_value_pair in $proxy_values_map
            # Extract type and value
            set -l current_type (echo "$type_value_pair" | string split -m 1 '=' -f 1)
            set -l current_value (echo "$type_value_pair" | string split -m 1 '=' -f 2)

            set -l setter_func "_set_"$plugin_name"_proxy"

            if functions -q $setter_func
                # Call the setter function for the plugin and type.
                # Pass type and its corresponding value.
                $setter_func "$current_type" "$current_value"
            else
                # Optional: Warn if a setter function is expected but not found.
                # echo "proxy.fish: Warning: Setter function '$setter_func' not found for plugin '$plugin_name'." >&2
            end
        end
    end
end
