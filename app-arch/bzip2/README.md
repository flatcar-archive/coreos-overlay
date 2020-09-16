This is a fork of app-arch/bzip2 package from Gentoo. The sole reason
that the package is in coreos-overlay is to drop the patch that causes
decompression errors in the SDK for CL update payloads. Care needs to
be taken when updating the package, because the dropped patch is not
applied any more in later versions, which might mean that the patch
was merged upstream. If an update breaks the updates, it may be needed
to have a patch that is a reverse of the dropped patch.
