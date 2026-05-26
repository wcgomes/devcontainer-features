---
title: PostStart config creation for volume mount resilience
date: 2026-05-26
status: accepted
---

## Context

The `opencode` feature creates `~/.config/opencode/opencode.json` (with `lsp: {}`) during `install.sh` at build time. When a Docker volume is mounted at `/home/vscode/.config/opencode`, the volume starts empty at runtime and hides the build-time file. The `postStartCommand.sh` did not recreate it, so LSP servers remained unconfigured.

The `agents-workspace` feature demonstrates the correct pattern: `install.sh` only copies the postStart script, and all actual setup happens in `postStartCommand.sh` at runtime.

## Decision

Move `opencode.json` creation (and directory ownership fixes) from `install.sh` into `postStartCommand.sh`, which runs every container start. `install.sh` still creates the file at build time (harmless for non-volume cases), but `postStartCommand.sh` guarantees it exists even when a volume replaces the directory.

## Consequences

- Volume mounts no longer break LSP server configuration
- `postStartCommand.sh` is idempotent — if the file exists with `lsp`, it skips creation; if it exists without `lsp`, it merges it in
- Ownership is corrected at runtime in case the volume changes UID/GID mappings
- Tests now validate that `postStartCommand.sh` can recreate the config independently
