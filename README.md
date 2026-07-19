proot
=====
[![Travis build status](https://travis-ci.org/termux/proot.svg?branch=master)](https://travis-ci.org/termux/proot)

This is a copy of [the PRoot project](https://github.com/proot-me/PRoot/) with patches applied to work better under [Termux](https://termux.com).

> **Warning** — This fork is AI-driven.  Changes may be unreliable
> and should be reviewed before use in production.

## Additional features

- **Read-only bind mounts**: append `,ro` to any `-b` argument to make the binding read-only. Write syscalls return `EROFS` inside the binding:

      proot -b /host/path:/guest/path,ro ./program

- **Performance optimizations**: path translation — the hottest code
  path in PRoot — was reworked to remove two O(n) scans that ran on
  *every* traced syscall:

  - **Hash-indexed binding lookup.** `get_binding()` previously
    linear-scanned the binding list for each syscall. Bindings are now
    stored in a `BindingHashTable` (32 buckets) with deepest-prefix
    matching, turning the common lookup into a near-constant-time
    operation regardless of how many `-b` bindings are configured.

  - **Per-tracee path translation cache.** A `PathCache` remembers the
    host path for a given `(user_path, cwd, dir_fd)` tuple and is
    consulted before doing the full canonicalize + binding lookup.
    It is invalidated on any mutating syscall (rename, unlink, chdir,
    …) so correctness is preserved. Programs that repeatedly touch the
    same paths (build systems, package managers, interpreters) see a
    substantial reduction in overhead.

  Both structures are inherited by forked children (shared for a plain
  `fork()`, a fresh copy for `CLONE_NEWNS`), so the speed-up applies to
  multi-process workloads, not just the initial command.

