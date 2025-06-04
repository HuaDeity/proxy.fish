function proxys -d "Show current proxy settings"
    echo "Environment variables:"
    echo "  http_proxy: $http_proxy"
    echo "  https_proxy: $https_proxy"
    echo "  socks_proxy: $socks_proxy"
    echo "  all_proxy: $all_proxy"
    echo "  no_proxy: $no_proxy"

    if command -v git >/dev/null 2>&1
        echo "Git configuration:"
        echo "  http.proxy: "(git config --global --get http.proxy 2>/dev/null || echo "not set")
        echo "  https.proxy: "(git config --global --get https.proxy 2>/dev/null || echo "not set")
    end

    echo "Plugin configuration:"
    echo "  FISH_PROXY_HTTP: $FISH_PROXY_HTTP"
    echo "  FISH_PROXY_HTTPS: $FISH_PROXY_HTTPS"
    echo "  FISH_PROXY_SOCKS: $FISH_PROXY_SOCKS"
    echo "  FISH_PROXY_MIXED: $FISH_PROXY_MIXED"
    echo "  FISH_PROXY_NO: $FISH_PROXY_NO"
    echo "  FISH_PROXY_AUTO: $FISH_PROXY_AUTO"
end
