This is a fork of the app-emulation/docker package from Gentoo. There
seem to be a couple of reasons for having this fork:

(Note that these points are about the docker-9999.ebuild only.)

- We use coreos go eclasses, we really need to check if this is
  necessary diversion from upstream.

- We depend on sys-kernel/coreos-kernel. This is to have access to the
  kernel config.

- We enable btrfs by default. We also have +journald and +selinux, so
  we pass those to docker build system through DOCKER_BUILDTAGS env
  var.

- We carry some dockerd script in /usr/lib/flatcar/dockerd for
  backward compatibility. Maybe it's time to drop it?

- We carry our own systemd service and socket units, instead of using
  ones from upstream. Also, we install our own network systemd files.

- We have three ebuilds - docker 1.12, docker 17.03 and docker 19.03.

  - Hopefully we can deprecate and remove the old ebuild soon.

Details:

- We don't install fish (some other shell) files. Preserving space?
  Why we install zsh stuff then?

- We don't install contrib stuff to preserve space.

- Our sed magic for hardened build seems to differ for no apparent
  reason.

- We seem to add a go1.13 tag to DOCKER_BUILDTAGS too - not sure if it
  is necessary since we now have go1.15 or later.

- We don't allow building the 9999 version.

- We seem to carry the static-libs thingy for the libseccomp dep. It
  was used by upstream for the last time in docker 1.11. We should
  likely drop it too.

- We dropped the dep on dev-go/go-md2man, thus we don't build and
  install man pages.

- We carry a patch engine to fix the toolchain name (ours have a
  -cros- part in the name).

  - Seems like a reason for adding src_unpack, since it seems to apply
    the patch in some special way.

- We do some stuff with setting the build date (we figure it out in
  src_unpack and use it in src_compile, see DOCKER_BUILD_DATE and
  CLI_BUILDTIME).

## Tips and Tricks

To hack on docker and develop a patch do these steps:

```
git clone https://github.com/docker/docker
cd docker
ln -s ../../../../ vendor/src/github.com/docker/docker
./hack/make.sh dynbinary
```

Then add some symlinks:

```
ln -s $PWD/bundles/VERSION-OF-DOCKER-dev/dynbinary/docker /usr/local/bin/docker
ln -s $PWD/bundles/VERSION-OF-DOCKER-dev/dynbinary/dockerinit /usr/local/bin/dockerinit
```
