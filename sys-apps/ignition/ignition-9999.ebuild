# Copyright (c) 2015 CoreOS, Inc.. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_PROJECT="flatcar-linux/ignition"
CROS_WORKON_LOCALNAME="ignition"
CROS_WORKON_REPO="git://github.com"
COREOS_GO_PACKAGE="github.com/coreos/ignition"
inherit coreos-go cros-workon systemd udev

if [[ "${PV}" == 9999 ]]; then
	KEYWORDS="~amd64 ~arm64"
else
	CROS_WORKON_COMMIT="b522f642841d8d46062743b76cba61134980dd78" # tag v0.33.0
	KEYWORDS="amd64 arm64"
fi

DESCRIPTION="Pre-boot provisioning utility"
HOMEPAGE="https://github.com/coreos/ignition"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0/${PVR}"
IUSE=""

# need util-linux for libblkid at compile time
DEPEND="sys-apps/util-linux"

RDEPEND="
	sys-apps/coreutils
	sys-apps/gptfdisk
	sys-apps/shadow
	sys-apps/systemd
	sys-fs/btrfs-progs
	sys-fs/dosfstools
	sys-fs/e2fsprogs
	sys-fs/mdadm
	sys-fs/xfsprogs
"

RDEPEND+="${DEPEND}"

PATCHES=(
	"${FILESDIR}/0001-providers-allow-FetchConfig-to-mutate-the-fetcher.patch"
	"${FILESDIR}/0002-providers-aws-get-region-after-getting-config.patch"
)

src_compile() {
	export GO15VENDOREXPERIMENT="1"
	GO_LDFLAGS="-X github.com/coreos/ignition/internal/version.Raw=$(git describe --dirty)" || die
	go_build "${COREOS_GO_PACKAGE}/internal"
}

src_install() {
	newbin ${GOBIN}/internal ${PN}
}
