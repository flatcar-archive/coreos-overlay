# Copyright (c) 2014 CoreOS, Inc.. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_PROJECT="flatcar-linux/updateservicectl"
CROS_WORKON_LOCALNAME="updateservicectl"
CROS_WORKON_REPO="git://github.com"
COREOS_GO_PACKAGE="github.com/coreos/updateservicectl"
inherit cros-workon coreos-go

if [[ "${PV}" == 9999 ]]; then
	KEYWORDS="~amd64 ~arm64"
else
	CROS_WORKON_COMMIT="0b60d85b5ebbe7f097c1c8e19f47fc7307ca322e" # v1.4.0
	KEYWORDS="amd64 arm64"
fi

DESCRIPTION="CoreUpdate Management CLI"
HOMEPAGE="https://github.com/coreos/updateservicectl"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="!app-admin/updatectl"

src_prepare() {
	coreos-go_src_prepare
	GOPATH+=":${S}/Godeps/_workspace"
}
