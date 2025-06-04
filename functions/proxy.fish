function proxy -d "Configure proxy settings"
    # Detect system proxy on macOS
    __fish_proxy_detect_macos

    # Determine proxy values with precedence: user config > system detected > fallback
    set -l http_proxy_val ""
    set -l https_proxy_val ""
    set -l socks_proxy_val ""
    set -l no_proxy_val "$FISH_PROXY_NO"

    # HTTP proxy precedence
    if test -n "$FISH_PROXY_HTTP"
        set http_proxy_val "$FISH_PROXY_HTTP"
    else if test -n "$FISH_PROXY_HTTP_DETECTED"
        set http_proxy_val "$FISH_PROXY_HTTP_DETECTED"
    end

    # HTTPS proxy precedence
    if test -n "$FISH_PROXY_HTTPS"
        set https_proxy_val "$FISH_PROXY_HTTPS"
    else if test -n "$FISH_PROXY_HTTPS_DETECTED"
        set https_proxy_val "$FISH_PROXY_HTTPS_DETECTED"
    end

    # SOCKS proxy precedence
    if test -n "$FISH_PROXY_SOCKS"
        set socks_proxy_val "$FISH_PROXY_SOCKS"
    else if test -n "$FISH_PROXY_SOCKS_DETECTED"
        set socks_proxy_val "$FISH_PROXY_SOCKS_DETECTED"
    end

    # Mixed proxy handling
    if test -n "$FISH_PROXY_MIXED"
        if test -z "$http_proxy_val"
            set http_proxy_val "$FISH_PROXY_MIXED"
        end
        if test -z "$https_proxy_val"
            set https_proxy_val "$FISH_PROXY_MIXED"
        end
        if test -z "$socks_proxy_val"
            set socks_proxy_val "$FISH_PROXY_MIXED"
        end
    end

    # Set environment variables
    __fish_proxy_set_env "$http_proxy_val" "$https_proxy_val" "$socks_proxy_val" "$no_proxy_val"

    # Configure Git if requested
    if string match -q "*git*" "$FISH_PROXY_PLUGINS"
        __fish_proxy_set_git "$http_proxy_val" "$https_proxy_val"
    end

    echo "Proxy configured:"
    test -n "$http_proxy_val"; and echo "  HTTP: $http_proxy_val"
    test -n "$https_proxy_val"; and echo "  HTTPS: $https_proxy_val"
    test -n "$socks_proxy_val"; and echo "  SOCKS: $socks_proxy_val"
    test -n "$no_proxy_val"; and echo "  No proxy: $no_proxy_val"
end
