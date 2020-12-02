# Copyright (c) 2020 Kinvolk GmbH. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Vendor tools depending on this package will have vendor tools updates
#  activated. If the file created below is present, image_to_vm.sh will
#  populate it and will generate a vendor tools update tarball.

EAPI=6

DESCRIPTION="Vendor tools update service activation file"
HOMEPAGE=""
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE=""

# no source directory
S="${WORKDIR}"

src_install() {
	insinto "/usr/share/oem"
	doins  "${FILESDIR}/flatcar-oem-release"
}
