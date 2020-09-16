The app-misc/ca-certificates may look like a fork of the Gentoo
package, but it's so heavily modified, that there is no sense in
trying to sync the package with upstream. So we can state that this is
a Flatcar specific package. In order to update the package, it should
be enough to mention the new version of the NSS release in `Manifest`
and rename the ebuild file accordingly.

The differences seem to be more or less:

- We don't use certificates from Debian, but rather directly from mozilla.

  - We only borrow the certdata2pem.py script from Debian to convert
    the data at build time.

- We don't use a date in the version.

  - This may cause some problems if some other package depeneds on a
    specific version of ca-certificates. So far no such package exists
    in Flatcar.

- We install the certificates at the toplevel
  `/usr/share/ca-certificates` directory, instead of in `mozilla`
  subdirectory.

- We use systemd-tmpfiles to generate the symlinks (and hashed
  symlinks) from /etc/ssl/certs to /usr/share/ca-certificates.
