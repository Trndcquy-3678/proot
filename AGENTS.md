# PRoot Fork (Termux, v5.1.2)

Termux-patched fork of [PRoot](https://github.com/proot-me/PRoot/) — user-space `chroot`/`mount --bind` via ptrace.

## Build

```bash
make -C src clean && make -C src        # always clean first
make -C src V=1                         # verbose
```

Requires: `gcc`, `libtalloc-dev`, `git`.

The loader (`src/loader/`) is built separately — `make -C src` handles it
automatically. On x86_64/arm64 a 32-bit variant is also built.

## Test

```bash
make -C tests                           # run full suite
make -C tests V=1                       # verbose
```

Individual test:
```bash
PROOT=path/to/proot sh -ex tests/test-<name>.sh
```

Read-only bind tests:
```bash
PROOT=path/to/proot sh -ex tests/test-ro-bind.sh && echo "OK"
```

C tests are compiled statically into `tests/rootfs/bin/` by `make -C tests setup`.
Shell tests use `sh -ex` — no external test framework.

## Code style

- **K&R**, **8-space tab indentation**
- Emacs modeline: `/* -*- c-set-style: "K&R"; c-basic-offset: 8 -*- */`
- `-Wall -Wextra` — no warnings allowed
- Header guards: `FILENAME_H`
- License: GPLv2 on all source files
- No formatter configured — match existing style manually

## Architecture

### Key concepts

- **Tracee**: a ptrace-controlled process. The `Tracee` struct holds PID,
  registers (3 versions: CURRENT/ORIGINAL/MODIFIED), filesystem namespace
  (bindings + cwd), extensions, and chained syscalls.
- **Bindings**: map host paths to guest paths (`-b host:guest`). Stored as
  `Binding` structs in CIRCLEQ linked lists. The `,ro` suffix makes a binding
  read-only (writes return EROFS).
- **Syscall translation**: `translate_syscall_enter()` rewrites path arguments
  in syscalls according to bindings. Write-enforcement for read-only bindings
  happens BEFORE path translation (guest paths).
- **Extensions**: plugin system intercepting syscalls. Key extensions:
  `fake_id0` (fake root), `kompat` (kernel compat), `link2symlink`,
  `mountinfo`, `sysvipc`.

### Source layout

```
src/
  cli/          CLI parsing (-r, -b, -w, -k, -0, etc.)
  tracee/       Tracee lifecycle, event loop, registers, memory
  syscall/      Syscall enter/exit translation, seccomp, chain
  path/         Path translation, bindings, canon, glue, /proc
  execve/       ELF parsing, shebang, LD_SO handling
  ptrace/       PRoot ptrace emulation for guest debuggers
  extension/    Plugin system (fake_id0, kompat, hidden_files, etc.)
  loader/       Freestanding binary injected into tracee at startup
```

### Binding flow

1. `-b host:guest,ro` parsed in `cli/proot.c` → `handle_option_b()`
2. `insort_binding3()` stores binding with `read_only=true` in `binding.c`
3. On syscall entry (`syscall/enter.c`), `check_read_only()` checks if the
   target path matches a read-only binding — returns EROFS if so
4. Path translation then rewrites guest → host via `get_binding()`
5. `get_binding()` asserts `path[0] == '/'` — always guard non-absolute paths

### Important files

| File | Role |
|------|------|
| `src/path/binding.{c,h}` | Binding structs, `is_read_only_binding()`, insert/free |
| `src/syscall/enter.c` | `check_read_only()`, write enforcement for ~20 syscalls |
| `src/cli/proot.c` | `-b` option parsing, `,ro` suffix handling |
| `src/tracee/tracee.c` | Binding inheritance for child processes |
| `src/extension/mountinfo/mountinfo.c` | Reports `ro`/`rw` in mount info |
