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
                # Get bypass domains. The output from networksetup is newline-separated.
                # When captured by command substitution `()`, it becomes a Fish list if multiple lines.
                set -l bypass_domains_list (networksetup -getproxybypassdomains "$network_service" 2>/dev/null)

                # Check if the command was successful and produced output
                if test $status -eq 0 -a (count $bypass_domains_list) -gt 0
                    # Check for the "no domains" message, which might be the only element in the list
                    # Match against the first element if the list is not empty
                    if not string match -q -- "*There aren't any bypass domains set on*" $bypass_domains_list[1]
                        # Join the list elements with a comma.
                        set detected_proxy_value (string join ',' $bypass_domains_list)
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
                # Output will likely be a single line, e.g., "Enabled: Yes Server: 127.0.0.1 Port: 6152 Authenticated Proxy Enabled: 0"
                set -l proxy_info_output (networksetup -get"$networksetup_proxy_kind" "$network_service" 2>/dev/null)

                if test $status -eq 0 -a -n "$proxy_info_output"
                    # Use string match with regex to parse the single-line output.
                    # -r specifies a regex.
                    # We look for "Enabled: Yes", then capture Server and Port.
                    # \S+ matches one or more non-whitespace characters.
                    set -l matches (string match -r -- 'Enabled: Yes.*Server: (\S+).*Port: (\S+)' "$proxy_info_output")

                    if test $status -eq 0 -a (count $matches) -ge 3
                        # $matches[1] is the full match
                        # $matches[2] is the first capture group (Server)
                        # $matches[3] is the second capture group (Port)
                        set -l server $matches[2]
                        set -l port $matches[3]

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
