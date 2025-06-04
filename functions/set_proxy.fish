function set_proxy -d "Set proxy for specific protocol" -a plugin type proxy_url
    switch "$plugin"
        case shells shell
            switch "$type"
                case http
                    if test -n "$proxy_url"
                        set -gx http_proxy "$proxy_url"
                        set -gx HTTP_PROXY "$proxy_url"
                        echo "HTTP proxy set to: $proxy_url"
                    else
                        set -e http_proxy HTTP_PROXY
                        echo "HTTP proxy unset"
                    end
                case https
                    if test -n "$proxy_url"
                        set -gx https_proxy "$proxy_url"
                        set -gx HTTPS_PROXY "$proxy_url"
                        echo "HTTPS proxy set to: $proxy_url"
                    else
                        set -e https_proxy HTTPS_PROXY
                        echo "HTTPS proxy unset"
                    end
                case socks socks5
                    if test -n "$proxy_url"
                        set -gx socks_proxy "$proxy_url"
                        set -gx SOCKS_PROXY "$proxy_url"
                        set -gx all_proxy "$proxy_url"
                        set -gx ALL_PROXY "$proxy_url"
                        echo "SOCKS proxy set to: $proxy_url"
                    else
                        set -e socks_proxy SOCKS_PROXY all_proxy ALL_PROXY
                        echo "SOCKS proxy unset"
                    end
                case no
                    if test -n "$proxy_url"
                        set -gx no_proxy "$proxy_url"
                        set -gx NO_PROXY "$proxy_url"
                        echo "No proxy set to: $proxy_url"
                    else
                        set -e no_proxy NO_PROXY
                        echo "No proxy unset"
                    end
                case "*"
                    echo "Usage: set_proxy shells [http|https|socks|no] [proxy_url]"
                    return 1
            end
        case git
            switch "$type"
                case http
                    if test -n "$proxy_url"
                        git config --global http.proxy "$proxy_url"
                        echo "Git HTTP proxy set to: $proxy_url"
                    else
                        git config --global --unset http.proxy
                        echo "Git HTTP proxy unset"
                    end
                case https
                    if test -n "$proxy_url"
                        git config --global https.proxy "$proxy_url"
                        echo "Git HTTPS proxy set to: $proxy_url"
                    else
                        git config --global --unset https.proxy
                        echo "Git HTTPS proxy unset"
                    end
                case "*"
                    echo "Usage: set_proxy git [http|https] [proxy_url]"
                    return 1
            end
        case "*"
            echo "Usage: set_proxy [shells|git] [type] [proxy_url]"
            return 1
    end
end
