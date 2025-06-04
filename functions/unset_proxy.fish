function unset_proxy -d "Unset proxy for specific protocol" -a plugin type
    set_proxy "$plugin" "$type" ""
end
