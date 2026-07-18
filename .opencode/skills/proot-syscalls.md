# Skill: proot-syscalls

## When to use
When modifying syscall translation, adding new syscall handling, or debugging syscall issues.

## Key files
- `src/syscall/enter.c` — `translate_syscall_enter()`, `check_read_only()`
- `src/syscall/exit.c` — `translate_syscall_exit()`
- `src/syscall/syscall.c` — Top-level `translate_syscall()` dispatch
- `src/syscall/sysnum.{c,h}` — Syscall number management (multi-ABI)
- `src/syscall/chain.{c,h}` — Chained (injected) syscalls

## Flow
1. ptrace intercepts syscall entry/exit
2. `translate_syscall_enter()` rewrites path arguments per bindings
3. `translate_syscall_exit()` handles return value translation
4. Extensions can intercept at SYSCALL_ENTER_START/END, SYSCALL_EXIT_START/END

## Read-only enforcement
`check_read_only()` in `enter.c` checks ~20 write syscalls:
- File creation: open, openat, openat2, creat
- Deletion: unlink, unlinkat, rmdir
- Directory: mkdir, mkdirat
- Rename: rename, renameat, renameat2
- Link: link, linkat, symlink, symlinkat
- Permissions: chmod, fchmodat, chown, fchownat, lchownat
- Truncate: truncate, ftruncate
- Attributes: setxattr, removexattr
- Other: mknod, mknodat, futimesat

## Multi-ABI support
Architectures: x86_64, i386, x32, ARM, ARM64, SH4
Syscall numbers mapped via `sysnums-*.h` generated from `sysnums.list`
