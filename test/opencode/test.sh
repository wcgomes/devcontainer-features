#!/bin/bash
set -e

source dev-container-features-test-lib

check "opencode binary exists" test -f /usr/local/bin/opencode

check "opencode-fix-permissions script exists" test -f /usr/local/bin/opencode-fix-permissions

check "opencode postStartCommand script exists for autoupdate" test -f /usr/local/share/devcontainer-features/opencode-postStartCommand.sh

check "opencode.json exists" test -f /home/vscode/.config/opencode/opencode.json

check "opencode.json has lsp key" jq -e '.lsp' /home/vscode/.config/opencode/opencode.json

check "opencode.json lsp is an object" test "$(jq -r '.lsp | type' /home/vscode/.config/opencode/opencode.json)" = "object"

check "opencode.json lsp is empty" test "$(jq '.lsp' /home/vscode/.config/opencode/opencode.json)" = "{}"

reportResults
