#!/usr/bin/env bash
set -euo pipefail

echo_prefix="[opencode-poststart]"

autoupdate="${AUTOUPDATE:-true}"

# ensure volume-mounted config directories exist and have correct ownership
detect_user() {
  local user="${_REMOTE_USER:-${USERNAME:-}}"
  if [ -z "$user" ]; then
    user="$(getent passwd | awk -F: '$3 >= 1000 && $1 !~ /^(nobody|nfsnobody|daemon)$/ {print $1; exit 0}')" || true
  fi
  if [ -z "$user" ]; then
    user="$(getent passwd | awk -F: '$3 == 0 && $1 == "root" {print $1; exit 0}')" || true
  fi
  [ -z "$user" ] && user="root"
  echo "$user"
}

TARGET_USER="$(detect_user)"
TARGET_HOME="$(getent passwd "$TARGET_USER" 2>/dev/null | cut -d: -f6)"
[ -z "$TARGET_HOME" ] && TARGET_HOME="/home/$TARGET_USER"

# recreate directories masked by volume mounts
mkdir -p "${TARGET_HOME}/.config/opencode"
mkdir -p "${TARGET_HOME}/.local/share/opencode"
mkdir -p "${TARGET_HOME}/.local/state/opencode"

# ensure opencode.json with lsp config exists
opencode_config="${TARGET_HOME}/.config/opencode/opencode.json"
if [ -f "$opencode_config" ]; then
  if ! jq -e '.lsp' "$opencode_config" >/dev/null 2>&1; then
    jq '. + {"lsp": {}}' "$opencode_config" > "${opencode_config}.tmp" && mv "${opencode_config}.tmp" "$opencode_config"
    echo "$echo_prefix added 'lsp' key to existing opencode.json"
  fi
else
  cat > "$opencode_config" <<'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "lsp": {}
}
EOF
  echo "$echo_prefix created opencode.json with LSP enabled"
fi

chown -R "${TARGET_USER}:${TARGET_USER}" \
  "${TARGET_HOME}/.config/opencode" \
  "${TARGET_HOME}/.local/share/opencode" \
  "${TARGET_HOME}/.local/state/opencode" 2>/dev/null || true

if ! command -v opencode >/dev/null 2>&1; then
    echo "$echo_prefix opencode not found, installing..."
    curl -fsSL https://opencode.ai/install | bash
fi

if [ "$autoupdate" = "true" ]; then
    echo "$echo_prefix running autoupgrade..."
    opencode upgrade --yes 2>/dev/null || true
fi

echo "$echo_prefix done"