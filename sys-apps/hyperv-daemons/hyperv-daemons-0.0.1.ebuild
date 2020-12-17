# Copyright (c) 2020 Kinvolk GmbH. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KERNEL_DIR="${SYSROOT}/usr/src/linux"
inherit linux-info savedconfig systemd

DESCRIPTION="Hyper-V daemons utilities"
HOMEPAGE=""
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
  sys-kernel/coreos-kernel
"

src_unpack() {
  mkdir -p "${S}"/src
}

src_compile() {
  gcc -c "${KERNEL_DIR}"/tools/hv/hv_kvp_daemon.c -o "${S}"/src/hv_kvp_daemon
  gcc -c "${KERNEL_DIR}"/tools/hv/hv_vss_daemon.c -o "${S}"/src/hv_vss_daemon
  gcc -c "${KERNEL_DIR}"/tools/hv/hv_fcopy_daemon.c -o "${S}"/src/hv_fcopy_daemon
}

src_install() {
  dosbin src/hv_kvp_daemon
  dosbin src/hv_vss_daemon
  dosbin src/hv_fcopy_daemon
	systemd_dounit $"{FILESDIR}"/units

}

