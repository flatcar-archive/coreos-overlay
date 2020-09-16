This is a package for actool. It's a package specific for Flatcar,
thus not packaged by Gentoo. Updating the package usually means
changing the CROS_WORKON_COMMIT variable in the ebuild to a commit ID
from https://github.com/appc/spec. So most of the maintenance of this
package happens actually in the project's git repo.

I think it should be deprecated and removed - ACI is a format
understood by mostly only by rkt, which should also be deprecated.
