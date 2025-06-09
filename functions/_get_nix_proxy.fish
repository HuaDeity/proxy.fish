function _get_nix_proxy --description "Get Nix proxy"
    set -l proxy_type $argv[1] # e.g., http, https, all, no
    set -l value_to_return ""

    set -l base_var_name (string lower "$proxy_type")"_proxy"
    set -l lower_var "$base_var_name"
    set -l upper_var (string upper "$base_var_name")

    # Read current state without sudo
    if test (uname) = Darwin
        set -l plist_file "/Library/LaunchDaemons/org.nixos.nix-daemon.plist"
        if test -e $plist_file
            set value_to_return (plutil -extract EnvironmentVariables.$lower_var raw $plist_file 2>/dev/null)
            set value_to_return (plutil -extract EnvironmentVariables.$upper_var raw $plist_file 2>/dev/null)
        end
    else if test (uname) = Linux
        set -l override_dir "/etc/systemd/system/nix-daemon.service.d"
        set -l proxy_conf_file "$override_dir/$proxy_type.conf"

        if test -e $proxy_conf_file
            set value_to_return (grep -oP "$lower_var=\K[^\"]*" $proxy_conf_file)
            set value_to_return (grep -oP "$upper_var=\K[^\"]*" $proxy_conf_file)
        end
    end

    echo -n "$value_to_return"
end
