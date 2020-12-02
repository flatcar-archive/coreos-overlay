#!/bin/bash
# Copyright (c) 2020 Kinvolk GmbH. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
#
# Vendor tools update checker. This script has 2 modes of operation.
#
# 1.) Download a new OEM tools tarball and store it on the vendor partition.
#     The script is called by update_engine in a post-hook and is passed
#     the base URL of the update server (includes the flatcar release version).
#     In this mode, the script will:
#     - remove existing tarballs from the vendor partition to make space
#     - download the new OEM tools tarball and store it on the vendor
#       partition. Extract tarball version information and store alongside
#       the tarball.
#
# 2.) Very early at boot, as soon as the root fs and vendor partition are mounted,
#     check/verify the Flatcar version running against the vendor partition
#     version.
#     If the version differs, look for a tarball in the vendor partition
#        with the correct version.
#        - If no tarball is found, bail.
#        - If an update tarball with the correct (running) version is found
#          - create a backup tarball from the current OEM partition
#          - clean all files from the partition
#          - install the update tarball
#          - store the backup tarball in the vendor partition (for roll back)

OEM_DIR="/usr/share/oem"
OEM_TARBALL_DIR="${OEM_DIR}/staging"
SCRIPT_NAME="$(basename $0)"
OEM_VERSION_FILE="flatcar-oem-release"

function log() {
    local severity="$1"
    shift # happens

    if [ "${severity}" = "DEBUG" -a "${DEBUG}" != "true" ] ; then
        return
    fi

    echo "$SCRIPT_NAME [$severity] $@" >&2

    if [ "${severity}" = "FATAL" ] ; then
        exit 1
    fi
}
# ---

function usage() {
    log INFO "${SCRIPT_NAME} - download or install OEM tools updates."
    log INFO "Usage:"
    log INFO " ${SCRIPT_NAME} [-u <url> -n <version>]"
    log INFO "   When called without arguments, check for currently running"
    log INFO "    version and compare to OEM tools version. If different,"
    log INFO "    check for an OEM update tarball at '${OEM_TARBALL_DIR} and"
    log INFO "    install if present."
    log INFO "   When called with both -u and -v, download new <version> from"
    log INFO "    <url>/${FLATCAR_OEM_FILE} and store to '${OEM_TARBALL_DIR}'"
}
# ---

# Remove build / dev appendix from version information,
#  e.g. "2705.0.0+2020-12-01-1406" => "2705.0.0"
# (needed to make things work for OS image dev builds)
function trim_flatcar_version() {
    local full_version="$1"
    echo "${full_version}" | sed 's/+.*//'
}
# ---

# Read OEM release info and lsb-release files, set
#  FLATCAR_OEM_VERSION - release version this OEM is for (trimmed)
#  FLATCAR_OEM_FILE    - tarball filename of this OEM
#  DISTRIB_ID          - ignored
#  DISTRIB_RELEASE     - Flatcar release version
#  DISTRIB_CODENAME    - ignored
#  DISTRIB_DESCRIPTION - ignored
function source_release_info() {
    local oem_info_file="${OEM_DIR}/${OEM_VERSION_FILE}"
    local flatcar_vinfo="/etc/lsb-release"

    [ -f "${oem_info_file}" ] \
        || log FATAL "Unable to find OEM release info at '${info_file}'"

    source "${oem_info_file}"

    [ -f "${flatcar_vinfo}" ] \
        || log FATAL "Unable to find Flatcar release info at '${flatcar_vinfo}'"

    source "${flatcar_vinfo}"

    FLATCAR_OEM_VERSION="$(trim_flatcar_version "${FLATCAR_OEM_VERSION}")"
    DISTRIB_RELEASE="$(trim_flatcar_version "${DISTRIB_RELEASE}")"
}
# ---

function download_update() {
    local url="$1/${FLATCAR_OEM_FILE}"
    local newversion="$2"
    local dest="${OEM_TARBALL_DIR}/${FLATCAR_OEM_FILE}"

    if [ -d "${OEM_TARBALL_DIR}" ] ; then
        log INFO "download: cleaning up OEM tarball: $(ls ${OEM_TARBALL_DIR})"
        rm -rf "${OEM_TARBALL_DIR}"
    fi

    mkdir "${OEM_TARBALL_DIR}"

    log INFO "download: fetching '${url}' => '${dest}'"
    wget -q "${url}" -O "${dest}" \
        || log FATAL "error downloading '${url}"

    # TODO: Verify checksum / check signature?

    log INFO "Validating OEM update tarball"
    tar xJf "${dest}" --to-stdout >/dev/null || {
        rm -rf "${OEM_TARBALL_DIR}"
        log FATAL "OEM update tarball validation failed after download."
    }

    # verify we doenloaded the correct version
    cd "${OEM_TARBALL_DIR}"
    tar xJf "${FLATCAR_OEM_FILE}" ./${OEM_VERSION_FILE}  \
        || log FATAL "Error extracting ${OEM_VERSION_FILE} from OEM tarball"
    source ./"${OEM_VERSION_FILE}"
    FLATCAR_OEM_VERSION="$(trim_flatcar_version "${FLATCAR_OEM_VERSION}")"
    if [ "${newversion}" != "${FLATCAR_OEM_VERSION}" ] ; then
        rm -rf "${OEM_TARBALL_DIR}"
        log FATAL "OEM update tarball version mismatch; want: '${newversion}', got: '${FLATCAR_OEM_VERSION}'"
    fi

    log INFO "Downloaded $(echo $(cat "${OEM_TARBALL_DIR}/${OEM_VERSION_FILE}"))"
}
# ---

