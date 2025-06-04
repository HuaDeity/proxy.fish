function set_http_proxy -d "Set or unset HTTP proxy" -a proxy_url
    if test -n "$proxy_url"
        set_proxy shells http "$proxy_url"
    else
        unset_proxy shells http
    end
end
