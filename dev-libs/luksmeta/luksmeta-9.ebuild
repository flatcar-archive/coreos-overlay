# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="LUKSMeta is a simple library for storing metadata in the LUKSv1 header."
HOMEPAGE="https://github.com/latchset/luksmeta"
SRC_URI="https://github.com/latchset/luksmeta/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"
IUSE=""

BDEPEND="
	app-text/asciidoc
	virtual/pkgconfig
"
DEPEND=">=sys-fs/cryptsetup-1.5.1"
RDEPEND="${DEPEND}"

src_prepare() {
	tc-export PKG_CONFIG
	default
}
