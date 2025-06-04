function _get_shell_proxy --description "Get current shell proxy setting"
    set -l proxy_type $argv[1] # e.g., http, https, all, no
    set -l value_to_return ""

    set -l base_var_name (string lower "$proxy_type")"_proxy"
    set -l lower_var "$base_var_name"
    set -l upper_var (string upper "$base_var_name")

    # Check lowercase first, then uppercase.
    if set -q $lower_var
        set value_to_return (status --get-variable $lower_var)
    else if set -q $upper_var
        set value_to_return (status --get-variable $upper_var)
    end

    echo -n "$value_to_return"
end
