#!/bin/bash
set -e

source dev-container-features-test-lib

check "opencode binary exists" test -f /usr/local/bin/opencode

check "opencode is installed in PATH" command -v opencode

check "opencode.json exists" test -f /home/vscode/.config/opencode/opencode.json

check "opencode.json has lsp key" jq -e '.lsp' /home/vscode/.config/opencode/opencode.json

check "opencode.json lsp is empty" test "$(jq '.lsp' /home/vscode/.config/opencode/opencode.json)" = "{}"

reportResults