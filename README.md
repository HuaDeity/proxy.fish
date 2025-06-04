# proxy.fish

A lightweight, cross-platform helper that automates and simplifies proxy configuration for Fish shell.

**Platforms:** macOS • Linux • WSL • Any system with Fish shell & Git

## Features

- **Auto-detect system proxies** on macOS (falls back gracefully on other OSes)
- **Configurable proxy settings** — provide full URIs, no more server/port pairs
- **Mirrors lowercase ↔ uppercase env vars** (`http_proxy` → `HTTP_PROXY`, etc.)
- **Toggle setters** — call `set_http_proxy <uri>` to set, call with no arg to unset
- **Git integration** (`http.proxy`, `https.proxy`) follows the same precedence
- **Pure Fish** — No external dependencies or Python/Ruby helpers

## Requirements

- **Fish shell** 3.0 or later
- **Git** (optional, if you want Git proxy auto-config)
- **macOS**: Network proxies should be configured in System Settings → Network (the plugin reads them via native commands)

## Installation

### Fisher

```bash
fisher install HuaDeity/proxy.fish
```

## Usage

### Basic Commands

```bash
proxy   # auto-configure from settings → OS detection
noproxy # clear everything (env + Git)
proxys  # show all proxy settings
```

### Advanced Functions

| Function                      | Action                                                   |
| ----------------------------- | -------------------------------------------------------- |
| `set_proxy PLUGIN TYPE PROXY` | Set proxy for specific app with specific protocol type   |
| `unset_proxy PLUGIN TYPE`     | Unset proxy for specific app with specific protocol type |
| `set_http_proxy [URI]`        | Set/unset HTTP proxy                                     |
| `set_https_proxy [URI]`       | Set/unset HTTPS proxy                                    |
| `set_socks_proxy [URI]`       | Set/unset SOCKS proxy                                    |

## Configuration

Add these variables to your `~/.config/fish/config.fish`:

```fish
# Basic proxy configuration
set -g FISH_PROXY_HTTP '192.168.1.2:7890'
set -g FISH_PROXY_HTTPS '192.168.1.2:7890'
set -g FISH_PROXY_SOCKS '127.0.0.1:8888'
set -g FISH_PROXY_MIXED '127.0.0.1:8888'
set -g FISH_PROXY_NO 'localhost,127.0.0.1,.internal'

# Plugin behavior
set -g FISH_PROXY_TYPE 'http https all no' # default
set -g FISH_PROXY_PLUGINS shells # default

# Run automatically on shell startup
set -g FISH_PROXY_AUTO true # default: false
```

Call `proxy` manually at any time to reload settings.

## Priority System

1. **User-defined settings** — Variables set in config.fish have highest priority
2. **macOS system proxy** — When on macOS & helper functions are available, the plugin queries the active network service for `web`, `secureweb`, and `socksfirewall` proxies
3. **Fallback** — If nothing is found, environment variables are unset
4. **Git** — `git config --global http(s).proxy` is kept in sync with the chosen URIs (or removed when proxies are unset)

Everything is handled in pure Fish — no external processes unless Git commands are needed.

## Examples

### Basic Usage

```fish
# Set proxy configuration
set -g FISH_PROXY_HTTP 'http://proxy.company.com:8080'
set -g FISH_PROXY_HTTPS 'http://proxy.company.com:8080'

# Apply settings
proxy

# Check current settings
proxys

# Clear all proxies
noproxy
```

### Advanced Usage

```fish
# Set specific proxy types
set_proxy shells http 'http://proxy.example.com:8080'
set_proxy shells https 'http://proxy.example.com:8080'
set_proxy shells socks 'socks5://127.0.0.1:1080'

# Set Git-specific proxies
set_proxy git http 'http://git-proxy.company.com:8080'
set_proxy git https 'http://git-proxy.company.com:8080'

# Toggle proxies (call without arguments to unset)
set_http_proxy 'http://temp-proxy.com:8080'
set_http_proxy # unsets the proxy

# Set no-proxy list
set_proxy shells no 'localhost,127.0.0.1,*.internal,.company.com'
```

### Auto-configuration

```fish
# Enable auto-configuration on shell startup
set -g FISH_PROXY_AUTO true

# This will automatically run 'proxy' command when Fish starts
```

## Configuration Variables

| Variable             | Description                              | Default                         |
| -------------------- | ---------------------------------------- | ------------------------------- |
| `FISH_PROXY_HTTP`    | HTTP proxy URL                           | (empty)                         |
| `FISH_PROXY_HTTPS`   | HTTPS proxy URL                          | (empty)                         |
| `FISH_PROXY_SOCKS`   | SOCKS proxy URL                          | (empty)                         |
| `FISH_PROXY_MIXED`   | Mixed proxy URL (fallback for all types) | (empty)                         |
| `FISH_PROXY_NO`      | No-proxy list (comma-separated)          | `localhost,127.0.0.1,.internal` |
| `FISH_PROXY_TYPE`    | Proxy types to handle                    | `http https all no`             |
| `FISH_PROXY_PLUGINS` | Plugins to configure                     | `shells`                        |
| `FISH_PROXY_AUTO`    | Auto-configure on startup                | `false`                         |

## Environment Variables Set

The plugin manages these environment variables:

- `http_proxy` / `HTTP_PROXY`
- `https_proxy` / `HTTPS_PROXY`
- `socks_proxy` / `SOCKS_PROXY`
- `all_proxy` / `ALL_PROXY`
- `no_proxy` / `NO_PROXY`

## Git Integration

When `FISH_PROXY_PLUGINS` includes `git`, the plugin also manages:

- `git config --global http.proxy`
- `git config --global https.proxy`

## Contributing

Pull requests are welcome! Feel free to improve Linux/WSL auto-detection, add tests, or polish the documentation.

## License

MIT

## Differences from Original zsh-proxy

This Fish port maintains the same core functionality as the original zsh-proxy but adapts to Fish shell conventions:

- Uses Fish variables instead of zstyle
- Implements Fish-specific function syntax and features
- Maintains the same command interface and behavior
- Preserves all original functionality including macOS system proxy detection

The plugin is designed to be a drop-in replacement for zsh-proxy users switching to Fish shell.
