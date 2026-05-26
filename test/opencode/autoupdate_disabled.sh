#!/bin/bash
set -e

source dev-container-features-test-lib

OPENCODE_CONFIG=""
[ -f /root/.config/opencode/opencode.json ] && OPENCODE_CONFIG=/root/.config/opencode/opencode.json
[ -f /home/vscode/.config/opencode/opencode.json ] && OPENCODE_CONFIG=/home/vscode/.config/opencode/opencode.json

check "opencode binary exists" test -f /usr/local/bin/opencode

check "opencode.json exists" test -n "$OPENCODE_CONFIG"

check "opencode.json has lsp key" jq -e '.lsp' "$OPENCODE_CONFIG"

check "opencode.json lsp is empty" test "$(jq '.lsp | length' "$OPENCODE_CONFIG")" -eq 0

# test postStartCommand recreates config when missing (volume mount case)
OPENCODE_CONFIG_BAK="$OPENCODE_CONFIG"
rm -f "$OPENCODE_CONFIG_BAK"
AUTOUPDATE=false bash /usr/local/share/devcontainer-features/opencode-postStartCommand.sh || true
check "postStartCommand recreates opencode.json" test -f "$OPENCODE_CONFIG_BAK"
check "recreated opencode.json has lsp key" jq -e '.lsp' "$OPENCODE_CONFIG_BAK"
check "recreated opencode.json lsp is empty" test "$(jq '.lsp | length' "$OPENCODE_CONFIG_BAK")" -eq 0

reportResults