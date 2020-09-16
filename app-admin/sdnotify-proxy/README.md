This is a package for sdnotify-proxy. It's a package specific for Flatcar,
thus not packaged by Gentoo. Updating the package usually means
changing the CROS_WORKON_COMMIT variable in the ebuild to a commit ID
from https://github.com/flatcar-linux/sdnotify-proxy. So most of the
maintenance of this package happens actually in the project's git
repo.

This package seems to be deprecated and should undergo a removal
process. It used to be required by sys-admin/flannel-wrapper.
