#
# Copyright (c) 2015 CoreOS, Inc.. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
# $Header:$
#

EAPI=6

DESCRIPTION="Kubernetes Container Manager"
HOMEPAGE="http://kubernetes.io/"
KEYWORDS="amd64 arm64"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

# work around ${WORKDIR}/${P} not existing
S=${WORKDIR}

src_install() {
	exeinto /usr/lib/flatcar
	doexe "${FILESDIR}"/kubelet-wrapper
}
