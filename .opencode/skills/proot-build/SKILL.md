---
name: proot-build
description: Build PRoot from source, handle dependencies, and troubleshoot build issues
---

## Build commands

```bash
make -C src clean && make -C src        # always clean first
make -C src V=1                         # verbose
```

Requires: `gcc`, `libtalloc-dev`, `git`.

The loader (`src/loader/`) is built automatically by `make -C src`. On x86_64/arm64 a 32-bit variant is also built.

## Troubleshooting

- Stale `.o` files cause assertion failures after signature changes — always `make -C src clean` first
- Verify binary: `ls -la src/proot`
- Cross-compile: set `CROSS_COMPILE` prefix
- Verbose: `make -C src V=1`
