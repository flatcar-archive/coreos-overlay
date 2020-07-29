# Copyright (c) 2017-2018 CoreOS, Inc.. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2

DESCRIPTION="Packages to be installed in a torcx image for Docker"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64"

# Explicitly list all packages that will be built into the image.
RDEPEND="
	~app-emulation/docker-19.03.12
	~app-emulation/containerd-1.3.6
	~app-emulation/docker-proxy-0.8.0_p20180709
	~app-emulation/docker-runc-1.0.0_rc91
	=dev-libs/libltdl-2.4.6
	=sys-process/tini-0.18.0
"

src_install() {
	insinto /.torcx
	newins "${FILESDIR}/${P}-manifest.json" manifest.json

	# Enable the Docker socket by default.
	local unitdir=/usr/lib/systemd/system
	dosym ../docker.socket "${unitdir}/sockets.target.wants/docker.socket"
}
