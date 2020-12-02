# Copyright (c) 2020 Kinvolk GmbH. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This is the base vendortools updater service. In order for oem-* packages
#  to use the update service the oem-* ebuilds must DEPEND / RDEPEND on
#  coreos-base/oem-update-vendortools (see ebuild file there).

EAPI=6

inherit systemd

DESCRIPTION="Vendor tools update service"
HOMEPAGE=""
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE=""

# no source directory
S="${WORKDIR}"

RDEPEND=""

src_install() {
	exeinto "/usr/bin"
	doexe "${FILESDIR}/usr/bin/check-update-vendortools.sh"
	systemd_dounit "${FILESDIR}/units/check-update-vendortools.service"
	systemd_enable_service local-fs.target check-update-vendortools.service
}
