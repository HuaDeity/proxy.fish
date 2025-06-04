function _set_shell_proxy --description "Set shell environment variables for proxy"
    set -l proxy_type $argv[1] # e.g., http, https, all, no
    set -l proxy_value $argv[2] # e.g., http://proxy.example.com:8080 or "" to unset

    # Define the base variable name (e.g., http_proxy, no_proxy)
    set -l base_var_name (string lower "$proxy_type")"_proxy"

    if test -n "$proxy_value"
        # Set both lowercase and uppercase versions of the environment variable.
        set -gx "$base_var_name" "$proxy_value"
        set -gx (string upper "$base_var_name") "$proxy_value"
        # echo "proxy.fish: (shell) Set $base_var_name to $proxy_value"
    else
        # If proxy_value is empty, unset the environment variables.
        set -e "$base_var_name"
        set -e (string upper "$base_var_name")
        # echo "proxy.fish: (shell) Unset $base_var_name"
    end
end
