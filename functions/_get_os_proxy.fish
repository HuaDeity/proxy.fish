# Internal helper function to detect proxy settings from the Operating System.
# Currently, this is implemented primarily for macOS.

function _get_os_proxy --description "Detect proxy settings from the OS (macOS specific)"
    set -l proxy_type_query $argv[1] # e.g., http, https, all, no
    set -l detected_proxy_value ""

    # This function is primarily for macOS.
    # Check if 'uname' output is Darwin.
    if test (uname -s) = Darwin
        # --- macOS Proxy Detection Logic ---

        # Get the primary active network service (e.g., Wi-Fi, Ethernet).
        # This command tries to find common service names.
        set -l network_service (networksetup -listallnetworkservices | string match -r 'Wi-Fi|AirPort|Ethernet|Display.*' | head -n 1)

        if test -z "$network_service"
            # echo "fish-proxy: (_get_os_proxy) No active network service found on macOS." >&2
            return 1 # Indicate failure or no proxy found
        end

        switch "$proxy_type_query"
            case no # For no_proxy / bypass domains
                # Get bypass domains. The output is newline-separated.
                set -l bypass_domains_output (networksetup -getproxybypassdomains "$network_service" 2>/dev/null)
                if test $status -eq 0 -a -n "$bypass_domains_output"
                    # Check for the "no domains" message.
                    if not string match -q "*There aren't any bypass domains set on*" -- "$bypass_domains_output"
                        # Convert newline-separated list to comma-separated.
                        set detected_proxy_value (echo "$bypass_domains_output" | tr '\n' ',' | string trim -c ',')
                    end
                end

            case http https all
                set -l networksetup_proxy_kind ""
                switch "$proxy_type_query"
                    case http
                        set networksetup_proxy_kind webproxy # Command is -getwebproxy
                    case https
                        set networksetup_proxy_kind securewebproxy # Command is -getsecurewebproxy
                    case all # Often maps to SOCKS on macOS system settings
                        set networksetup_proxy_kind socksfirewallproxy # Command is -getsocksfirewallproxy
                end

                # Fetch proxy info for the determined kind.
                set -l proxy_info_output (networksetup -get"$networksetup_proxy_kind" "$network_service" 2>/dev/null)

                if test $status -eq 0 -a -n "$proxy_info_output"
                    # Check if proxy is enabled.
                    set -l is_enabled (echo "$proxy_info_output" | grep "Enabled: Yes")
                    if test -n "$is_enabled"
                        set -l server (echo "$proxy_info_output" | grep "Server:" | string split ' ' -f 2)
                        set -l port (echo "$proxy_info_output" | grep "Port:" | string split ' ' -f 2)

                        if test -n "$server" -a -n "$port" -a "$port" != 0
                            set detected_proxy_value "$server:$port"
                        end
                    end
                end
        end
    else
        # echo "fish-proxy: (_get_os_proxy) OS proxy detection not implemented for "(uname -s) >&2
        return 1 # Indicate not implemented or no proxy found
    end

    echo -n "$detected_proxy_value"
    # Return 0 if a value (even empty) is determined, 1 if error/not found.
    if test -n "$detected_proxy_value"
        return 0
    else if test (uname -s) = Darwin # On macOS, an empty value is a valid "not set"
        return 0
    else
        return 1 # For other OSes, if we reach here, it means not implemented.
    end
end
