function __fish_proxy_unset_git
    if command -v git >/dev/null 2>&1
        git config --global --unset http.proxy 2>/dev/null
        git config --global --unset https.proxy 2>/dev/null
    end
end
