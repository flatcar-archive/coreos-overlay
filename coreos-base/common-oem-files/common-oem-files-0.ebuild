# Copyright (c) 2023 The Flatcar Maintainers.
# Distributed under the terms of the GNU General Public License v2

EAPI=8

OEMIDS=(
    azure
)

DESCRIPTION='Common OEM files'
HOMEPAGE='https://www.flatcar.org/'

LICENSE='Apache-2.0'
SLOT='0'
KEYWORDS='amd64 arm64'
IUSE="${OEMIDS[*]}"
REQUIRED_USE="^^ ( ${OEMIDS[*]} )"

# No source directory.
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	app-portage/gentoolkit
"

src_compile() {
    local oemid package ebuild version name homepage lines

    for oemid in "${OEMIDS[@]}"; do
        if use "${oemid}"; then break; fi
    done

    package="coreos-base/oem-${oemid}"
    ebuild=$(equery which "${package}")
    version=${path##*"oem-${oemid}-"}
    version=${version%%'.ebuild'}
    name=$(source <(grep -F 'OEM_NAME=' "${ebuild}"); echo "${OEM_NAME}")
    if [[ -z "${name}" ]]; then
        die "Missing OEM_NAME variable in ${ebuild##*/}"
    fi
    homepage=$(source <(grep -F 'HOMEPAGE=' "${ebuild}"); echo "${HOMEPAGE}")
    lines=(
        "ID=${oemid}"
        "VERSION_ID=${version}"
        "NAME=\"${name}\""
        'BUG_REPORT_URL="https://issues.flatcar.org"'
    )
    if [[ -n "${homepage}" ]]; then
        lines+=( "HOME_URL=\"${homepage}\"" )
    fi
    lines+=(
        'BUG_REPORT_URL="https://issues.flatcar.org"'
    )

    {
        printf '%s\n' "${lines[@]}"
        if [[ -e "${FILESDIR}/${oemid}/oem-release.frag" ]]; then
            cat "${FILESDIR}/${oemid}/oem-release.frag"
        fi
    } >"${T}/oem-release"

    lines=(
        '# Flatcar GRUB settings'
        ''
        "set oem_id=\"${oemid}\""
    )
    {
        printf '%s\n' "${lines[@]}"
        if [[ -e "${FILESDIR}/${oemid}/grub.cfg.frag" ]]; then
            cat "${FILESDIR}/${oemid}/grub.cfg.frag"
        fi
    } >"${T}/grub.cfg"
}

src_install() {
    insinto "/usr/share/oem"
    doins "${T}/grub.cfg"
    doins "${T}/oem-release"
}
