# proxy.fish

A lightweight, cross-platform helper that automates _and_ simplifies proxy configuration from your **fish** session.

---

## Features

- **Auto-detect** system proxies on macOS (falls back gracefully on other OSes)
- **One environment variable per proxy kind** — provide full URIs.
- Mirrors lowercase ↔ uppercase env vars (`http_proxy` → `HTTP_PROXY`, etc.)
- **Toggle setters** — call `set_http_proxy <uri>` to set, call with _no arg_ to unset
- Git integration (`http.proxy`, `https.proxy`) follows the same precedence

---

## Requirements

- `fish` 3.0 or later
- [`git`](https://git-scm.com/) if you want Git proxy auto-config
- On macOS: network proxies should be configured in **System Settings → Network** (the plugin reads them via native commands)

> **Note**: No external dependencies — pure fish script.

---

## Installation

Using [Fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install HuaDeity/proxy.fish
```
