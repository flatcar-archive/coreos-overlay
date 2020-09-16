This is a fork of the app-emulation/containerd package from
Gentoo. There seem to be a couple of reasons for having this fork:

- We package a newer version than Gentoo has (1.3.4 in Gentoo vs 1.3.7
  in overlay, at a time of writing).

- We use coreos go eclasses, we really need to check if this is
  necessary diversion from upstream.

- We add src_unpack to set up the go workspace for the coreos go
  eclass.

  - Same point as above.

- We add a systemd service unit, we are running containerd directly as
  opposed to docker running it.

  - There are two systemd service unit files.
    `containerd-1.0.0.service` is installed by the new ebuild,
    `containerd.service` is installed by the old ones.

- We have custom configuration (`./files/config.toml`), where we seem
  to differ from defaults in some places:

  - We use different runtime state
    (/run/docker/libcontainerd/containerd vs /run/containerd). Is this
    to mimic how docker configures containerd when docker launches
    containerd itself?

  - Not sure about subreaper - it's not printed at all in default
    config - old/removed setting?

  - We set oom_score to -999 (vs default 0), looks like we really
    don't want to be killed.

  - We disable cri plugin (docker does the same when it launches
    containerd).

  - In grpc, we use different address
    (/run/docker/libcontainerd/docker-containerd.sock vs
    /run/containerd/containerd.sock), same question about mimicking
    docker.

  - In plugins.linux we set shim_debug to true (default false).

- We have three ebuilds - 0.2.5 for docker 1.12, 0.2.6 for docker
  17.03 and 1.3.7 for docker 19.03.

  - The old ebuilds could be dropped when we drop the old docker
    ebuilds too.
