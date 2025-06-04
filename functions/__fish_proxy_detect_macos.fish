function __fish_proxy_detect_macos
    if not test (uname) = Darwin
        return 1
    end

    if not command -v networksetup >/dev/null 2>&1
        return 1
    end

    # Get active network service
    set -l active_service (networksetup -listnetworkserviceorder | grep -A1 "Hardware Port" | head -2 | tail -1 | sed 's/^[^:]*: //')

    if test -z "$active_service"
        return 1
    end

    # Get proxy settings
    set -l web_proxy (networksetup -getwebproxy "$active_service" 2>/dev/null)
    set -l secure_proxy (networksetup -getsecurewebproxy "$active_service" 2>/dev/null)
    set -l socks_proxy (networksetup -getsocksfirewallproxy "$active_service" 2>/dev/null)

    # Parse and set proxy values
    if echo "$web_proxy" | grep -q "Enabled: Yes"
        set -l server (echo "$web_proxy" | grep "Server:" | cut -d' ' -f2)
        set -l port (echo "$web_proxy" | grep "Port:" | cut -d' ' -f2)
        if test -n "$server" -a -n "$port"
            set -g FISH_PROXY_HTTP_DETECTED "http://$server:$port"
        end
    end

    if echo "$secure_proxy" | grep -q "Enabled: Yes"
        set -l server (echo "$secure_proxy" | grep "Server:" | cut -d' ' -f2)
        set -l port (echo "$secure_proxy" | grep "Port:" | cut -d' ' -f2)
        if test -n "$server" -a -n "$port"
            set -g FISH_PROXY_HTTPS_DETECTED "http://$server:$port"
        end
    end

    if echo "$socks_proxy" | grep -q "Enabled: Yes"
        set -l server (echo "$socks_proxy" | grep "Server:" | cut -d' ' -f2)
        set -l port (echo "$socks_proxy" | grep "Port:" | cut -d' ' -f2)
        if test -n "$server" -a -n "$port"
            set -g FISH_PROXY_SOCKS_DETECTED "socks5://$server:$port"
        end
    end
end
