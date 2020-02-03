#!/usr/bin/env bash

fail="no"

bad="$(echo -e '\e[31m * \e[0m')"
good="$(echo -e '\e[32m * \e[0m')"

defer_failure() {
    echo "${bad}$@"
    fail="yes"
}

assert_true() {
    [ "$?" -ne 0 ] && defer_failure "$@"
}

assert_false() {
    [ "$?" -eq 0 ] && defer_failure "$@"
}

check_no_tarball() {
    tarball_name="${1}"
    shift

    for i in "$@"; do
	manifest="${i}/Manifest"
	grep -Hn "${tarball_name}" "${manifest}"
	assert_false "${manifest} contains a ${tarball_name} tarball"
    done
}

check_libbe_slot() {
    for i in sys-fs/zfs*/zfs*.ebuild; do
	grep -Hn 'SLOT=' "${i}" | grep -v "/libbe"; assert_false "${i} has a non-libbe SLOT"
    done
}

check_depend_on_libbe() {
    for i in */*/*.ebuild; do
	grep -Hn sys-fs/zfs "${i}" | grep -v "DESCRIPTION\|zfs-fuse" | grep -v "/libbe"
	assert_false "${i} depends on non-libbe zfs{,-kmod}"
    done
}

check_stable_doing_git() {
    double_indent=$'\t\t'
    for i in $(ls -1 sys-fs/zfs*/zfs*.ebuild | grep -v 9999); do
	grep -q "^inherit .*git" "${i}"; assert_true "${i} does not inherit autotools unconditionally"
	grep -q "^EGIT_REPO_URI" "${i}"; assert_true "{i} does not set EGIT_REPO_URI unconditionally"

	grep -q "^inherit .*autotools" "${i}"; assert_true "${i} does not inherit autotools unconditionally"
	grep -Hn "eautoreconf" "${i}" | grep "${double_indent}"; assert_false "${i} does not run eautoreconf unconditionally"
    done
}

check_fetching_from_linux_be() {
    for i in $(ls -1 */*/*.ebuild | grep -v spl); do
	grep -Hn 'EGIT_REPO_URI=' "${i}" | grep -v "gitlab.com/linux-be/"; assert_false "${i} uses a non-linux-be git URI"
    done
}

check_stable_fetching_from_tag() {
    for i in $(ls -1 sys-fs/zfs*/zfs*.ebuild | grep -v 9999); do
	grep -q '^EGIT_COMMIT="zfs-${PV}-beadm"' "${i}"; assert_true "${i} does not fetch from the stable git tag"
    done
}

check_live_checking_version() {
    for i in sys-fs/zfs*/zfs*.9999*.ebuild; do
	grep -Hn -E "(if|\[).*9999" "${i}" | grep -v '*"9999"'; assert_false "${i} checks for a 9999 version too strictly"
    done
}

check_zfs_useflags() {
    for i in sys-kernel/genkernel/*.ebuild sys-boot/grub/*.ebuild; do
	grep -Hn 'IUSE=' "${i}" | grep -v "zfs"; assert_false "${i} does not have a zfs* useflag"
    done
}

check_live_with_no_stable_patches() {
    for i in */*/*9999*.ebuild; do
	grep -Hn -E "(PV|[0-9]+.[0-9]+.[0-9]+).*\.patch" "${i}"; assert_false "${i} live ebuild uses a patch for a patch release"
    done
}


check_fetching_from_linux_be
check_stable_fetching_from_tag
check_live_checking_version
check_libbe_slot
check_depend_on_libbe
check_stable_doing_git
check_zfs_useflags
check_live_with_no_stable_patches

check_no_tarball zfs sys-fs/zfs*
check_no_tarball genkernel sys-kernel/genkernel
check_no_tarball grub sys-boot/grub


if [ "$fail" = yes ]; then
    echo "${bad}sanity check failed (see assertions above)"
    exit 1
else
    echo "${good}sanity check passed"
fi
