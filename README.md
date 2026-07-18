proot
=====
[![Travis build status](https://travis-ci.org/termux/proot.svg?branch=master)](https://travis-ci.org/termux/proot)

This is a copy of [the PRoot project](https://github.com/proot-me/PRoot/) with patches applied to work better under [Termux](https://termux.com).

> **Warning** — This fork is AI-driven.  Changes may be unreliable
> and should be reviewed before use in production.

## Additional features

- **Read-only bind mounts**: append `,ro` to any `-b` argument to make the binding read-only. Write syscalls return `EROFS` inside the binding:

      proot -b /host/path:/guest/path,ro ./program
