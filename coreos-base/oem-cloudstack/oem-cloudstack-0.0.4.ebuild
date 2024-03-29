#
# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Copyright (c) 2014 CoreOS, Inc.. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
# $Header:$
#

EAPI=7

DESCRIPTION="OEM suite for CloudStack images"
HOMEPAGE=""
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# no source directory
S="${WORKDIR}"

src_prepare() {
	default
	sed -e "s\\@@OEM_VERSION_ID@@\\${PVR}\\g" \
	    "${FILESDIR}/cloud-config.yml" > "${T}/cloud-config.yml" || die
}

src_install() {
	into "/usr/share/oem"
	dobin "${FILESDIR}/cloudstack-dhcp"
	dobin "${FILESDIR}/cloudstack-ssh-key"
	dobin "${FILESDIR}/cloudstack-coreos-cloudinit"
	dobin "${FILESDIR}/flatcar-setup-environment"

	insinto "/usr/share/oem"
	doins "${T}/cloud-config.yml"
	doins "${FILESDIR}/grub.cfg"
}
