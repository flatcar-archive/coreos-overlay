# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="SBBR-compliant (UEFI+ACPI) AArch64 firmware for the Raspberry Pi 4"
HOMEPAGE="https://rpi4-uefi.dev/"
SRC_URI="https://github.com/pftf/RPi4/releases/download/v${PV}/RPi4_UEFI_Firmware_v${PV}.zip"

LICENSE=""
SLOT="0"
KEYWORDS="arm64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

RESTRICT="strip"
QA_PREBUILT="/boot/start4.elf"

S="${WORKDIR}"

src_install() {
	cp -R "${S}/" "${D}/boot" || die "Install failed!"
}
