# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="This project produces self-contained, highly-portable Python distributions."
HOMEPAGE="https://github.com/indygreg/python-build-standalone/"
SRC_URI="
	amd64? ( https://github.com/indygreg/python-build-standalone/releases/download/20220318/cpython-3.9.11+20220318-x86_64_v2-unknown-linux-gnu-install_only.tar.gz )
	arm64? ( https://github.com/indygreg/python-build-standalone/releases/download/20220318/cpython-3.9.11+20220318-aarch64-unknown-linux-gnu-install_only.tar.gz )
"
PYVER=$(ver_cut 1-2)

# TODO: many more licenses are needed
LICENSE="PSF-2"
SLOT="${PYVER}"
KEYWORDS="amd64 arm64"

# TODO: minimal host dependencies, may be we can express those?
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_install() {
	dodir /usr/share/oem
	cp -a ${S}/python ${ED}/usr/share/oem
	find ${ED} -name 'lib*.a' -delete
	dosym python3 /usr/share/oem/python/bin/python
	dosym lib /usr/share/oem/python/lib64
}
