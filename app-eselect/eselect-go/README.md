The app-eselect/eselect-go is a Flatcar specific package, it does not
exist in the Gentoo repo. The updates should normally be about bumping
a version in the ebuild filename.

Consider phasing out this project and try strive to have all the
project to be buildable with a single version of go, that we package.
