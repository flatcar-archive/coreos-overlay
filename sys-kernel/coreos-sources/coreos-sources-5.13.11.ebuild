# Copyright 2014 CoreOS, Inc.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
ETYPE="sources"

# -rc releases should be versioned L.M_rcN
# Final releases should be versioned L.M.N, even for N == 0

# Only needed for RCs
K_BASE_VER="5.10"

inherit kernel-2
EXTRAVERSION="-flatcar"
detect_version

DESCRIPTION="Full sources for the CoreOS Linux kernel"
HOMEPAGE="http://www.kernel.org"
if [[ "${PV%%_rc*}" != "${PV}" ]]; then
	SRC_URI="https://git.kernel.org/torvalds/p/v${KV%-coreos}/v${OKV} -> patch-${KV%-coreos}.patch ${KERNEL_BASE_URI}/linux-${OKV}.tar.xz"
	PATCH_DIR="${FILESDIR}/${KV_MAJOR}.${KV_PATCH}"
else
	SRC_URI="${KERNEL_URI}"
	PATCH_DIR="${FILESDIR}/${KV_MAJOR}.${KV_MINOR}"
fi

KEYWORDS="amd64 arm64"
IUSE=""

# XXX: Note we must prefix the patch filenames with "z" to ensure they are
# applied _after_ a potential patch-${KV}.patch file, present when building a
# patchlevel revision.  We mustn't apply our patches first, it fails when the
# local patches overlap with the upstream patch.
UNIPATCH_LIST="
	${PATCH_DIR}/z0001-kbuild-derive-relative-path-for-srctree-from-CURDIR.patch \
	${PATCH_DIR}/z0002-tools-objtool-Makefile-Don-t-fail-on-fallthrough-wit.patch \
	${PATCH_DIR}/z0003-kernel.h-split-out-panic-and-oops-helpers.patch \
	${PATCH_DIR}/z0004-Drivers-hv-Move-Hyper-V-extended-capability-check-to.patch \
	${PATCH_DIR}/z0005-asm-generic-hyperv-Add-missing-include-of-nmi.h.patch \
	${PATCH_DIR}/z0006-Drivers-hv-Make-portions-of-Hyper-V-init-code-be-arc.patch \
	${PATCH_DIR}/z0007-Drivers-hv-Add-arch-independent-default-functions-fo.patch \
	${PATCH_DIR}/z0008-Drivers-hv-Move-Hyper-V-misc-functionality-to-arch-n.patch \
	${PATCH_DIR}/z0009-drivers-hv-Decouple-Hyper-V-clock-timer-code-from-VM.patch \
	${PATCH_DIR}/z0010-arm64-smccc-Add-support-for-SMCCCv1.2-extended-input.patch \
	${PATCH_DIR}/z0011-arm64-hyperv-Add-Hyper-V-hypercall-and-register-acce.patch \
	${PATCH_DIR}/z0012-arm64-hyperv-Add-panic-handler.patch \
	${PATCH_DIR}/z0013-arm64-hyperv-Initialize-hypervisor-on-boot.patch \
	${PATCH_DIR}/z0014-arm64-efi-Export-screen_info.patch \
	${PATCH_DIR}/z0015-Drivers-hv-Enable-Hyper-V-code-to-be-built-on-ARM64.patch \
	${PATCH_DIR}/z0016-TEMP-Workaround-for-No-full-ARM64-Generic-Timer.patch \
"
