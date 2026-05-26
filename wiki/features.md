# Features

## opencode

Installs opencode CLI and ensures volume-mounted config directories are writable.

Options:
- `username` (default: _REMOTE_USER) — user to install for
- `version` (default: empty/latest) — install specific version
- `autoupdate` (default: true) — auto-upgrade on container start

Behavior:
- `install.sh` installs the CLI, creates directories, writes `~/.config/opencode/opencode.json` with `lsp: {}`, and generates a fix-permissions script.
- `postStartCommand.sh` ensures `opencode.json` exists at every start (critical when `~/.config/opencode` is a volume mount), installing opencode if missing and running autoupgrade when enabled.

Idempotency: marker uses version if specified, else "latest"

## agency-agents

Installs msitarzewski/agency-agents for Cursor/Copilot integration.

Options:
- `tool` (default: auto) — tool to install agents for
- `autoupdate` (default: true) — check for updates on container start via GitHub API