function _unset_nix_proxy --description "Unset Nix proxy"
    set -l proxy_type $argv[1] # e.g., http, https, all, no

    # Call the setter with an empty value to perform the unsetting logic.
    _set_nix_proxy "$proxy_type" ""
end
