# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

GITHUB_URI="github.com/kinvolk/linux"
# branch alban/bpftool-all
COMMIT_ID="98bb39c62ce2fda505265644f4ba33ab9584d452"

inherit eutils flag-o-matic vcs-snapshot

DESCRIPTION="bpftool"
HOMEPAGE="http://github.com/kinvolk/bpftool"

SRC_URI="https://github.com/kinvolk/linux/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 arm64"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	cd tools/bpf/bpftool/ && \
	sed -i '/CFLAGS += -O2/a CFLAGS += -static' Makefile && \
	sed -i 's/LIBS = -lelf $(LIBBPF)/LIBS = -lelf -lz $(LIBBPF)/g' Makefile && \
	printf 'feature-libbfd=0\nfeature-libelf=1\nfeature-bpf=1\nfeature-libelf-mmap=1' >> FEATURES_DUMP.bpftool && \
	FEATURES_DUMP=`pwd`/FEATURES_DUMP.bpftool make -j `getconf _NPROCESSORS_ONLN`
}

src_install() {
	dobin tools/bpf/bpftool/bpftool
}
