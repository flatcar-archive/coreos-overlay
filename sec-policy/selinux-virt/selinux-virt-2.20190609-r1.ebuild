# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

IUSE=""
MODS="virt"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for virt"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="~amd64 -arm ~arm64 ~mips ~x86"
fi

src_compile() {
	[ -z "${POLICY_TYPES}" ] && local POLICY_TYPES="targeted strict mls mcs"

	for i in ${POLICY_TYPES}; do
		cd "${S}/${i}" || die
		emake BINDIR="${ROOT}/usr/bin" NAME=$i SHAREDIR="${ROOT%/}"/usr/share/selinux \
			LD_LIBRARY_PATH="${ROOT}/usr/lib64:${LD_LIBRARY_PATH}" -C "${S}"/${i}
	done
}
