The app-emulation/xenserver-pv-version package is Flatcar specific, it
does not exist in the Gentoo repo. The package is for injecting fake data
for XenServer's PV driver version detection.

XenServer expects virtual machines to run their own version of the Xen
para-virtualized drivers and will not attach disks otherwise. This is
really unnecessary since the ones bundled in Linux are perfectly fine.
In order to work around this write the latest version of XenServer to
special variables in xenstore. This is done with a systemd unit that
runs as a part of the sysinit.target.

This package is included in all images rather than OEM since this
could impact any XenServer user.
