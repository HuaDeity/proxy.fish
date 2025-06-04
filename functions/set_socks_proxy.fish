function set_socks_proxy -d "Set or unset SOCKS proxy" -a proxy_url
    if test -n "$proxy_url"
        set_proxy shells socks "$proxy_url"
    else
        unset_proxy shells socks
    end
end
