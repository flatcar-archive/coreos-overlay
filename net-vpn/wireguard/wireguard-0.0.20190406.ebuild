# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1

DESCRIPTION="Simple yet fast and modern VPN that utilizes state-of-the-art cryptography."
HOMEPAGE="https://www.wireguard.com/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.zx2c4.com/WireGuard"
	KEYWORDS=""
else
	SRC_URI="https://git.zx2c4.com/WireGuard/snapshot/WireGuard-${PV}.tar.xz"
	S="${WORKDIR}/WireGuard-${PV}"
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+tools"

DEPEND="tools? ( net-libs/libmnl )"
RDEPEND="${DEPEND}"

wg_quick_optional_config_nob() {
	CONFIG_CHECK="$CONFIG_CHECK ~$1"
	declare -g ERROR_$1="CONFIG_$1: This option is required for automatic routing of default routes inside of wg-quick(8), though it is not required for general WireGuard usage."
}

pkg_setup() {
	if use tools; then
		wg_quick_optional_config_nob IP_ADVANCED_ROUTER
		wg_quick_optional_config_nob IP_MULTIPLE_TABLES
		wg_quick_optional_config_nob NETFILTER_XT_MARK
	fi
}

src_compile() {
	use tools && emake RUNSTATEDIR="${EPREFIX}/run" -C src/tools CC="$(tc-getCC)" LD="$(tc-getLD)"
}

src_install() {
	if use tools; then
		emake \
			WITH_BASHCOMPLETION=yes \
			WITH_SYSTEMDUNITS=yes \
			WITH_WGQUICK=yes \
			DESTDIR="${D}" \
			BASHCOMPDIR="$(get_bashcompdir)" \
			PREFIX="${EPREFIX}/usr" \
			-C src/tools install
	fi
}

pkg_postinst() {
	einfo
	einfo "This software is experimental and has not yet been released."
	einfo "As such, it may contain significant issues. Please do not file"
	einfo "bug reports with Gentoo, but rather direct them upstream to:"
	einfo
	einfo "    team@wireguard.com    security@wireguard.com"
	einfo
}
