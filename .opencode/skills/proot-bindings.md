# Skill: proot-bindings

## When to use
When modifying path binding logic (`-b` option), read-only enforcement, or path translation.

## Key files
- `src/path/binding.{c,h}` — Binding struct, `is_read_only_binding()`, insert/free
- `src/cli/proot.c` — `-b` option parsing, `,ro` suffix
- `src/syscall/enter.c` — `check_read_only()`, write enforcement
- `src/path/path.c` — `get_binding()`, path translation
- `src/tracee/tracee.c` — binding inheritance for children

## Binding struct
```c
typedef struct binding {
    char host[MAX_PATH_SIZE];
    char guest[MAX_PATH_SIZE];
    bool read_only;
    bool need_injection;
    TAILQ_ENTRY(binding) guest;
    TAILQ_ENTRY(binding) host;
} Binding;
```

## Write enforcement order
1. `check_read_only()` runs BEFORE path translation (sees guest paths)
2. `get_binding()` translates guest → host (asserts `path[0] == '/'`)
3. Write syscalls: open, creat, unlink, mkdir, chmod, rename, symlink, etc.

## Gotchas
- `get_binding()` asserts `path[0] == '/'` — guard non-absolute paths
- Read-only check uses `is_read_only_binding()` which also guards non-absolute
- Binding inheritance: child processes copy parent's bindings
