function noproxy -d "Disable all proxy settings"
    __fish_proxy_unset_env
    __fish_proxy_unset_git
    echo "All proxy settings cleared"
end
