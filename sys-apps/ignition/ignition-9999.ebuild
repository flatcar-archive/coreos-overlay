# Copyright (c) 2015 CoreOS, Inc.. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_PROJECT="coreos/ignition"
CROS_WORKON_LOCALNAME="ignition"
CROS_WORKON_REPO="https://github.com"
COREOS_GO_PACKAGE="github.com/flatcar/ignition/v2"
COREOS_GO_GO111MODULE="off"
inherit coreos-go cros-workon systemd udev

if [[ "${PV}" == 9999 ]]; then
	KEYWORDS="~amd64 ~arm64"
else
	CROS_WORKON_COMMIT="d5545707b879e507749efed89881f987bd0ec81e" # main
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
	"${FILESDIR}/0001-sed-s-coreos-flatcar-linux.patch"
	"${FILESDIR}/0002-mod-add-ign-converter-dependency.patch"
	"${FILESDIR}/0003-sum-go-mod-tidy.patch"
	"${FILESDIR}/0004-vendor-go-mod-vendor.patch"
	"${FILESDIR}/0005-config-v3_4-convert-ignition-2.x-to-3.1.patch"
	"${FILESDIR}/0006-internal-prv-cmdline-backport-flatcar-patche.patch"
	"${FILESDIR}/0007-provider-qemu-apply-fw_cfg-patch.patch"
	"${FILESDIR}/0008-config-3_4-test-add-ignition-2.x-test-cases.patch"
	"${FILESDIR}/0009-internal-disk-fs-ignore-fs-format-mismatches-for-the.patch"
	"${FILESDIR}/0010-VMware-Fix-guestinfo.-.config.data-and-.config.url-v.patch"
	"${FILESDIR}/0011-config-version-handle-configuration-version-1.patch"
	"${FILESDIR}/0012-config-util-add-cloud-init-detection-to-initial-pars.patch"
	"${FILESDIR}/0013-Revert-drop-OEM-URI-support.patch"
	"${FILESDIR}/0014-internal-resource-url-support-btrfs-as-OEM-partition.patch"
	"${FILESDIR}/0015-internal-exec-stages-disks-prevent-races-with-udev.patch"
	"${FILESDIR}/0016-update-ign-converter-to-fix-link-translation.patch"
	"${FILESDIR}/0017-mod-update-ign-converter.patch"
	"${FILESDIR}/0018-mod-bump-ign-converter-to-pull-networkd-fix.patch"
	"${FILESDIR}/0019-config-add-ignition-translation.patch"
)

src_compile() {
	export GO15VENDOREXPERIMENT="1"
	GO_LDFLAGS="-X github.com/flatcar/ignition/v2/internal/version.Raw=${PV} -X github.com/flatcar/ignition/v2/internal/distro.selinuxRelabel=false" || die
	go_build "${COREOS_GO_PACKAGE}/internal"
}

src_install() {
	newbin ${GOBIN}/internal ${PN}
}
