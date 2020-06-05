# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic

DESCRIPTION="bpftool"
HOMEPAGE="http://www.kernel.org/"

LINUX_V="${PV:0:1}.x"
LINUX_VER=${PV}
KEYWORDS="amd64 arm64"
LINUX_SOURCES="linux-${LINUX_VER}.tar.xz"
SRC_URI="https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/${LINUX_SOURCES}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/elfutils[static-libs]
"
RDEPEND=""

S_K="${WORKDIR}/linux-${LINUX_VER}"
S="${S_K}/tools/bpf"

src_unpack() {
	local paths=(
		tools/arch tools/bpf tools/build tools/include tools/lib tools/perf tools/scripts
		include kernel/bpf lib scripts
	)

	echo ">>> Unpacking ${LINUX_SOURCES} (${paths[*]}) to ${PWD}"
	tar --wildcards -xpf "${DISTDIR}"/${LINUX_SOURCES} \
		"${paths[@]/#/linux-${LINUX_VER}/}" || die
}

src_compile() {
	cd bpftool/ && \
	sed -i '/CFLAGS += -O2/a CFLAGS += -static' Makefile && \
	sed -i 's/LIBS = -lelf $(LIBBPF)/LIBS = -lelf -lz $(LIBBPF)/g' Makefile && \
	printf 'feature-libbfd=0\nfeature-libelf=1\nfeature-bpf=1\nfeature-libelf-mmap=1\nfeature-zlib=1' >> FEATURES_DUMP.bpftool && \
	FEATURES_DUMP=`pwd`/FEATURES_DUMP.bpftool make -j `getconf _NPROCESSORS_ONLN`
}

src_install() {
	dobin bpftool/bpftool
}
