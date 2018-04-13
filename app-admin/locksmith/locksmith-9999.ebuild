# Copyright (c) 2014 CoreOS, Inc.. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_PROJECT="flatcar-linux/locksmith"
CROS_WORKON_LOCALNAME="locksmith"
CROS_WORKON_REPO="git://github.com"
COREOS_GO_PACKAGE="github.com/coreos/locksmith"
inherit cros-workon systemd coreos-go

if [[ "${PV}" == 9999 ]]; then
	KEYWORDS="~amd64 ~arm64"
else
	CROS_WORKON_COMMIT="ab1dd50d047c1b51f1433660ae225410ad86d2aa" # v0.6.1
	KEYWORDS="amd64 arm64"
fi

DESCRIPTION="locksmith"
HOMEPAGE="https://github.com/coreos/locksmith"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

src_compile() {
	go_build "${COREOS_GO_PACKAGE}/locksmithctl"
}

src_install() {
	dobin ${GOBIN}/locksmithctl
	dodir /usr/lib/locksmith
	dosym ../../../bin/locksmithctl /usr/lib/locksmith/locksmithd

	systemd_dounit "${S}"/systemd/locksmithd.service
	systemd_enable_service multi-user.target locksmithd.service
}
