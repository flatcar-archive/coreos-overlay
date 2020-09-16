The app-shells/bash package is a fork of the Gentoo package. The
reasons for having it in coreos-overlay are:

- We put `bash_logout` and `bashrc` in `/usr/share/bash` (instead of
  `/etc/bash`) and create symlinks in `/etc/bash` to those files.

- We put `dot-bash_logout`, `dot-bashrc` and `dot-bash_profile` in
  `/usr/share/skel` (instead of `/etc/skel`) and create symlinks in
  `/etc/skel` to those files.

- `.bashrc` and `bashrc` files are modified in `src_install`, so their
  paths are also updated from `/etc` to `/usr/share`.

- Two gentoo patches were dropped during updates of the ebuild,
  because they were dropped upstream, but the rest of the ebuild
  wasn't synced yet.

- Files in `files` (`dot-bash*` and `bash{rc,_logout}` should be kept
  in sync with upstream, we have no our own changes there).
