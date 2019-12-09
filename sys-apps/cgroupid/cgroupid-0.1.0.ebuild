# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

GITHUB_URI="github.com/kinvolk/cgroupid"
COMMIT_ID="04ba49daf6eed3ccfd6d147466b9f012de0227e7"
VERSION="v0.1.0"

inherit eutils flag-o-matic coreos-go-depend vcs-snapshot

DESCRIPTION="cgroupid"
HOMEPAGE="http://github.com/kinvolk/cgroupid"

SRC_URI="https://github.com/kinvolk/cgroupid/archive/${VERSION}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 arm64"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	emake COMMIT="${COMMIT_ID}"
}

src_install() {
	dobin cgroupid
}
