# Skill: proot-build

## When to use
When building PRoot from source.

## Steps
1. Always clean first: `make -C src clean`
2. Build: `make -C src`
3. Verbose: `make -C src V=1`
4. Verify binary exists: `ls -la src/proot`

## Dependencies
- gcc, libtalloc-dev, git

## Notes
- The loader is built automatically by `make -C src`
- On x86_64/arm64 a 32-bit loader variant is also built
- If the binary has stale code, always do `make -C src clean` first
