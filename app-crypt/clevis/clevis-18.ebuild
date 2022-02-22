# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 meson systemd

DESCRIPTION="Clevis is a pluggable framework for automated decryption"
HOMEPAGE="https://github.com/latchset/clevis"
SRC_URI="https://github.com/latchset/clevis/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"
IUSE="audit +luks systemd udisks"

BDEPEND="app-text/asciidoc
	luks? (
		dev-libs/libpwquality:0=
	)
"
DEPEND="
	audit? ( >=sys-process/audit-2.7.8:0= )
	systemd? ( sys-apps/systemd:= )
	luks? (
		>=sys-fs/cryptsetup-2.0.4
		>=dev-libs/luksmeta-8
		dev-libs/libpwquality:0=
	)
	>=dev-libs/jansson-2.10
	>=dev-libs/jose-8
	sys-kernel/dracut
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-openssl-3.patch"
	"${FILESDIR}/${P}-meson-systemd-sysroot.patch"
	"${FILESDIR}/${P}-meson-options.patch"
)

src_configure() {
	local emesonargs=(
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Dcompletionsdir="$(get_bashcompdir)"
		-Ddracutmodulesdir="${EPREFIX}/lib/dracut/modules.d"
	)
	meson_src_configure
}
