function __fish_proxy_unset_env
    set -e http_proxy HTTP_PROXY
    set -e https_proxy HTTPS_PROXY
    set -e socks_proxy SOCKS_PROXY
    set -e all_proxy ALL_PROXY
    set -e no_proxy NO_PROXY
end
