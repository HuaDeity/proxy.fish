function set_https_proxy -d "Set or unset HTTPS proxy" -a proxy_url
    if test -n "$proxy_url"
        set_proxy shells https "$proxy_url"
    else
        unset_proxy shells https
    end
end
