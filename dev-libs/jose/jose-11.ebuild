# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson

DESCRIPTION="José is a C-language implementation of the Javascript Object Signing and Encryption standards."
HOMEPAGE="https://github.com/latchset/jose"
SRC_URI="https://github.com/latchset/jose/releases/download/v${PV}/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"
IUSE=""

BDEPEND="app-text/asciidoc"
DEPEND="
	>=dev-libs/jansson-2.10
	>=dev-libs/openssl-1.0.2:0=
	sys-libs/zlib:0=
"
RDEPEND="${DEPEND}"
