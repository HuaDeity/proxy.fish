function _set_nix_proxy --description "Set Nix proxy"
    set -l proxy_type $argv[1] # e.g., http, https, all, no
    set -l proxy_value $argv[2] # e.g., http://proxy.example.com:8080 or "" to unset

    # Check current proxy setting first
    set -l current_proxy (_get_nix_proxy $proxy_type)

    # Compare current and desired proxy values
    if test "$current_proxy" = "$proxy_value"
        return 0
    end

    # Define the base variable name (e.g., http_proxy, no_proxy)
    set -l base_var_name (string lower "$proxy_type")"_proxy"
    set -l upper_var_name (string upper "$base_var_name")

    if test (uname) = Darwin
        # macOS implementation (remains the same)
        set -l plist_file "/Library/LaunchDaemons/org.nixos.nix-daemon.plist"
        if not test -e $plist_file
            return 1
        end

        if test -n "$proxy_value"
            sudo plutil -replace EnvironmentVariables.$base_var_name -string "$proxy_value" $plist_file
            sudo plutil -replace EnvironmentVariables.$upper_var_name -string "$proxy_value" $plist_file
        else
            sudo plutil -remove EnvironmentVariables.$base_var_name $plist_file
            sudo plutil -remove EnvironmentVariables.$upper_var_name $plist_file
        end

        sudo launchctl unload $plist_file
        sudo launchctl load $plist_file

    else if test (uname) = Linux
        # SAFER Linux implementation
        set -l override_dir "/run/systemd/system/nix-daemon.service.d"
        set -l proxy_conf_file "$override_dir/$proxy_type.conf"

        if test -n "$proxy_value"
            sudo mkdir -p $override_dir
            # Write to a dedicated proxy.conf file
            echo -e "[Service]\nEnvironment=\"$base_var_name=$proxy_value\"\nEnvironment=\"$upper_var_name=$proxy_value\"" | sudo tee $proxy_conf_file >/dev/null
        else
            # Remove only the dedicated proxy.conf file
            sudo rm -f $proxy_conf_file
        end

        sudo systemctl daemon-reload
        sudo systemctl restart nix-daemon.service
    else
        return 1
    end
end
