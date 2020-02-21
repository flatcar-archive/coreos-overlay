#!/bin/bash

set -euo pipefail

branch="go-${VERSION_NEW}"

pushd ~/flatcar-sdk/src/third_party/coreos-overlay || exit
git checkout -B "${branch}" "github/${BASE_BRANCH}"

versionOld=$(sed -n "s/^DIST go\(${GO_VERSION}.[0-9]*\).*/\1/p" dev-lang/go/Manifest | sort -ruV | head -n1)
[[ "${VERSION_NEW}" = "${versionOld}" ]] && echo "already the latest Go, nothing to do" && exit 1

pushd "dev-lang/go" >/dev/null || exit
git mv $(ls -1 go-${versionOld}*.ebuild | sort -ruV | head -n1) "go-${VERSION_NEW}.ebuild"
popd >/dev/null || exit

( cd ../../..; exec cork enter -- ebuild "/mnt/host/source/src/third_party/coreos-overlay/dev-lang/go/go-${VERSION_NEW}.ebuild" manifest --force )

# We can only create the actual commit in the actual source directory, not under the SDK.
# So create a format-patch, and apply to the actual source.
git add dev-lang/go/go-${VERSION_NEW}*
git commit -a -m "dev-lang/go: Upgrade Go ${versionOld} to ${VERSION_NEW}"
git format-patch -1 --stdout HEAD > "${branch}".patch
popd || exit

git config user.name 'Flatcar Buildbot'
git config user.email 'buildbot@flatcar-linux.org'
git reset --hard HEAD
git fetch origin
git checkout -B "${BASE_BRANCH}" "origin/${BASE_BRANCH}"
git am ~/flatcar-sdk/src/third_party/coreos-overlay/"${branch}".patch

echo ::set-output name=VERSION_OLD::"${versionOld}"
