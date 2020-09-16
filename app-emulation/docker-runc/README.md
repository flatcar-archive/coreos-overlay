The app-emulation/docker-runc package started as a packaging of the
docker's fork of runc. Currently it holds two ebuilds - one for docker
17.03 and one for docker 19.03. Currently the ebuild for docker 17.03
actually follows the fork, while the ebuild for docker 19.03 follows
the actual upstream (as does the ebuild in app-emulation/runc, so it's
a bit of a mess).

The reasons for having our fork seem to be:

- We use the coreos go eclasses.

- We package newer version than upstream.

- We enable selinux and carry some patches.

- We drop the src_prepare function that hides the used commit.

- We override the version to denote that this is a docker fork.

  - I think it's wrong for the ebuild for docker 19.03, since it's
    using upstream code, not the docker fork.
