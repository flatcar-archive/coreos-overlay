# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GITHUB_URI="github.com/opencontainers/runc"
COREOS_GO_PACKAGE="${GITHUB_URI}"
COREOS_GO_VERSION="go1.10"
# the commit of runc that docker uses.
# see https://github.com/docker/docker-ce/blob/v18.06.3-ce/components/engine/hack/dockerfile/install/runc.installer#L4
# Update the patch number when this commit is changed (i.e. the _p in the ebuild).
# The patch version is arbitrarily the number of commits since the tag version
# specified in the ebuild name. For example:
# $ git log --oneline v1.0.0-rc5..${COMMIT_ID} | wc -l
COMMIT_ID="425e105d5a03fabd737a126ad93d62a9eeede87f"

inherit eutils flag-o-matic coreos-go vcs-snapshot

SRC_URI="https://${GITHUB_URI}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 arm64"

DESCRIPTION="runc container cli tools (docker fork)"
HOMEPAGE="http://runc.io"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="ambient apparmor hardened +seccomp selinux"

RDEPEND="
	apparmor? ( sys-libs/libapparmor )
	seccomp? ( sys-libs/libseccomp )
	!app-emulation/runc
"

S=${WORKDIR}/${P}/src/${COREOS_GO_PACKAGE}

RESTRICT="test"

src_unpack() {
	mkdir -p "${S}"
	tar --strip-components=1 -C "${S}" -xf "${DISTDIR}/${A}"
}

PATCHES=(
	"${FILESDIR}/0001-Delay-unshare-of-clone-newipc-for-selinux.patch"
	"${FILESDIR}/0001-Add-static-hooks-opt-bin-runc-hook-prestart-poststar.patch"
	"${FILESDIR}/0001-temporarily-disable-selinux.GetEnabled-error-checks.patch"
	"${FILESDIR}/0001-cgroups-systemd-add-cgroup-v2-path-to-the-list-when-.patch"
)

src_compile() {
	# Taken from app-emulation/docker-1.7.0-r1
	export CGO_CFLAGS="-I${ROOT}/usr/include"
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')
		-L${ROOT}/usr/$(get_libdir)"

	# build up optional flags
	local options=(
		$(usex ambient 'ambient' '')
		$(usex apparmor 'apparmor' '')
		$(usex seccomp 'seccomp' '')
		$(usex selinux 'selinux' '')
	)

	GOPATH="${WORKDIR}/${P}" emake BUILDTAGS="${options[*]}" \
		VERSION=1.0.0-rc8+dev.docker-19.03 \
		COMMIT="${COMMIT_ID}"
}

src_install() {
	dobin runc
}
