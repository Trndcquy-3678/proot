---
name: proot-test
description: Run PRoot tests, write new tests, and understand the test framework
---

## Run full suite

```bash
make -C tests
```

## Run individual test

```bash
PROOT=path/to/proot sh -ex tests/test-<name>.sh
```

## Read-only bind tests

```bash
PROOT=path/to/proot sh -ex tests/test-ro-bind.sh && echo "OK"
```

## Write new shell tests

- Use `sh -ex` (no test framework)
- Check tools with `which` and exit 125 if missing
- Use `${TMPDIR:-/tmp}` for temp dirs (Termux has no /tmp)
- Paths inside proot are GUEST paths, not host paths
- Test both positive (command works) and negative (`! command` fails)

## C tests

- Compiled statically into `tests/rootfs/bin/` by `make -C tests setup`
- Run via `check-test-<name>.c` target in the test Makefile
