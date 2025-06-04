function _unset_git_proxy --description "Unset Git global proxy configuration"
    set -l proxy_type $argv[1] # Expected: http or https

    # Call the setter with an empty value to perform the unsetting logic.
    _set_git_proxy "$proxy_type" ""
end
