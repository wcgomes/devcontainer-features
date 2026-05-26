#!/bin/bash
set -e

source dev-container-features-test-lib

OPENCODE_CONFIG=""
[ -f /root/.config/opencode/opencode.json ] && OPENCODE_CONFIG=/root/.config/opencode/opencode.json
[ -f /home/vscode/.config/opencode/opencode.json ] && OPENCODE_CONFIG=/home/vscode/.config/opencode/opencode.json

check "opencode binary exists" test -f /usr/local/bin/opencode

check "opencode-fix-permissions script exists" test -f /usr/local/bin/opencode-fix-permissions

check "opencode.json exists" test -n "$OPENCODE_CONFIG"

check "opencode.json has lsp key" jq -e '.lsp' "$OPENCODE_CONFIG"

check "opencode.json lsp is empty" test "$(jq '.lsp | length' "$OPENCODE_CONFIG")" -eq 0

reportResults
