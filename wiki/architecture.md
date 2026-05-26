# Architecture

```
.devcontainer/          # Dev container config
.github/workflows/      # CI workflows
├── release.yaml        # Publish on tag push
├── test.yaml           # Run feature tests
└── validate.yaml      # Validate features
src/                    # Feature implementations
├── opencode/
│   ├── devcontainer-feature.json  # metadata + options
│   ├── install.sh                 # build-time setup
│   ├── postStartCommand.sh        # runtime config (volume resilience)
│   ├── README.md
│   └── NOTES.md
├── agents-workspace/
│   ├── devcontainer-feature.json
│   ├── install.sh
│   ├── postStartCommand.sh
│   ├── README.md
│   └── NOTES.md
└── agency-agents/
    ├── devcontainer-feature.json
    ├── install.sh
    ├── README.md
    └── NOTES.md
test/                    # Test scenarios for each feature
wiki/                    # This wiki
```

Features published to GHCR as `ghcr.io/devcontainer-features/<feature>:<version>`.