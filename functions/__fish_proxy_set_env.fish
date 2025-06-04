function __fish_proxy_set_env
    set -l proxy_http $argv[1]
    set -l proxy_https $argv[2]
    set -l proxy_socks $argv[3]
    set -l proxy_no $argv[4]

    # Set HTTP proxy variables
    if test -n "$proxy_http"
        set -gx http_proxy "$proxy_http"
        set -gx HTTP_PROXY "$proxy_http"
    end

    # Set HTTPS proxy variables
    if test -n "$proxy_https"
        set -gx https_proxy "$proxy_https"
        set -gx HTTPS_PROXY "$proxy_https"
    end

    # Set SOCKS proxy variables
    if test -n "$proxy_socks"
        set -gx socks_proxy "$proxy_socks"
        set -gx SOCKS_PROXY "$proxy_socks"
        set -gx all_proxy "$proxy_socks"
        set -gx ALL_PROXY "$proxy_socks"
    end

    # Set no proxy variables
    if test -n "$proxy_no"
        set -gx no_proxy "$proxy_no"
        set -gx NO_PROXY "$proxy_no"
    end
end
