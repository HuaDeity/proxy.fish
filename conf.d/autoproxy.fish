# Auto-configure proxy on shell startup if enabled
if test "$FISH_PROXY_AUTO" = true
    proxy >/dev/null 2>&1
end
