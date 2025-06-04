# Internal helper function to add a protocol prefix to a proxy URL if it's missing.

function _proxy_prefix --description "Add protocol prefix to proxy URL if missing"
    set -l proxy_kind $argv[1] # e.g., http, https, all
    set -l proxy_value $argv[2] # e.g., 127.0.0.1:8080

    if test -z "$proxy_value"
        # If the value is empty, nothing to prefix.
        echo -n ""
        return 0
    end

    # If the value already contains "://", assume it has a prefix.
    if string match -q "*://*" -- "$proxy_value"
        echo -n "$proxy_value"
        return 0
    end

    # --- Determine default prefixes ---
    # Users can override these via environment variables if needed.
    set -l http_scheme http
    if set -q FISH_PROXY_PREFIX_HTTP
        set http_scheme $FISH_PROXY_PREFIX_HTTP
    end

    set -l https_scheme http # Often, https proxies are still specified with http:// for the proxy server itself
    if set -q FISH_PROXY_PREFIX_HTTPS
        set https_scheme $FISH_PROXY_PREFIX_HTTPS
    end

    set -l all_scheme socks5 # 'all' often implies a SOCKS proxy
    if set -q FISH_PROXY_PREFIX_ALL
        set all_scheme $FISH_PROXY_PREFIX_ALL
    end
    # --- Apply prefix based on kind ---
    switch "$proxy_kind"
        case http
            echo -n "$http_scheme://$proxy_value"
        case https
            # HTTPS proxy URLs typically still use http:// for the proxy address itself,
            # unless it's a SOCKS proxy acting for HTTPS.
            # If a specific https_scheme is defined (e.g. to socks5), use that.
            echo -n "$https_scheme://$proxy_value"
        case all # Typically for SOCKS or a generic proxy
            echo -n "$all_scheme://$proxy_value"
        case "*" # For any other types, or if no match, return value as is.
            # This case handles 'no' type implicitly, which shouldn't get a prefix.
            echo -n "$proxy_value"
            return 0 # Or return 1 if it's an unexpected type.
    end
end
