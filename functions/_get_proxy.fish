# Internal helper function to determine the proxy value for a given type.
# It prioritizes user-set environment variables, then OS-detected proxies (if applicable),
# and applies a prefix if needed.

function _get_proxy --description "Get proxy setting for a specific type, considering user overrides and OS settings"
    set -l proxy_type $argv[1] # e.g., http, https, all, no

    set -l os_detected_proxy ""
    set -l user_configured_proxy ""
    set -l mixed_fallback_proxy ""
    set -l final_proxy_value ""

    # 1. Check for user-configured proxy via FISH_PROXY_TYPE environment variable
    # e.g., FISH_PROXY_HTTP, FISH_PROXY_HTTPS
    set -l user_env_var "FISH_PROXY_"(string upper $proxy_type)
    if set -q $user_env_var
        set user_configured_proxy (status --get-variable $user_env_var)
    end

    # 2. If not set by user, try to detect from OS (if _get_os_proxy function exists)
    # This is primarily for macOS.
    if test -z "$user_configured_proxy"
        if functions -q _get_os_proxy
            set os_detected_proxy (_get_os_proxy "$proxy_type")
        end
    end

    # 3. Determine the effective proxy: user > os
    if test -n "$user_configured_proxy"
        set final_proxy_value $user_configured_proxy
    else if test -n "$os_detected_proxy"
        set final_proxy_value $os_detected_proxy
    end

    # 4. Handle 'mixed' proxy as a fallback if the specific type isn't set
    # (but not for 'no_proxy')
    if test "$proxy_type" != no -a -z "$final_proxy_value"
        if set -q FISH_PROXY_MIXED
            set mixed_fallback_proxy $FISH_PROXY_MIXED
            if test -n "$mixed_fallback_proxy"
                set final_proxy_value $mixed_fallback_proxy
            end
        end
    end

    # 5. Apply protocol prefix if needed (e.g., http://, socks5://)
    # This is not done for 'no_proxy'
    if test "$proxy_type" != no -a -n "$final_proxy_value"
        if functions -q _proxy_prefix
            set final_proxy_value (_proxy_prefix "$proxy_type" "$final_proxy_value")
        end
    end

    echo -n "$final_proxy_value"
end
