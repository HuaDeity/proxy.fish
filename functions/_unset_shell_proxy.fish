function _unset_shell_proxy --description "Unset shell environment variables for proxy"
    set -l proxy_type $argv[1] # e.g., http, https, all, no

    # Call the setter with an empty value to perform the unsetting logic.
    _set_shell_proxy "$proxy_type" ""
end