function backup_oem_partition() {
    local oem_backup_tarball="$1"
    local exclude="$(basename "${OEM_TARBALL_DIR}")"

    log DEBUG "Backing up old OEM tools for roll-back to '${oem_backup_tarball}'"
    tar cJf "${oem_backup_tarball}" --exclude="${exclude}" \
        -C "${OEM_DIR}" . || log FATAL "Failed to create OEM tools backup"

    log DEBUG "Validating OEM roll-back tarball"
    tar xJf "${oem_backup_tarball}" --to-stdout >/dev/null || {
        rm -rf "${oem_backup_tarball}"
        log FATAL "OEM roll-back tarball validation failed."
    }

    log INFO "Created roll-back OEM tarball $(echo $(cat "${OEM_TARBALL_DIR}/${OEM_VERSION_FILE}"))"
}
# ---

function install_oem_update() {
    local exclude="$(basename "${OEM_TARBALL_DIR}")"
    local update_tarball="${OEM_TARBALL_DIR}/${FLATCAR_OEM_FILE}"

    log INFO "Removing old OEM tools from ${OEM_DIR}"
    cd "${OEM_DIR}"
    find . | grep -vE "^\./${exclude}" | grep -vE '^.$' | xargs rm -rf

    log INFO "Installing OEM tools update from ${update_tarball}"
    tar -xJf "${update_tarball}" \
        || log FATAL "Error installing update OEM tarball"

    log INFO "Installed OEM tools version $(echo $(cat "${OEM_DIR}/${OEM_VERSION_FILE}"))"
}
# ---

function store_rollback_oem_tarball() {
    local oem_backup_tarball="$1"

    log DEBUG "Cleaning up '${OEM_TARBALL_DIR}' to make room for roll-back backup"
    rm -rf "${OEM_TARBALL_DIR}"
    mkdir "${OEM_TARBALL_DIR}"

    log DEBUG "Storing rollback OEM version in '${OEM_TARBALL_DIR}'"
    mv "${oem_backup_tarball}" "${OEM_TARBALL_DIR}"
    cd "${OEM_TARBALL_DIR}"
    tar xJf "${FLATCAR_OEM_FILE}" ./${OEM_VERSION_FILE}  \
        || log FATAL "Error extracting ${OEM_VERSION_FILE} from OEM tarball"

    log INFO "Stored rollback version $(echo $(cat "${OEM_TARBALL_DIR}/${OEM_VERSION_FILE}"))"
}
# ---

function check_update_oem() {
    if [ "${FLATCAR_OEM_VERSION}" = "${DISTRIB_RELEASE}" ] ; then
        log DEBUG "OEM '${FLATCAR_OEM_VERSION}' == flatcar '${DISTRIB_RELEASE}', nothing to do"
        log INFO "OEM tools version '${FLATCAR_OEM_VERSION}' matches flatcar version '${DISTRIB_RELEASE}'."
        return
    fi

    log INFO "Flatcar version != OEM tools version ('${DISTRIB_RELEASE}' != '${FLATCAR_OEM_VERSION}')"
    log INFO "Checking for OEM update tarball"

    local newversion_file="${OEM_TARBALL_DIR}/${OEM_VERSION_FILE}"
    [ ! -f "${newversion_file}" ] \
        && log FATAL "Update OEM version file '${newversion_file}' missing!"

    cd "${OEM_TARBALL_DIR}"

    local old_oem_version="${FLATCAR_OEM_VERSION}"
    source "${newversion_file}"
    FLATCAR_OEM_VERSION="$(trim_flatcar_version "${FLATCAR_OEM_VERSION}")"
    log INFO "Found OEM update tarball version '${FLATCAR_OEM_VERSION}'"

    if [ "${FLATCAR_OEM_VERSION}" != "${DISTRIB_RELEASE}" ] ; then
        log FATAL "Update tarball OEM version '${FLATCAR_OEM_VERSION}' != flatcar version '${DISTRIB_RELEASE}'!"
    fi

    local oem_backup="$(mktemp -d)/${FLATCAR_OEM_FILE}"
    backup_oem_partition "${oem_backup}"
    install_oem_update
    store_rollback_oem_tarball "${oem_backup}"
    sync -f "${OEM_DIR}"
}
# ---

function check_update_vendortools() {
    local url
    local newversion

    # does this OEM support updates?
    [ -f "${OEM_DIR}/${OEM_VERSION_FILE}" ] || return

    source_release_info

    local allargs="$@"
    while [ $# -gt 0 ]; do
        case $1 in
            '-d') DEBUG=true;;
            '-u') shift; url="$1";;
            '-n') shift; newversion="$(trim_flatcar_version "$1")";;
            '-h') usage; exit;;
            *) log FATAL "Unknown argument '$1' (in ${allargs})";;
        esac
        shift
    done

    log DEBUG "check_update_vendortools called with $allargs"
    log DEBUG "FLATCAR_OEM_VERSION='${FLATCAR_OEM_VERSION}'"
    log DEBUG "FLATCAR_OEM_FILE='${FLATCAR_OEM_FILE}'"
    log DEBUG "DISTRIB_RELEASE='${DISTRIB_RELEASE}'"

    if [ -n "${url}" -a -z "${newversion}"  \
         -o -z "${url}" -a -n "${newversion}" ] ; then
        log FATAL "-u or -v missing, got -u '${url}' -v '${newversion}'"
    fi

    if [ "$newversion" ] ; then
        # called from update_engine post hook; download & store tarball
        log INFO "Checking for version '${newversion}' update at '${url}'"
        download_update "${url}" "${newversion}"
        exit 0
    fi

    # called via systemd unit early at boot; check if oem needs update
    check_update_oem
}
# ---

# make ourselves source-able
if [ "${SCRIPT_NAME}" = "check-update-vendortools.sh" ] ; then
    check_update_vendortools $@
else
    true
fi
