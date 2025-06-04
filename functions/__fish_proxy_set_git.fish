function __fish_proxy_set_git
    set -l proxy_http $argv[1]
    set -l proxy_https $argv[2]

    if command -v git >/dev/null 2>&1
        if test -n "$proxy_http"
            git config --global http.proxy "$proxy_http"
        end
        if test -n "$proxy_https"
            git config --global https.proxy "$proxy_https"
        end
    end
end
