# Copyright (c) 2020 Kinvolk GmbH. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NVIDIA drivers"
HOMEPAGE=""
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

# no source directory
S="${WORKDIR}"

# The install-nvidia script is using emerge-gitclone, but this script is only
# invoked within the developer container, so we don't need to add the
# coreos-base/gmerge package here. All the dependencies below come from the
# setup-nvidia script, which is run on the host.
RDEPEND="
app-arch/bzip2
app-shells/bash
net-misc/curl
sys-apps/coreutils
sys-apps/grep
sys-apps/kmod
sys-apps/pciutils
sys-apps/systemd
sys-libs/glibc
"

src_install() {
  insinto "/usr/share/oem"
  doins -r "${FILESDIR}/units"
  exeinto "/usr/share/oem/bin"
  doexe "${FILESDIR}/bin/install-nvidia"
  doexe "${FILESDIR}/bin/setup-nvidia"
}
