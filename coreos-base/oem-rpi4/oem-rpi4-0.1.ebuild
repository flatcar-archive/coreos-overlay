# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OEM configuration for running Flatcar on RaspberryPi 4"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="arm64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-boot/rpi4-uefi-bin
"

S="${WORKDIR}"

src_prepare() {
	default
	sed -e "s\\@@OEM_VERSION_ID@@\\${PVR}\\g" \
		"${FILESDIR}/oem-release" > "${T}/oem-release" || die
}
src_install() {
	insinto "/usr/share/oem"
	doins "${FILESDIR}/grub.cfg"
	doins "${T}/oem-release"
}
